// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:gaa/controller/event/event_controller.dart';
import 'package:gaa/core/globals/global_variables.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../controller/auth/auth_controller.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../launch/signIn.dart';
import 'Custom_Event_Info_widget.dart';
import 'Custom_Profile_Info_widget.dart';
import 'edit_profile.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTertiaryColor.withOpacity(0.17),
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
            IconButton(
              icon: Image.asset(
                Assets.imagesMore,
                height: h(context, 25),
                width: w(context, 19),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: kTertiaryColor.withOpacity(0.09),
          image: DecorationImage(
            image: AssetImage(Assets.imagesBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: symmetric(
            context,
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => CustomProfileInfo(
                  profileImage: userModelGlobal.value.userProfilePic == ""
                      ? dummyProfilePic
                      : userModelGlobal.value.userProfilePic!,
                  username: userModelGlobal.value.userFirstName == ''
                      ? "YourUsername"
                      : userModelGlobal.value.userFirstName!,
                  description: userModelGlobal.value.userBio == ''
                      ? "Your Bio"
                      : userModelGlobal.value.userBio!,
                ),
              ),
              SizedBox(
                height: h(context, 10),
              ),
              Row(
                children: [
                  CustomButton(
                    buttonText: "Edit your profile",
                    width: w(context, 140),
                    backgroundColor: Color(0xffF9E0C2),
                    textColor: kPrimaryColor,
                    fontWeight: FontWeight.w400,
                    textSize: 11,
                    height: 30,
                    onTap: () {
                      Get.to(() => EditProfile());
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomButton(
                    buttonText: "Log Out",
                    width: w(context, 140),
                    backgroundColor: Colors.red.shade300,
                    textColor: kPrimaryColor,
                    fontWeight: FontWeight.w400,
                    textSize: 11,
                    height: 30,
                    onTap: () {
                      Get.find<AuthController>().signOut();
                      Get.offAll(() => SignIn());
                    },
                  ),
                ],
              ),
              SizedBox(
                height: h(context, 10),
              ),
              CustomText(
                text: "Based in",
                size: 13,
                weight: FontWeight.w500,
              ),
              Obx(
                () => CustomText(
                  text: "${userModelGlobal.value.userLocation}",
                  size: 13,
                  weight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: h(context, 15),
              ),
              CustomText(
                text: "Events you are attending",
                size: 14,
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 5),
              ),
              Expanded(
                child: Obx(
                  () => eventController.eventsAttending.isNotEmpty
                      ? ListView.builder(
                          itemCount: eventController.eventsAttending.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
//                            final event = events[index];
                            return Padding(
                              padding: only(
                                context,
                                right: 13,
                              ),
                              child: CustomEventInfo(
                                imagePath: eventController.eventsAttending
                                        .value[index].imageUrl ??
                                    dummyNoImage,
                                rating: 4,
                                title: eventController
                                        .eventsAttending.value[index].title ??
                                    "",
                                location: eventController
                                        .eventsAttending.value[index].link ??
                                    "",
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text("No DATA"),
                        ),
                ),
              ),
              CustomText(
                text: "Events you have attended previously",
                size: 14,
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 5),
              ),
              Expanded(
                child: Obx(
                  () => eventController.eventsAlreadyAttending.isNotEmpty
                      ? ListView.builder(
                          itemCount:
                              eventController.eventsAlreadyAttending.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
//                            final event = events[index];
                            return Padding(
                              padding: only(
                                context,
                                right: 13,
                              ),
                              child: CustomEventInfo(
                                imagePath: eventController
                                        .eventsAlreadyAttending
                                        .value[index]
                                        .imageUrl ??
                                    dummyNoImage,
                                rating: 4,
                                title: eventController.eventsAlreadyAttending
                                        .value[index].title ??
                                    "",
                                location: eventController.eventsAlreadyAttending
                                        .value[index].link ??
                                    "",
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text("No DATA"),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
