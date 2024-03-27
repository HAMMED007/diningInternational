// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:gaa/view/screens/event/create_event.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../controller/event/event_controller.dart';
import '../../../core/globals/global_variables.dart';
import '../../widget/Custom_button_widget.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';
import 'Custom_Trending_Event_Widget.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> events = [
    {'imagePath': Assets.imagesEvent1, 'name': 'Go Karting'},
    {'imagePath': Assets.imagesEvent2, 'name': 'Cycling Event'},
    {'imagePath': Assets.imagesEvent2, 'name': 'Cycling Event'},
    {'imagePath': Assets.imagesEvent2, 'name': 'Cycling Event'},
  ];

  EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTertiaryColor.withOpacity(0.09),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: only(context, right: 10),
          child: Row(
            children: [
              IconButton(
                icon: Image.asset(
                  Assets.imagesRefresh,
                  height: h(context, 45),
                  width: w(context, 42),
                ),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: Image.asset(
                  Assets.imagesBell,
                  height: h(context, 23),
                  width: w(context, 17),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      backgroundColor: kTertiaryColor.withOpacity(0.09),
      body: Padding(
        padding: symmetric(
          context,
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Welcome",
              color: kPrimaryColor.withOpacity(0.71),
              size: 21,
              weight: FontWeight.w800,
            ),
            CustomText(
              text: "Find your next hangout and meet cool people",
            ),
            SizedBox(
              height: h(context, 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Trending events",
                  size: 13,
                  weight: FontWeight.w700,
                ),
                CustomText(
                  text: "See all",
                  size: 13,
                  color: Color(0xff848484),
                  weight: FontWeight.w700,
                ),
              ],
            ),
            SizedBox(
              height: h(context, 5),
            ),
            Expanded(
              child: Obx(
                () => eventController.eventThread.isEmpty
                    ? Center(
                        child: Text("No DATA"),
                      )
                    : ListView.builder(
                        itemCount: eventController.eventThread.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: only(
                              context,
                              right: 13,
                            ),
                            child: CustomTrendingEvent(
                              imagePath: eventController
                                      .eventThread.value[index].imageUrl ??
                                  dummyNoImage,
                              title: eventController
                                      .eventThread.value[index].title ??
                                  "",
                              location: eventController
                                      .eventThread.value[index].link ??
                                  "",
                            ),
                          );
                        },
                      ),
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: h(context, 160),
                  child: Row(
                    children: [
                      Container(
                        width: w(context, 160),
                        height: h(context, 130),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(h(context, 10)),
                          image: DecorationImage(
                            image: AssetImage(Assets.imagesEvent1),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: w(context, 20),
                      ),
                      Container(
                        width: w(context, 160),
                        height: h(context, 130),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(h(context, 10)),
                          image: DecorationImage(
                            image: AssetImage(Assets.imagesEvent2),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: w(context, 160),
                  child: CustomButton2(
                    firstText: "Create Event",
                    secText: "",
                    onTap: () {
                      Get.to(() => CreateEvent());
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 15,
                  width: w(context, 160),
                  child: CustomButton2(
                    firstText: "Past Events",
                    secText: "",
                    onTap: () {},
                  ),
                )
              ],
            ),
            SizedBox(
              height: h(context, 10),
            ),
            Stack(
              children: [
                Container(
                  width: w(context, 400),
                  height: h(context, 146),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(h(context, 20)),
                    color: Color(0xff404040).withOpacity(0.07),
                  ),
                  child: Padding(
                    padding: all(context, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Sharing is",
                          size: 32,
                          color: Color(0xff404040),
                          weight: FontWeight.w700,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "caring",
                              size: 32,
                              color: Color(0xff404040),
                              weight: FontWeight.w700,
                            ),
                            CommonImageView(
                              imagePath: Assets.imagesHeart,
                              fit: BoxFit.contain,
                              height: h(context, 30),
                              width: w(context, 30),
                            )
                          ],
                        ),
                        SizedBox(
                          height: h(context, 10),
                        ),
                        SizedBox(
                          width: w(context, 200),
                          child: CustomText(
                            text:
                                "Show your friends you care about them by Inviting your friends to the platform",
                            size: 12,
                            color: Color(0xff404040),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CommonImageView(
                    imagePath: Assets.imagesPerson,
                    fit: BoxFit.contain,
                    height: h(context, 100),
                    width: w(context, 200),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
