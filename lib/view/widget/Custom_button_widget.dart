import 'package:flutter/material.dart';
import '../../../constants/app_styling.dart';
import '../../constants/app_colors.dart';
import 'Custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final FontWeight fontWeight;
  final double textSize;
  final double width;
  final double height;
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
    required this.buttonText,
    this.backgroundColor = kTertiaryColor,
    this.textColor = kSecondaryColor,
    this.borderRadius = 20.0,
    this.fontWeight = FontWeight.w700,
    this.textSize = 14.0,
    this.width = 400.0,
    this.height = 40.0,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w(context, width),
        height: h(context, height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(h(context, borderRadius)),
          color: backgroundColor,
        ),
        child: Center(
          child: CustomText(
            text: buttonText,
            size: textSize,
            weight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final String firstText;
  final String secText;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final FontWeight fontWeight;
  final double textSize;
  final double width;
  final double height;
  final VoidCallback onTap;

  const CustomButton2({
    Key? key,
    required this.firstText,
    required this.secText,
    this.backgroundColor = kQuaternaryColor,
    this.textColor = kBlackBgColor,
    this.borderRadius = 20.0,
    this.fontWeight = FontWeight.w500,
    this.textSize = 13.0,
    this.width = 400.0,
    this.height = 40.0,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w(context, width),
        height: h(context, height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(h(context, borderRadius)),
          color: backgroundColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: firstText,
              size: textSize,
              weight: fontWeight,
              color: textColor,
              paddingLeft: 2,
            ),
            CustomText(
              text: secText,
              size: textSize,
              weight: FontWeight.w300,
              color: textColor.withOpacity(0.65),
            ),
          ],
        ),
      ),
    );
  }
}
