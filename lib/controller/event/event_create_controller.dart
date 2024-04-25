import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gaa/core/globals/global_functions.dart';
import 'package:gaa/core/globals/global_variables.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/firebase_collections.dart';
import '../../models/event/event_model.dart';
import '../../view/screens/bottombar/bottombar.dart';
import '../notification/notification_handler.dart';

class EventCreateController extends GetxController {
  TextEditingController eventTitleTextController = TextEditingController();
  TextEditingController eventLinkTextController = TextEditingController();
  TextEditingController eventDateTextController = TextEditingController();
  TextEditingController eventTimeTextController = TextEditingController();
  TextEditingController eventAttendeesTextController = TextEditingController();

  // TextEditingController reEnterPasswordTextController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);

  RxBool isLoading = false.obs;

  FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
  }

  // Function to create a new event
  Future<bool> createEvent() async {
    try {
      isLoading.value = true;

      // Upload image to Firebase Storage if an image is selected
      String? imageUrl;
      if (selectedImage.value != null) {
        imageUrl = await _uploadImage(selectedImage.value!);
      }

      // Create an instance of your EventModel with the data
      EventModel event = EventModel(
        title: eventTitleTextController.text,
        link: eventLinkTextController.text,
        date: eventDateTextController.text,
        time: eventTimeTextController.text,
        imageUrl: imageUrl,
        attendees: const [], // Initialize attendees as an empty list
        createdBy: userModelGlobal.value.userId ?? '',
        eventId: '', // You may set this later
        attendeesTotal: eventAttendeesTextController.text,
      );

// Convert the event to a map
      Map<String, dynamic> eventData = event.toMap();
      // Add event data to Firestore
      DocumentReference eventDocRef = await eventsCollection.add(eventData);

      // Get the ID assigned by Firestore
      String eventId = eventDocRef.id;

      // Update the document with the eventId
      await eventDocRef.update({'eventId': eventId});

      isLoading.value = false;

      List<dynamic> allDeviceIds = await fetchArray();
      // Get the FCM token
      FirebaseMessagingApi().sendFCMNotification(
          deviceToken: allDeviceIds,
          title: "New Event Created",
          body: event.title ?? "",
          type: "global",
          sentBy: userModelGlobal.value.userId ?? "",
          sentTo: "");
      //clearTextControllers();
      return true; // Return true indicating success
    } catch (e) {
      isLoading.value = false;
      print('Error creating event: $e');
      return false; // Return false indicating failure
    }
  }

  //a function to fetch a list of registration ids
  Future<List<dynamic>> fetchArray() async {
    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot =
          await deviceIdsCollection.doc('deviceIds').get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Access the array field from the document data
        List<dynamic> yourArray = documentSnapshot['ids'];
        return yourArray;
      } else {
        // Handle case where document doesn't exist
        return []; // Or throw an error
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching array: $e');
      return []; // Or throw an error
    }
  }

  // Function to upload image to Firebase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child('events').child(fileName);
      await reference.putFile(imageFile);
      String imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to pick an image from the gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        print('No image selected.');
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Function to update an existing event
  Future<void> updateEvent(String eventId, File? newImageFile) async {
    // Implement update logic similar to createEvent
  }

  // Function to delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  //Function to clear out the controllers
  void clearTextControllers() {
    eventTitleTextController.clear();
    eventLinkTextController.clear();
    eventDateTextController.clear();
    eventTimeTextController.clear();
    eventAttendeesTextController.clear();
    selectedImage.value = null;
  }
}
