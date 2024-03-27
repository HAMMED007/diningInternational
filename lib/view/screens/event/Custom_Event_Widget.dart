// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:gaa/controller/event/event_controller.dart';
import 'package:gaa/core/globals/global_functions.dart';
import 'package:gaa/core/globals/global_variables.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_divider_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';
import 'edit_event.dart';

class CustomEvent extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String location;
  final String date;
  final String time;
  final int attendees;
  final int totalAttendees;
  final bool hasregister;
  final int index;

  final String profileImagePath;

  CustomEvent({
    Key? key,
    this.backgroundColor = kSecondaryColor,
    required this.location,
    required this.date,
    required this.time,
    required this.attendees,
    required this.totalAttendees,
    this.hasregister = true,
    required this.index,
    required this.title,
    required this.profileImagePath,
  }) : super(key: key);

  EventController eventController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: w(context, 385),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(h(context, 5)),
        color: backgroundColor,
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.20),
          width: w(context, 4.68),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: symmetric(context, horizontal: 13),
          child: Column(
            children: [
              SizedBox(height: h(context, 5)),
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: '$title, $location',
                      // text: '$title',

                      size: 14,
                      color: const Color(0xff573926),
                    ),
                  ),
                  SizedBox(width: w(context, 25)),
                  CircleAvatar(
                    backgroundImage: NetworkImage(profileImagePath),
                    radius: 28,
                  ),
                ],
              ),
              CustomDivider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesCalender,
                    fit: BoxFit.contain,
                    height: h(context, 17),
                    width: w(context, 17),
                  ),
                  CustomText(text: date, paddingLeft: 6),
                  SizedBox(width: w(context, 34)),
                  CommonImageView(
                    imagePath: Assets.imagesClock,
                    fit: BoxFit.contain,
                    height: h(context, 17),
                    width: w(context, 17),
                  ),
                  CustomText(text: time, paddingLeft: 6),
                ],
              ),
              SizedBox(height: h(context, 5)),
              Row(
                children: [
                  CustomText(
                    text: "Attendees : $attendees/$totalAttendees",
                    weight: FontWeight.w500,
                  ),
                  Image.asset(
                    Assets.imagesShare,
                    height: h(context, 18),
                    width: w(context, 18),
                  ),
                  const Spacer(),
                  if (hasregister)
                    CustomButton2(
                      firstText: "Edit your event",
                      secText: "",
                      height: 25,
                      width: 160,
                      onTap: () {
                        eventController.eventModelToUpdate!.value =
                            eventController.eventThread[index];
                        Get.to(
                          () => EditEvent(
                            eventModel:
                                eventController.eventThread.value[index],
                          ),
                        );
                      },
                    ),
                  if (!hasregister)
                    CustomButton2(
                      firstText: "Register for this event",
                      secText: "",
                      height: 25,
                      width: 180,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => ConfirmCustomDialog(
                              title: eventController
                                  .eventThread.value[index].title,
                              imagePath: eventController
                                  .eventThread.value[index].imageUrl,
                              eventId: eventController
                                  .eventThread.value[index].eventId,
                              address:
                                  eventController.eventThread.value[index].link,
                              date:
                                  eventController.eventThread.value[index].date,
                              time:
                                  eventController.eventThread.value[index].time,
                              totalAttendees: eventController
                                  .eventThread.value[index].attendeesTotal,
                              comingAttendees:
                                  "${eventController.eventThread.value[index].attendees?.length}",
                              isDelete: false,
                              message: "Confirm Attendance"),
                        );
//                        Get.to(() => EditEvent(eventModel: eventController.eventThread.value[index],));
                      },
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
