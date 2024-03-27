// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gaa/constants/app_colors.dart';

import '../../constants/app_styling.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String hintText;

  const CustomTextField({
    Key? key,
    this.onChanged,
    this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w(context, 400),
      height: h(context, 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(h(context, 20)),
        border: Border.all(
          color: kTertiaryColor,
          width: w(context, 0.5),
        ),
        color: kSecondaryColor,
      ),
      child: Padding(
        padding: only(
          context,
          left: 15,
          right: 15,
          bottom: 8,
        ),
        child: Center(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color.fromRGBO(135, 135, 135, 0.60),
                fontSize: f(context, 11),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField2 extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String hintText;
  final bool isIcon;

  const CustomTextField2({
    Key? key,
    this.onChanged,
    this.controller,
    required this.hintText,
    this.isIcon = true,
  }) : super(key: key);

  @override
  _CustomTextField2State createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w(context, 400),
      height: h(context, 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(h(context, 20)),
        border: Border.all(
          color: kTertiaryColor,
          width: w(context, 0.5),
        ),
        color: kSecondaryColor,
      ),
      child: Padding(
        padding: only(
          context,
          left: 15,
          right: 15,
          bottom: 8,
        ),
        child: Center(
          child: TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            obscureText: _isObscure,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Color.fromRGBO(135, 135, 135, 0.60),
                fontSize: f(context, 11),
              ),
              suffixIcon: widget.isIcon
                  ? Padding(
                      padding: only(
                        context,
                        top: 3,
                      ),
                      child: IconButton(
                        color: Color.fromRGBO(135, 135, 135, 0.60),
                        focusColor: Color.fromRGBO(135, 135, 135, 0.60),
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField3 extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String hintText;

  const CustomTextField3({
    Key? key,
    this.onChanged,
    this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w(context, 400),
      height: h(context, 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(h(context, 20)),
        border: Border.all(
          color: kTertiaryColor,
          width: w(context, 0.5),
        ),
        color: kSecondaryColor,
      ),
      child: Padding(
        padding: only(
          context,
          left: 15,
          right: 15,
        ),
        child: Center(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color.fromRGBO(135, 135, 135, 0.60),
                fontSize: f(context, 11),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
