// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../core/globals/global_functions.dart';
import '../../widget/Custom_text_widget.dart';
import '../bottombar/bottombar.dart';
import 'signIn.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenHandler();
  }

  Future<void> splashScreenHandler() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await getUserData(userId: FirebaseAuth.instance.currentUser!.uid);
      Timer(
        Duration(seconds: 2),
        () => Get.offAll(() => BottomBar()),
      );
    } else {
      Timer(
        Duration(seconds: 2),
        () => Get.offAll(() => SignIn()),
      );
    }

    //TODO: Uncomment the below code for simple start up
    // Timer(
    //   Duration(seconds: 3),
    //   () => Get.offAll(() => SignIn()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kTertiaryColor.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(Assets.imagesLogo),
              fit: BoxFit.contain,
              height: h(context, 554),
              width: w(context, 521),
            ),
            Center(
              child: Container(
                width: w(context, 350),
                height: h(context, 70),
                padding: symmetric(
                  context,
                  vertical: 18,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(h(context, 16)),
                  border: Border.all(
                      color: Color(0xFFF4F4F4), width: w(context, 1)),
                  color: const Color(0xFFF8F6F6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text:
                            "“People who love to eat are always the best people.”",
                        size: 14,
                        color: Color(0xff707070),
                        weight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: w(context, 50),
                    ),
                    Image(
                      image: AssetImage(Assets.imagesFaQuotepng),
                      fit: BoxFit.contain,
                      height: h(context, 24),
                      width: w(context, 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
