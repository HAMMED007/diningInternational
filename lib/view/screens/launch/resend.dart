// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';
import 'forget_password.dart';
import 'signIn.dart';

class Resend extends StatelessWidget {
  const Resend({Key? key}) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonImageView(
                imagePath: Assets.imagesSuccess,
                fit: BoxFit.contain,
                height: h(context, 108),
                width: w(context, 190),
              ),
              CustomText(
                text: "Success!",
                size: 24,
                color: Color(0xff374151),
                weight: FontWeight.w700,
              ),
              SizedBox(
                height: h(context, 8),
              ),
              CustomText(
                text: "Please check your email for a password resent link",
                size: 16,
                textAlign: TextAlign.center,
                color: Color(0xff575757),
                weight: FontWeight.w500,
                paddingLeft: 40,
                paddingRight: 40,
              ),
              SizedBox(
                height: h(context, 49),
              ),
              CustomButton(
                buttonText: "Didn’t get any email? Resend",
                onTap: () {
                  Get.offAll(() => ForgetPassword());
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
