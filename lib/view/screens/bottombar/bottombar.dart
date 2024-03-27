// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:gaa/constants/app_styling.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../event/create_event.dart';
import '../event/event.dart';
import '../home/home.dart';
import '../profile/profile.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          Home(),
          Event(),
          CreateEvent(),
          Profile(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        children: [
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.jumpToPage(index);
              });
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: kTertiaryColor,
            items: [
              _buildBottomNavigationBarItem('Home', Assets.imagesHomeicon, 0),
              _buildBottomNavigationBarItem(
                  'Calender', Assets.imagesCalendericon, 1),
              _buildBottomNavigationBarItem('Event', Assets.imagesEventicon, 2),
              _buildBottomNavigationBarItem(
                  'Profile', Assets.imagesProfileicon, 3),
            ],
          ),
          // Positioned(
          //   top: 0,
          //   child: Container(
          //     width: 10,
          //     height: 10,
          //     decoration: BoxDecoration(
          //       color: Colors.blue,
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      String label, String imagePath, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        child: Image.asset(
          imagePath,
          width: w(context, 30),
          height: h(context, 23),
          color: _selectedIndex == index ? kSecondaryColor : kQuaternaryColor,
        ),
      ),
      label: label,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
