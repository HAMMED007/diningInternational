// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, invalid_use_of_protected_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaa/controller/event/event_controller.dart';
import 'package:gaa/view/widget/common_image_view_widget.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_styling.dart';
import '../../../core/globals/global_functions.dart';
import '../../widget/Custom_DropDown_widget.dart';
import '../../widget/Custom_Textfield_widget.dart';
import '../../widget/Custom_text_widget.dart';
import 'Custom_Event_Widget.dart';

class Event extends StatelessWidget {
  Event({Key? key}) : super(key: key);

  EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Image.asset(
                Assets.imagesRefresh,
                height: h(context, 45),
                width: w(context, 42),
              ),
              onPressed: () {},
            ),
            CustomText(
              text: "Event list",
              size: 16,
              weight: FontWeight.w500,
              color: kPrimaryColor.withOpacity(0.71),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: symmetric(
            context,
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: h(context, 20),
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
              Obx(
                () => eventController.eventThread.isEmpty
                    ? Center(
                        child: Text("No DATA"),
                      )
                    : eventController.eventSearchThread.isEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: eventController.eventThread.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  CustomEvent(
                                    location: eventController
                                            .eventThread.value[index].link ??
                                        "",
                                    date: eventController
                                            .eventThread.value[index].date ??
                                        "",
                                    time: eventController
                                            .eventThread.value[index].time ??
                                        "",
                                    attendees: eventController.eventThread
                                            .value[index].attendees?.length ??
                                        0,
                                    hasregister: eventController.eventThread
                                            .value[index].createdBy ==
                                        FirebaseAuth.instance.currentUser?.uid,
                                    totalAttendees: int.tryParse(eventController
                                                .eventThread
                                                .value[index]
                                                .attendeesTotal ??
                                            '0') ??
                                        0,
                                    backgroundColor: getBackgroundColor(index),
                                    index: index,
                                    title: eventController
                                            .eventThread.value[index].title ??
                                        "",
                                    profileImagePath: eventController
                                            .eventThread
                                            .value[index]
                                            .imageUrl ??
                                        "",
                                  ),
                                  SizedBox(
                                    height: h(context, 10),
                                  )
                                ],
                              );
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: eventController.eventSearchThread.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  CustomEvent(
                                    location: eventController.eventSearchThread
                                            .value[index].link ??
                                        "",
                                    date: eventController.eventSearchThread
                                            .value[index].date ??
                                        "",
                                    time: eventController.eventSearchThread
                                            .value[index].time ??
                                        "",
                                    attendees: eventController.eventSearchThread
                                            .value[index].attendees?.length ??
                                        0,
                                    hasregister: eventController
                                            .eventSearchThread
                                            .value[index]
                                            .createdBy ==
                                        FirebaseAuth.instance.currentUser?.uid,
                                    totalAttendees: int.tryParse(eventController
                                                .eventSearchThread
                                                .value[index]
                                                .attendeesTotal ??
                                            '0') ??
                                        0,
                                    backgroundColor: getBackgroundColor(index),
                                    index: index,
                                    title: eventController.eventSearchThread
                                            .value[index].title ??
                                        "",
                                    profileImagePath: eventController
                                            .eventSearchThread
                                            .value[index]
                                            .imageUrl ??
                                        "",
                                  ),
                                  SizedBox(
                                    height: h(context, 10),
                                  )
                                ],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
