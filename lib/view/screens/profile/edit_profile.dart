// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gaa/controller/profile/profile_controller.dart';
import 'package:gaa/core/globals/global_functions.dart';
import 'package:gaa/core/globals/global_variables.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../widget/Custom_Textfield_widget.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';
import 'profile.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: kTertiaryColor.withOpacity(0.09),
            image: DecorationImage(
              image: AssetImage(Assets.imagesBg),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: symmetric(
              context,
              horizontal: 20,
              vertical: 10,
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h(context, 50),
                  ),
                  Obx(
                    () => (profileController.selectedImage.value == null)
                        ? GestureDetector(
                            onTap: () async {
                              profileController.selectedImage.value =
                                  await profileController
                                      .pickImageFromGallery();
                            },
                            child: Image.asset(
                              Assets.imagesAddprofile,
                              fit: BoxFit.contain,
                              height: h(context, 85),
                              width: w(context, 80),
                            ),
                          )
                        : Container(
                            width: w(context, 90),
                            height: h(context, 70),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kSecondaryColor,
                            ),
                            child: CommonImageView(
                              radius: h(context, 50),
                              file: profileController.selectedImage.value,
                              fit: BoxFit.cover,
                              height: h(context, 85),
                              width: w(context, 80),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: h(context, 5),
                  ),
                  CustomButton(
                    buttonText: "Complete your profile",
                    width: w(context, 200),
                    backgroundColor: Color(0xffF9E0C2),
                    textColor: kPrimaryColor,
                    fontWeight: FontWeight.w400,
                    textSize: 11,
                    height: h(context, 20),
                    onTap: () {},
                  ),
                  SizedBox(
                    height: h(context, 30),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomText(
                      text: "Choose your username",
                      size: 13,
                      color: Color(0xff575757),
                      weight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: h(context, 11),
                  ),
                  CustomTextField(
                    onChanged: (value) {},
                    controller: null,
                    hintText: '',
                  ),
                  SizedBox(
                    height: h(context, 12),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomText(
                      text: "How would you describe yourself? (100 characters)",
                      size: 13,
                      color: Color(0xff575757),
                      weight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: h(context, 8),
                  ),
                  CustomTextField(
                    onChanged: (value) {},
                    controller: profileController.bioTextController,
                    hintText: '',
                  ),
                  SizedBox(
                    height: h(context, 12),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomText(
                      text: "Location",
                      size: 13,
                      color: Color(0xff575757),
                      weight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: h(context, 8),
                  ),
                  CustomTextField(
                    onChanged: (value) {},
                    controller: profileController.locationTextController,
                    hintText: '',
                  ),
                  SizedBox(
                    height: h(context, 80),
                  ),
                  CustomButton(
                    buttonText: "Update profile",
                    onTap: () {
                      profileController.saveUserInfo();
                      getUserData(userId: userModelGlobal.value.userId ?? "");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
