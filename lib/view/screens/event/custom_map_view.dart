import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: implementation_imports, unused_import
import 'package:google_maps_place_picker_mb/src/google_map_place_picker.dart'; // do not import this yourself
import 'dart:io' show Platform;

// Only to control hybrid composition and the renderer in Android
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;

  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";

  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      switch (_mapsRenderer) {
        case "legacy":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.legacy);
          break;
        case "latest":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.latest);
          break;
      }
    }
    setState(() {
      _mapsInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_mapsInitialized &&
                  widget.mapsImplementation is GoogleMapsFlutterAndroid) ...[
                Switch(
                    value:
                        (widget.mapsImplementation as GoogleMapsFlutterAndroid)
                            .useAndroidViewSurface,
                    onChanged: (value) {
                      setState(() {
                        (widget.mapsImplementation as GoogleMapsFlutterAndroid)
                            .useAndroidViewSurface = value;
                      });
                    }),
                Text("Hybrid Composition"),
              ]
            ],
          ),
          !_showPlacePickerInContainer
              ? ElevatedButton(
                  child: Text("Load Place Picker"),
                  onPressed: () {
                    initRenderer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            resizeToAvoidBottomInset:
                                false, // only works in page mode, less flickery
                            apiKey: Platform.isAndroid
                                ? "AIzaSyDHiCMDyLm8A01RQrPZYZSouUjGVU6C5sE"
                                : "AIzaSyDHiCMDyLm8A01RQrPZYZSouUjGVU6C5sE",
                            hintText: "Find a place ...",
                            searchingText: "Please wait ...",
                            selectText: "Select place",
                            outsideOfPickAreaText: "Place not in area",
                            initialPosition: HomePage.kInitialPosition,
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePinPointingSearch: true,
                            usePlaceDetailSearch: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            ignoreLocationPermissionErrors: true,
                            onMapCreated: (GoogleMapController controller) {
                              print("Map created");
                            },
                            onPlacePicked: (PickResult result) {
                              print("Place picked: ${result.formattedAddress}");
                              setState(() {
                                selectedPlace = result;
                                Navigator.of(context).pop();
                              });
                            },
                            onMapTypeChanged: (MapType mapType) {
                              print(
                                  "Map type changed to ${mapType.toString()}");
                            },
                          );
                        },
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    ));
  }
}
