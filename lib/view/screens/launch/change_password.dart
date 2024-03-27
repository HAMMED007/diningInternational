// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../widget/Custom_Textfield_widget.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import 'resend.dart';
import 'signIn.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: h(context, 64),
              ),
              CustomText(
                text: "Change New Password",
                size: 19,
                color: Color(0xff6B6B6B),
                weight: FontWeight.w700,
                paddingBottom: 5,
              ),
              CustomText(
                text: "Enter your new password below",
                size: 16,
                color: Color(0xff797979),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 16),
              ),
              CustomText(
                text: "Password",
                size: 13,
                color: Color(0xff575757),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 5),
              ),
              CustomTextField(
                onChanged: (value) {},
                controller: null,
                hintText: '',
              ),
              SizedBox(
                height: h(context, 10),
              ),
              CustomText(
                text: "Confirm password",
                size: 13,
                color: Color(0xff575757),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: h(context, 5),
              ),
              CustomTextField(
                onChanged: (value) {},
                controller: null,
                hintText: '',
              ),
              SizedBox(
                height: h(context, 57),
              ),
              CustomButton2(
                onTap: () {
                  Get.offAll(() => SignIn());
                },
                firstText: 'Proceed and Login',
                secText: '',
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
