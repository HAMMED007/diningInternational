import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_styling.dart';
import '../../widget/Custom_text_widget.dart';

class CustomEventInfo extends StatelessWidget {
  final String imagePath;
  final int rating;
  final String title;

  final String location;

  const CustomEventInfo({
    Key? key,
    required this.imagePath,
    required this.rating,
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
      width: w(context, 170),
      height: h(context, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: w(context, 160),
            height: h(context, 170),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(h(context, 10)),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: h(context, 7),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: displayText,
                  size: 11,
                  paddingLeft: 5,
                  color: const Color(0xff573926),
                ),
              ),
              // Row(
              //   children: [
              //     for (int i = 0; i < 5; i++)
              //       Icon(
              //         Icons.star,
              //         color: i < rating ? kTertiaryColor : kSecondaryColor,
              //         size: 15,
              //       ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
