// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gaa/controller/event/event_controller.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_styling.dart';
import '../../models/user/user_model.dart';
import '../../view/widget/Custom_button_widget.dart';
import '../../view/widget/Custom_divider_widget.dart';
import '../../view/widget/Custom_text_widget.dart';
import '../../view/widget/common_image_view_widget.dart';
import 'global_variables.dart';

void showSuccessSnackbar(
    {required String title, required String msg, int duration = 7}) {
  Get.snackbar(
    title,
    msg,
    duration: Duration(seconds: duration),
    backgroundColor: Colors.green,
    snackPosition: SnackPosition.BOTTOM,
    messageText: Text(
      msg,
      style: const TextStyle(color: Colors.white),
    ),
    titleText: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}

void showFailureSnackbar(
    {required String title, required String msg, int duration = 7}) {
  Get.snackbar(
    title,
    msg,
    duration: Duration(seconds: duration),
    backgroundColor: Colors.red,
    snackPosition: SnackPosition.BOTTOM,
    messageText: Text(
      msg,
      style: const TextStyle(color: Colors.white),
    ),
    titleText: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
  //fetch res data from firebase
}

//Function To fetch The userData
Future<void> getUserData({required String userId}) async {
  //getting user's data stream
  try {
    // Fetch user's data once
    var snapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();

    if (snapshot.exists) {
      // Update your model class with the fetched data
      userModelGlobal.value = UserModel.fromMap(snapshot);

      log("User name from model is: ${userModelGlobal.value.userFirstName}");
    } else {
      log("User with ID $userId does not exist");
    }
  } catch (e) {
    log("Error fetching user data: $e");
  }
}

Color getBackgroundColor(int index) {
  // Calculate the remainder when dividing the index by different numbers
  int remainderMod4 = index % 4;
  int remainderMod3 = index % 3;
  int remainderMod2 = index % 2;

  // Assign colors based on the remainders
  if (remainderMod4 == 0) {
    return colorEvent04; // Replace 'color1' with your desired color
  } else if (remainderMod3 == 0) {
    return colorEvent03; // Replace 'color2' with your desired color
  } else if (remainderMod2 == 0) {
    return colorEvent02; // Replace 'color3' with your desired color
  } else {
    return colorEventDef; // Replace 'defaultColor' with your desired default color
  }
}

class CustomDialogForSuccessOrFailure extends StatelessWidget {
  final String? title;
  final String? address;
  final String? date;
  final String? time;
  final String? imagePath;
  final String? message;
  final bool? isSuccess;

  CustomDialogForSuccessOrFailure({
    required this.title,
    this.address = "",
    this.date = "",
    this.time = "",
    this.imagePath = "",
    this.message = "",
    this.isSuccess = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(h(context, 5)),
        side: const BorderSide(
          color: Color.fromRGBO(255, 255, 255, 0.20),
          width: 4.68,
        ),
      ),
      child: Container(
        height: h(context, 325),
        width: w(context, 385),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(h(context, 5)),
          color: kSecondaryColor,
          border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.20),
            width: w(context, 4.68),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15.6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: all(context, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      // text: '$title, $address',
                      text: '$title',

                      size: 14,
                      color: const Color(0xff573926),
                    ),
                  ),
                  SizedBox(
                    width: w(context, 15),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(imagePath ?? dummyProfilePic),
                    radius: 28,
                  )
                ],
              ),
              const CustomDivider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesCalender,
                    fit: BoxFit.contain,
                    height: h(context, 17),
                    width: w(context, 17),
                  ),
                  CustomText(
                    text: "${date}",
                    paddingLeft: 6,
                  ),
                  SizedBox(
                    width: w(context, 34),
                  ),
                  CommonImageView(
                    imagePath: Assets.imagesClock,
                    fit: BoxFit.contain,
                    height: h(context, 17),
                    width: w(context, 17),
                  ),
                  CustomText(
                    text: "${time}",
                    paddingLeft: 6,
                  ),
                ],
              ),
              Center(
                child: CommonImageView(
                  imagePath: isSuccess! ? Assets.imagesHappy : Assets.imagesSad,
                  fit: BoxFit.contain,
                  height: h(context, 138),
                  width: w(context, 190),
                ),
              ),
              CustomText(
                text: "${message}",
                size: 22,
                textAlign: TextAlign.center,
                weight: FontWeight.w700,
                color: const Color(0xff6B6B6B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmCustomDialog extends StatelessWidget {
  final String? title;
  final String? address;
  final String? date;
  final String? time;
  final String? imagePath;
  final String? message;
  final bool? isDelete;
  final String? eventId;
  final String? totalAttendees;
  final String? comingAttendees;

  ConfirmCustomDialog({
    this.title = "",
    this.address = "",
    this.date = "",
    this.time = "",
    this.imagePath = "",
    this.message = "",
    this.isDelete = true,
    this.eventId = "",
    this.totalAttendees = "",
    this.comingAttendees = "",
  });

  EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(h(context, 5)),
        side: const BorderSide(
          color: Color.fromRGBO(255, 255, 255, 0.20),
          width: 4.68,
        ),
      ),
      child: Container(
        height: h(context, 280),
        width: w(context, 385),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(h(context, 5)),
          color: kSecondaryColor,
          border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.20),
            width: w(context, 4.68),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15.6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: all(context, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomText(
// text: '$title, $address',
                      text: '$title', size: 14,
                      color: const Color(0xff573926),
                    ),
                  ),
                  SizedBox(
                    width: w(context, 15),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(imagePath ?? dummyProfilePic),
                    radius: 28,
                  )
                ],
              ),
              const CustomDivider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesCalender,
                    fit: BoxFit.contain,
                    height: h(context, 17),
                    width: w(context, 17),
                  ),
                  CustomText(
                    text: "31 April 2023",
                    paddingLeft: 6,
                  ),
                  SizedBox(
                    width: w(context, 34),
                  ),
                  CommonImageView(
                    imagePath: Assets.imagesClock,
                    fit: BoxFit.contain,
                    height: h(context, 17),
                    width: w(context, 17),
                  ),
                  CustomText(
                    text: "${time}",
                    paddingLeft: 6,
                  ),
                ],
              ),
              CustomText(
                text: "Attendees : ${comingAttendees}/${totalAttendees}",
                weight: FontWeight.w500,
                paddingTop: 5,
              ),
              const Spacer(),
              // Center(
              //   child: CustomText(
              //     text: "${message}",
              //     weight: FontWeight.w500,
              //     color: Color(0xff808080),
              //     size: 15,
              //     paddingTop: 5,
              //   ),
              // ),
              // SizedBox(
              //   height: h(context, 5),
              // ),
              Center(
                child: CustomButton(
                  buttonText: "${message}",
                  width: 245,
                  height: 35,
                  backgroundColor: isDelete! ? Colors.red : kTertiaryColor,
                  onTap: () async {
                    bool isSuccess = await eventController.addUserToEvent(
                        eventId ?? "", userModelGlobal.value.userId ?? "");
                    if (isSuccess) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CustomDialogForHappyOrSadOnly(
                          isSuccess: isSuccess,
                          message: "Succesfully register the event",
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CustomDialogForHappyOrSadOnly(
                          isSuccess: isSuccess,
                          message:
                              "Could not register the event you maybe present in the event",
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialogForHappyOrSadOnly extends StatelessWidget {
  bool? isSuccess;
  String? message;

  CustomDialogForHappyOrSadOnly({
    this.isSuccess = true,
    this.message = "",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(h(context, 5)),
        side: const BorderSide(
          color: Color.fromRGBO(255, 255, 255, 0.20),
          width: 4.68,
        ),
      ),
      child: Container(
        height: h(context, 325),
        width: w(context, 385),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(h(context, 5)),
          color: kSecondaryColor,
          border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.20),
            width: w(context, 4.68),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15.6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: all(context, 10),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: CustomText(
              //         text: "Olde Hansa Restaurant, Vana Turg 1, Tallinn",
              //         size: 18,
              //         color: Color(0xff573926),
              //       ),
              //     ),
              //     SizedBox(
              //       width: w(context, 15),
              //     ),
              //     CircleAvatar(
              //       backgroundImage: AssetImage(Assets.imagesProfile),
              //       radius: 28,
              //     )
              //   ],
              // ),
              // CustomDivider(),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     CommonImageView(
              //       imagePath: Assets.imagesCalender,
              //       fit: BoxFit.contain,
              //       height: h(context, 17),
              //       width: w(context, 17),
              //     ),
              //     CustomText(
              //       text: "31 April 2023",
              //       paddingLeft: 6,
              //     ),
              //     SizedBox(
              //       width: w(context, 34),
              //     ),
              //     CommonImageView(
              //       imagePath: Assets.imagesClock,
              //       fit: BoxFit.contain,
              //       height: h(context, 17),
              //       width: w(context, 17),
              //     ),
              //     CustomText(
              //       text: "7:30 PM - 8:30 PM",
              //       paddingLeft: 6,
              //     ),
              //   ],
              // ),
              Center(
                child: CommonImageView(
                  imagePath: isSuccess! ? Assets.imagesHappy : Assets.imagesSad,
                  fit: BoxFit.contain,
                  height: h(context, 138),
                  width: w(context, 190),
                ),
              ),
              CustomText(
                text: "${message}",
                size: 22,
                textAlign: TextAlign.center,
                weight: FontWeight.w700,
                color: const Color(0xff6B6B6B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
