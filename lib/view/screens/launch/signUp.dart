// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../controller/auth/auth_controller.dart';
import '../../widget/Custom_Textfield_widget.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';
import '../../widget/custom_circular_indicator.dart';
import 'signIn.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  AuthController authController = Get.find();

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
          child: SingleChildScrollView(
            padding: all(context, 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: h(context, 4),
                ),
                Center(
                  child: CustomText(
                    text: "Create an account",
                    size: 19,
                    color: kPrimaryColor.withOpacity(0.71),
                    weight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: h(context, 15.5),
                ),
                CustomText(
                  text: "First name",
                  size: 13,
                  color: Color(0xff575757),
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: h(context, 4),
                ),
                CustomTextField(
                  onChanged: (value) {},
                  controller: authController.firstNameTextController,
                  hintText: '',
                ),
                SizedBox(
                  height: h(context, 10),
                ),
                CustomText(
                  text: "Last name",
                  size: 13,
                  color: Color(0xff575757),
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: h(context, 4),
                ),
                CustomTextField(
                  onChanged: (value) {},
                  controller: authController.lastNameTextController,
                  hintText: '',
                ),
                SizedBox(
                  height: h(context, 10),
                ),
                CustomText(
                  text: "Email",
                  size: 13,
                  color: Color(0xff575757),
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: h(context, 4),
                ),
                CustomTextField(
                  onChanged: (value) {},
                  controller: authController.emailSignUpTextController,
                  hintText: '',
                ),
                SizedBox(
                  height: h(context, 10),
                ),
                CustomText(
                  text: "Password",
                  size: 13,
                  color: Color(0xff575757),
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: h(context, 4),
                ),
                CustomTextField2(
                  onChanged: (value) {},
                  controller: authController.passwordSignUpTextController,
                  hintText: '',
                ),
                SizedBox(
                  height: h(context, 10),
                ),
                CustomText(
                  text: "Re-enter password",
                  size: 13,
                  color: Color(0xff575757),
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: h(context, 4),
                ),
                CustomTextField2(
                  onChanged: (value) {},
                  controller: authController.reEnterPasswordTextController,
                  hintText: '',
                ),
                SizedBox(
                  height: h(context, 4),
                ),
                AgreementCheckbox(),
                SizedBox(
                  height: h(context, 8),
                ),
                Obx(
                  () => authController.isLoading.value
                      ? Center(
                          child: CustomCircularIndicator(
                            height: 50,
                            indicatorColor: kTertiaryColor,
                            containerColor: Colors.transparent,
                          ),
                        )
                      : CustomButton(
                          buttonText: "Create an account",
                          onTap: () async {
                            if (authController
                                    .firstNameTextController.text.isEmpty ||
                                authController
                                    .lastNameTextController.text.isEmpty ||
                                authController
                                    .emailSignUpTextController.text.isEmpty ||
                                authController.passwordSignUpTextController.text
                                    .isEmpty ||
                                authController.reEnterPasswordTextController
                                    .text.isEmpty ||
                                !authController.isChecked02) {
                              // Show a snackbar or any other appropriate feedback to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                      'Please fill in all fields and accept terms and conditions.'),
                                ),
                              );
                            } else {
                              await authController.signUp();
                            }
                          },
                        ),
                ),
                SizedBox(
                  height: h(context, 10),
                ),
                CustomButton2(
                  onTap: () {
                    Get.offAll(() => SignIn());
                  },
                  firstText: 'Login instead',
                  secText: '',
                ),
                SizedBox(
                  height: h(context, 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesLine,
                      height: h(context, 1),
                      width: w(context, 99),
                    ),
                    Padding(
                      padding: only(
                        context,
                        left: 13,
                        right: 13,
                      ),
                      child: CustomText(
                        text: "Or sign up with",
                        size: 12,
                        color: kBlackBgColor.withOpacity(0.5),
                        weight: FontWeight.w500,
                      ),
                    ),
                    CommonImageView(
                      imagePath: Assets.imagesLine2,
                      height: h(context, 1),
                      width: w(context, 99),
                    ),
                  ],
                ),
                SizedBox(
                  height: h(context, 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesFacebook,
                      fit: BoxFit.contain,
                      height: h(context, 51),
                      width: w(context, 51),
                    ),
                    SizedBox(
                      width: w(context, 18),
                    ),
                    CommonImageView(
                      imagePath: Assets.imagesGoogle,
                      fit: BoxFit.contain,
                      height: h(context, 51),
                      width: w(context, 51),
                    ),
                  ],
                ),
              ],
            ),
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

AuthController authController = Get.find();

class _AgreementCheckboxState extends State<AgreementCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
              authController.isChecked02 = isChecked;
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
          text: " Terms & Conditions",
          size: 12,
          color: Color(0xff575757),
          weight: FontWeight.w300,
        ),
      ],
    );
  }
}
