import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomDivider extends StatelessWidget {
  final Color color;

  const CustomDivider({
    Key? key,
    this.color = klightGreyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: 1.0,
    );
  }
}
