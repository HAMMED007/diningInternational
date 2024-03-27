// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gaa/controller/auth/auth_controller.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../core/globals/global_functions.dart';
import '../../widget/Custom_Textfield_widget.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';
import 'resend.dart';
import 'signIn.dart';
import 'signUp.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kTertiaryColor.withOpacity(0.09),
        leading: Container(
          padding: only(
            context,
            left: 13,
            top: 5,
            bottom: 5,
          ),
          child: Image.asset(
            Assets.imagesRefresh,
            height: h(context, 45),
            width: w(context, 42),
          ),
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
          padding: all(context, 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CustomText(
                  text: "Forgot password",
                  size: 19,
                  color: kPrimaryColor.withOpacity(0.71),
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: h(context, 57),
              ),
              CustomText(
                text: "Email/ username",
                size: 13,
                color: Color(0xff575757),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 5),
              ),
              CustomTextField(
                onChanged: (value) {},
                controller: authController.emailForgotPasswordTextController,
                hintText: '',
              ),
              SizedBox(
                height: h(context, 41),
              ),
              CustomButton(
                buttonText: "Recover your password",
                onTap: () async {
                 bool isSuccess =  await authController.resetPassword();
                 // Check if the event creation was successful
                 if (isSuccess) {
                   Get.offAll(() => Resend());
                 } else {
                   showDialog(
                     context: context,
                     builder: (BuildContext context) =>
                         CustomDialogForHappyOrSadOnly(
                           isSuccess: isSuccess,
                           message: "Password Reset was unsuccessful",
                         ),
                   );
                 }

                },
              ),
              SizedBox(
                height: h(context, 10),
              ),
              CustomButton2(
                onTap: () {
                  Get.offAll(() => SignIn());
                },
                firstText: 'Remembered password? ',
                secText: 'Login',
              ),
              SizedBox(
                height: h(context, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
