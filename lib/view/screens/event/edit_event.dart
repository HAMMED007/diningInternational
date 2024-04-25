// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaa/controller/event/event_controller.dart';
import 'package:gaa/models/event/event_model.dart';
import 'package:gaa/view/screens/event/custom_map_view.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../core/globals/global_functions.dart';
import '../../../core/globals/global_variables.dart';
import '../../widget/Custom_Textfield_widget.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';
import '../../widget/custom_circular_indicator.dart';

class EditEvent extends StatefulWidget {
  EditEvent({Key? key, required this.eventModel}) : super(key: key);

  EventModel eventModel;

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
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

  EventController eventController = Get.find();

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
                  text: "Edit your event",
                  size: 19,
                  color: kPrimaryColor.withOpacity(0.71),
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: h(context, 67),
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
                            eventController.eventTitleTextController.text =
                                "${result.formattedAddress}";

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
                  child: CustomTextField(
                    onChanged: (value) {},
                    controller: eventController.eventTitleTextController,
                    hintText: '${widget.eventModel.title}',
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
                controller: eventController.eventLinkTextController,
                hintText: '${widget.eventModel.link}',
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
                              eventController.eventDateTextController.text =
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                            } else {
                              // If the user cancels, clear the text field's controller
                              eventController.eventDateTextController.text = '';
                            }
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              controller:
                                  eventController.eventDateTextController,
                              hintText: '${widget.eventModel.date}',
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
                                eventController.eventTimeTextController.text =
                                    formattedTimeRange;
                              }
                            });
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller:
                                  eventController.eventTimeTextController,
                              decoration: InputDecoration(
                                hintText: '${widget.eventModel.time}',
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
                          controller:
                              eventController.eventAttendeesTextController,
                          hintText: '${widget.eventModel.attendeesTotal}',
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
                              () => (widget.eventModel.imageUrl == "") &&
                                      (eventController.selectedImage.value ==
                                          null)
                                  ? GestureDetector(
                                      onTap: () async {
                                        eventController.selectedImage.value =
                                            await eventController
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
                                      file: eventController.selectedImage.value,
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
                height: h(context, 40),
              ),
              Obx(
                () => eventController.isLoading.value
                    ? Center(
                        child: CustomCircularIndicator(
                          containerColor: Colors.transparent,
                          indicatorColor: kTertiaryColor,
                        ),
                      )
                    : CustomButton(
                        buttonText: "Edit event",
                        onTap: () async {
                          // All fields are filled and checkbox is checked, proceed to create event
                          bool isSuccess = await eventController
                              .updateEvent(widget.eventModel.eventId ?? "");

                          // Check if the event creation was successful
                          if (isSuccess) {
                            Get.to(() => CustomDialogForSuccessOrFailure(
                                  attendees:
                                      widget.eventModel.attendees?.length ?? 0,
                                  totalAttendees: eventController
                                              .eventAttendeesTextController
                                              .text ==
                                          ""
                                      ? int.parse(
                                          widget.eventModel.attendeesTotal ??
                                              "0")
                                      : int.parse(eventController
                                          .eventAttendeesTextController.text),
                                  imagePath: eventController
                                          .eventModelToUpdate?.value.imageUrl ??
                                      "",
                                  address: eventController
                                          .eventLinkTextController.text.isEmpty
                                      ? eventController
                                          .eventModelToUpdate?.value.link
                                      : eventController
                                          .eventLinkTextController.text,
                                  date: eventController
                                          .eventDateTextController.text.isEmpty
                                      ? eventController
                                          .eventModelToUpdate?.value.date
                                      : eventController
                                          .eventDateTextController.text,
                                  time: eventController
                                          .eventTimeTextController.text.isEmpty
                                      ? eventController
                                          .eventModelToUpdate?.value.time
                                      : eventController
                                          .eventTimeTextController.text,
                                  isSuccess: isSuccess,
                                  message: "Your event has been updated",
                                  location: eventController
                                          .eventTitleTextController.text.isEmpty
                                      ? eventController
                                          .eventModelToUpdate?.value.link
                                      : eventController
                                          .eventTitleTextController.text,
                                  title: eventController
                                          .eventTitleTextController.text.isEmpty
                                      ? eventController
                                          .eventModelToUpdate?.value.title
                                      : eventController
                                          .eventTitleTextController.text,
                                ));
                          } else {
                            Get.to(() => CustomDialogForSuccessOrFailure(
                                  attendees:
                                      widget.eventModel.attendees?.length ?? 0,
                                  totalAttendees: eventController
                                              .eventAttendeesTextController
                                              .text ==
                                          ""
                                      ? int.parse(
                                          widget.eventModel.attendeesTotal ??
                                              "0")
                                      : int.parse(eventController
                                          .eventAttendeesTextController.text),
                                  imagePath:
                                      userModelGlobal.value.userProfilePic,
                                  address: eventController
                                      .eventLinkTextController.text,
                                  date: eventController
                                      .eventDateTextController.text,
                                  time: eventController
                                      .eventTimeTextController.text,
                                  isSuccess: isSuccess,
                                  message: "Your event has not been created",
                                  title: eventController
                                      .eventTitleTextController.text,
                                ));
                          }
                        },
                        height: 40,
                      ),
              ),
              SizedBox(
                height: h(context, 11),
              ),
              CustomButton2(
                firstText: "Cancel",
                secText: "",
                onTap: () {
                  Get.back();
                },
                height: 40,
                textColor: kSecondaryColor,
                backgroundColor: Color(0xff636363),
              ),
              SizedBox(
                height: h(context, 11),
              ),
              CustomButton2(
                firstText: "Delete event",
                secText: "",
                onTap: () async {
                  bool isSuccess = await eventController
                      .deleteEvent(widget.eventModel.eventId ?? "");

                  //TODO: Need to put the deletion dialog box
                  // Check if the event creation was successful
                  if (isSuccess) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialogDelete(
                        attendees: widget.eventModel.attendees?.length ?? 0,
                        totalAttendees: eventController
                                    .eventAttendeesTextController.text ==
                                ""
                            ? int.parse(widget.eventModel.attendeesTotal ?? "0")
                            : int.parse(eventController
                                .eventAttendeesTextController.text),
                        imagePath: eventController
                                .eventModelToUpdate?.value.imageUrl ??
                            "",
                        address: widget.eventModel.link,
                        date: widget.eventModel.date,
                        time: widget.eventModel.time,
                        isSuccess: isSuccess,
                        isdelete: true,
                        message: "Your event has been deleted",
                        title: widget.eventModel.title,
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialogDelete(
                        attendees: widget.eventModel.attendees?.length ?? 0,
                        totalAttendees:
                            int.parse(widget.eventModel.attendeesTotal ?? "0"),
                        title: widget.eventModel.title,
                        imagePath: userModelGlobal.value.userProfilePic,
                        address: widget.eventModel.link,
                        date: widget.eventModel.date,
                        time: widget.eventModel.time,
                        isSuccess: isSuccess,
                        isdelete: true,
                        message: "Your event has not been deleted",
                      ),
                    );
                  }
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) =>
                  //       ConfirmCustomDialog(),
                  // );
                },
                height: 40,
                textColor: kSecondaryColor,
                backgroundColor: Color(0xffFF0000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
