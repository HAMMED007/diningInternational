// ignore_for_file: prefer_const_constructors

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
import '../bottombar/bottombar.dart';
import 'forget_password.dart';
import 'signUp.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

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
        child: SingleChildScrollView(
          padding: all(context, 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomText(
                  text: "Welcome back",
                  size: 19,
                  color: kPrimaryColor.withOpacity(0.71),
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: h(context, 54),
              ),
              CustomText(
                text: "Email/username",
                size: 13,
                color: Color(0xff575757),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 11),
              ),
              CustomTextField(
                onChanged: (value) {},
                controller: authController.emailLogInTextController,
                hintText: '',
              ),
              SizedBox(
                height: h(context, 11),
              ),
              CustomText(
                text: "Password",
                size: 13,
                color: Color(0xff575757),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 11),
              ),
              CustomTextField2(
                onChanged: (value) {},
                controller: authController.passwordLogInTextController,
                hintText: '',
              ),
              SizedBox(
                height: h(context, 11),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  text: "forgot password?",
                  size: 13,
                  color: Color(0xff575757),
                  weight: FontWeight.w500,
                  onTap: () {
                    Get.offAll(() => ForgetPassword());
                  },
                ),
              ),
              SizedBox(
                height: h(context, 41),
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
                        buttonText: "Log in",
                        onTap: () async {
                          await authController.login();
                        },
                      ),
              ),
              // CustomButton(
              //   buttonText: "Log in",
              //   onTap: () async {
              //     await authController.login();
              //     Get.offAll(() => BottomBar());
              //   },
              // ),
              SizedBox(
                height: h(context, 10),
              ),
              CustomButton2(
                onTap: () {
                  Get.offAll(() => SignUp());
                },
                firstText: 'New user?',
                secText: 'Create an account',
              ),
              SizedBox(
                height: h(context, 60),
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
                      text: "Or continue with",
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
                height: h(context, 21),
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
                  GestureDetector(
                    onTap: () {
                      authController.signInWithGoogle();
                    },
                    child: CommonImageView(
                      imagePath: Assets.imagesGoogle,
                      fit: BoxFit.contain,
                      height: h(context, 51),
                      width: w(context, 51),
                    ),
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
