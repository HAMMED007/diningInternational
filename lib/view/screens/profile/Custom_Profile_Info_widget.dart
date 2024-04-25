// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../widget/Custom_text_widget.dart';

class CustomProfileInfo extends StatelessWidget {
  final String profileImage;
  final String username;
  final String description;
  final String location;

  const CustomProfileInfo({
    Key? key,
    required this.profileImage,
    required this.username,
    required this.description,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: w(context, 90),
              height: h(context, 70),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kSecondaryColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(h(context, 130)),
                child: Image.network(
                  profileImage,
                  fit: BoxFit.cover,
                  width: w(context, 90),
                  height: h(context, 70),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: w(context, 58),
              child: Image.asset(
                Assets.imagesComplete,
                height: h(context, 28),
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
        SizedBox(
          width: w(context, 12),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: h(context, 10),
              ),
              Row(
                children: [
                  CustomText(
                    text: "Hello,",
                    color: kPrimaryColor.withOpacity(0.73),
                    size: f(context, 17),
                    weight: FontWeight.w400,
                  ),
                  CustomText(
                    text: username,
                    color: kPrimaryColor.withOpacity(0.73),
                    size: f(context, 17),
                    weight: FontWeight.w700,
                  ),
                ],
              ),
              SizedBox(
                height: h(context, 2),
              ),
              CustomText(
                text: description,
                size: f(context, 12),
                color: const Color(0xff1B1B1B),
                weight: FontWeight.w400,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Based in ",
                    size: 13,
                    weight: FontWeight.w500,
                  ),
                  CustomText(
                    text: location,
                    size: 13,
                    weight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
