// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../controller/event/event_controller.dart';
import '../../../core/globals/global_variables.dart';
import '../../widget/Custom_DropDown_widget.dart';
import '../../widget/Custom_Textfield_widget.dart';
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
              SizedBox(
                width: w(context, 14),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Welcome",
                    size: 21,
                    weight: FontWeight.w700,
                  ),
                  CustomText(
                    text: "Find your next hangout and meet cool people",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: symmetric(
          context,
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h(context, 10),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    onChanged: (value) {
                      eventController.searchingInEvent(value);
                      //            searchQuery.value = value;
                    },
                    controller: null,
                    hintText: 'Search events or simply search by location',
                  ),
                ),
                SizedBox(
                  width: w(context, 10),
                ),
                CustomDropDown(),
              ],
            ),
            SizedBox(
              height: h(context, 20),
            ),
            Expanded(
              child: Obx(
                () => eventController.eventThread.isEmpty
                    ? Center(
                        child: Text("No DATA"),
                      )
                    : GridView.builder(
                        itemCount: eventController.eventThread.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return CustomTrendingEvent(
                            imagePath: eventController
                                    .eventThread.value[index].imageUrl ??
                                dummyNoImage,
                            title: eventController
                                    .eventThread.value[index].title ??
                                "",
                            location:
                                eventController.eventThread.value[index].link ??
                                    "",
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.65,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
