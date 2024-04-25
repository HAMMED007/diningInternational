// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, must_be_immutable

import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaa/view/screens/event/custom_map_view.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../controller/event/event_create_controller.dart';
import '../../../core/globals/global_functions.dart';
import '../../../core/globals/global_variables.dart';
import '../../widget/Custom_Textfield_widget.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';
import '../../widget/custom_circular_indicator.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
}

class _CreateEventState extends State<CreateEvent> {
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

  EventCreateController eventCreateController = Get.find();

  String _formatTime(TimeOfDay timeOfDay) {
    String period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    int hour = timeOfDay.hourOfPeriod;
    String minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Image.asset(
                Assets.imagesRefresh,
                height: h(context, 45),
                width: w(context, 42),
              ),
              onPressed: () {},
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                Assets.imagesBell,
                height: h(context, 23),
                width: w(context, 17),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: symmetric(
            context,
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomText(
                  text: "Create an event",
                  size: 19,
                  color: kPrimaryColor.withOpacity(0.71),
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: h(context, 60),
              ),
              CustomText(
                text: "Search venues/ hangout spots",
                size: 13,
                color: Color(0xff575757),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 11),
              ),
              GestureDetector(
                onTap: () {
                  initRenderer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          resizeToAvoidBottomInset: false,
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
                          onMapCreated: (GoogleMapController controller) {},
                          onPlacePicked: (PickResult result) {
                            log("Place picked: ${result.formattedAddress}");
                            eventCreateController.eventTitleTextController
                                .text = "${result.formattedAddress}";

                            setState(() {
                              selectedPlace = result;
                              Navigator.of(context).pop();
                            });
                          },
                        );
                      },
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextField3(
                    onChanged: (value) {},
                    controller: eventCreateController.eventTitleTextController,
                    hintText: 'Simply type a name or location ',
                  ),
                ),
              ),
              SizedBox(
                height: h(context, 12),
              ),
              CustomText(
                text: "Add link to restaurant menu",
                size: 13,
                color: Color(0xff575757),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 8),
              ),
              CustomTextField(
                onChanged: (value) {},
                controller: eventCreateController.eventLinkTextController,
                hintText: 'Simply type a name or location ',
              ),
              SizedBox(
                height: h(context, 12),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Date",
                          size: 13,
                          color: Color(0xff575757),
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: h(context, 8),
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2025),
                              cancelText:
                                  "Cancel", // Set the text for the cancel button
                            );
                            if (selectedDate != null) {
                              // If a date is selected, update the text field's controller
                              eventCreateController
                                      .eventDateTextController.text =
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                            } else {
                              // If the user cancels, clear the text field's controller
                              eventCreateController
                                  .eventDateTextController.text = '';
                            }
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              controller:
                                  eventCreateController.eventDateTextController,
                              hintText: 'DD/MM/YYYY',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: w(context, 40),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Time",
                          size: 13,
                          color: Color(0xff575757),
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: h(context, 8),
                        ),
                        GestureDetector(
                          onTap: () {
                            Future<TimeOfDay?> startTime = showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            Future<TimeOfDay?> endTime = showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            // Handle both start and end times
                            Future.wait([startTime, endTime])
                                .then((List<TimeOfDay?> times) {
                              if (times[0] != null && times[1] != null) {
                                String formattedStartTime =
                                    _formatTime(times[0]!);
                                String formattedEndTime =
                                    _formatTime(times[1]!);
                                String formattedTimeRange =
                                    '$formattedStartTime - $formattedEndTime';
                                eventCreateController.eventTimeTextController
                                    .text = formattedTimeRange;
                              }
                            });
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller:
                                  eventCreateController.eventTimeTextController,
                              decoration: InputDecoration(
                                hintText: 'Select Time Range',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h(context, 10),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Max. Attendees",
                          size: 13,
                          color: Color(0xff575757),
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: h(context, 8),
                        ),
                        CustomTextField(
                          onChanged: (value) {},
                          controller: eventCreateController
                              .eventAttendeesTextController,
                          hintText: 'E.g.: 15',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: w(context, 40),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Upload your picture",
                          size: 13,
                          color: Color(0xff575757),
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: h(context, 11),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => eventCreateController.selectedImage.value ==
                                      null
                                  ? GestureDetector(
                                      onTap: () async {
                                        eventCreateController
                                                .selectedImage.value =
                                            await eventCreateController
                                                .pickImageFromGallery();
                                      },
                                      child: CommonImageView(
                                        imagePath: Assets.imagesUpload,
                                        fit: BoxFit.contain,
                                        height: h(context, 25),
                                        width: w(context, 30),
                                      ),
                                    )
                                  : CommonImageView(
                                      file: eventCreateController
                                          .selectedImage.value,
                                      fit: BoxFit.contain,
                                      height: h(context, 25),
                                      width: w(context, 30),
                                    ),
                            ),
                            CustomText(
                              text: "Jpeg or png",
                              size: 12,
                              color: Color.fromRGBO(135, 135, 135, 0.60),
                              paddingLeft: 11,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h(context, 10),
              ),
              Row(
                children: [
                  AgreementCheckbox(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AgreementCheckbox extends StatefulWidget {
  @override
  _AgreementCheckboxState createState() => _AgreementCheckboxState();
}

class _AgreementCheckboxState extends State<AgreementCheckbox> {
  bool isChecked = false;
  EventCreateController eventCreateController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
            CustomText(
              text: "I agree to all the",
              size: 12,
              color: Color(0xff575757),
              weight: FontWeight.w300,
            ),
            CustomText(
              text: "Terms & Conditions",
              size: 12,
              color: Color(0xff575757),
              weight: FontWeight.w700,
            ),
          ],
        ),
        SizedBox(
          height: h(context, 10),
        ),
        Obx(
          () => eventCreateController.isLoading.value
              ? Center(
                  child: CustomCircularIndicator(
                    containerColor: Colors.transparent,
                    indicatorColor: kTertiaryColor,
                  ),
                )
              : CustomButton2(
                  firstText: "Create event",
                  secText: "",
                  onTap: () async {
                    // Validate all text fields and isChecked boolean
                    if (eventCreateController
                            .eventTitleTextController.text.isEmpty ||
                        eventCreateController
                            .eventLinkTextController.text.isEmpty ||
                        eventCreateController
                            .eventDateTextController.text.isEmpty ||
                        eventCreateController
                            .eventTimeTextController.text.isEmpty ||
                        eventCreateController
                            .eventAttendeesTextController.text.isEmpty ||
                        !isChecked) {
                      // Show a snackbar or any other appropriate feedback to the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(
                              'Please fill in all fields and accept terms and conditions.'),
                        ),
                      );
                    } else {
                      // All fields are filled and checkbox is checked, proceed to create event
                      bool isSuccess =
                          await eventCreateController.createEvent();
                      // Proceed based on the result of event creation
                      if (isSuccess) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CustomDialogCreateEvent(
                            imagePath:
                                eventCreateController.selectedImage.value!,
                            address: eventCreateController
                                .eventLinkTextController.text,
                            totalAttendees: int.parse(eventCreateController
                                .eventAttendeesTextController.text),
                            date: eventCreateController
                                .eventDateTextController.text,
                            time: eventCreateController
                                .eventTimeTextController.text,
                            isSuccess: isSuccess,
                            message: "Your event has been created",
                            title: eventCreateController
                                .eventTitleTextController.text,
                          ),
                        ).then((_) {
                          // Clear the controller fields after closing the dialog
                          eventCreateController.clearTextControllers();
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CustomDialogCreateEvent(
                            imagePath:
                                eventCreateController.selectedImage.value!,
                            totalAttendees: int.parse(eventCreateController
                                .eventAttendeesTextController.text),
                            address: eventCreateController
                                .eventLinkTextController.text,
                            date: eventCreateController
                                .eventDateTextController.text,
                            time: eventCreateController
                                .eventTimeTextController.text,
                            isSuccess: isSuccess,
                            message: "Your event has not been created",
                            title: eventCreateController
                                .eventTitleTextController.text,
                          ),
                        ).then((_) {
                          // Clear the controller fields after closing the dialog
                          eventCreateController.clearTextControllers();
                        });
                      }
                    }
                  },
                  width: 360,
                  height: 35,
                ),
        ),
        SizedBox(
          height: h(context, 10),
        ),
      ],
    );
  }
}
