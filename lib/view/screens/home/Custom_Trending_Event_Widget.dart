// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_styling.dart';
import '../../widget/Custom_text_widget.dart';
import '../event/event.dart';

class CustomTrendingEvent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;

  const CustomTrendingEvent({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String combinedText = '$title, $location';
    String combinedText = '$title';

    String displayText = combinedText.length <= 50
        ? combinedText
        : combinedText.substring(0, 49) + '...';

    return SizedBox(
      width: w(context, 160),
      height: h(context, 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => Event());
            },
            child: Container(
              width: w(context, 160),
              height: h(context, 120),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(h(context, 10)),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: h(context, 5),
          ),
          Expanded(
            child: CustomText(
              text: displayText,
              size: 10,
              paddingLeft: 5,
              color: const Color(0xff573926),
            ),
          ),
        ],
      ),
    );
  }
}
