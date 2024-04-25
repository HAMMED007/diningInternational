import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gaa/core/globals/global_variables.dart';
import 'package:gaa/models/event/event_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/firebase_collections.dart';

class EventController extends GetxController {
  TextEditingController eventTitleTextController = TextEditingController();
  TextEditingController eventLinkTextController = TextEditingController();
  TextEditingController eventDateTextController = TextEditingController();
  TextEditingController eventTimeTextController = TextEditingController();
  TextEditingController eventAttendeesTextController = TextEditingController();

  // TextEditingController reEnterPasswordTextController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);

  RxList<EventModel> eventSearchThread = <EventModel>[].obs;

  Rx<EventModel>? eventModelToUpdate = Rx<EventModel>(EventModel());
//  Rx<EventModel> eventModelToUpdate = Rx<EventModel>(EventModel());

  RxList<EventModel> eventThread = <EventModel>[].obs;

  //A list of events which the user is attending
  RxList<EventModel> eventsAttending = <EventModel>[].obs;

  //A list of events which the user is has already attended
  RxList<EventModel> eventsAlreadyAttending = <EventModel>[].obs;

  RxBool isLoading = false.obs;

  FirebaseStorage _storage = FirebaseStorage.instance;

  late StreamSubscription<QuerySnapshot> _subscription;

  @override
  void onInit() {
    super.onInit();
    listenToEvents();
    //getAllEventsThreads();
  }

  @override
  void onClose() {
    // Cancel the subscription when the controller is closed
    _subscription.cancel();
    super.onClose();
  }

//   void listenToEvents() {
//     _subscription = eventsCollection.snapshots().listen((snapshot) {
//       // Clear the existing list before populating it with new data
//       eventThread.clear();
//       eventsAttending.clear();
//
//       // Iterate through each document snapshot and convert it to an EventModel object
//       snapshot.docs.forEach((doc) {
//         EventModel event = EventModel.fromMap(doc);
//         eventThread.add(event);
// // Check if the attendees array contains the current user's ID
//         if (event.attendees!.contains(userModelGlobal.value.userId)) {
//           eventsAttending.add(event);
//         }
//       });
//       // Sort the eventThread list based on the number of attendees
//       eventThread.sort((a, b) => b.attendees!.length.compareTo(a.attendees!.length));
//     }, onError: (error) {
//       print('Error listening to events: $error');
//     });
//   }

  void searchingInEvent(String keyword) async {
    if (keyword.trim().isEmpty) {
      //print("yes it is empty");
      eventSearchThread.value = <EventModel>[];
      return;
    }

    final filteredResults = eventThread.where((data) =>
        (data.title!.toLowerCase().contains(keyword.toLowerCase()) ||
            data.link!.toLowerCase().contains(keyword.toLowerCase())));

    eventSearchThread.value = filteredResults.toList();
    print("found = ${eventSearchThread.value.length}");
    update();
  }

  void listenToEvents() {
    _subscription = eventsCollection.snapshots().listen((snapshot) {
      // Clear the existing lists before populating them with new data
      eventThread.clear();
      eventsAttending.clear();
      eventsAlreadyAttending.clear(); // Clear the already attending events list

      // Get the current date
      DateTime currentDate = DateTime.now();

      // Iterate through each document snapshot and convert it to an EventModel object
      snapshot.docs.forEach((doc) {
        EventModel event = EventModel.fromMap(doc);
        eventThread.add(event);
        // Check if the attendees array contains the current user's ID
        if (event.attendees!.contains(userModelGlobal.value.userId)) {
          eventsAttending.add(event);
          // Parse the event date from the string
          List<String> parts = event.date!.split('/');
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          DateTime eventDate = DateTime(year, month, day);
          // Check if the event date is in the past
          if (eventDate.isBefore(currentDate)) {
            eventsAlreadyAttending.add(event);
          }
        }
      });
      // Sort the eventThread list based on the number of attendees
      eventThread
          .sort((a, b) => b.attendees!.length.compareTo(a.attendees!.length));
    }, onError: (error) {
      print('Error listening to events: $error');
    });
  }

  //Function to get all the events
  void getAllEventsThreads() async {
    try {
      var snapshot = await eventsCollection.get();

      // Clear the existing list before populating it with new data
      eventThread.clear();

      // Iterate through each document snapshot and convert it to an EventModel object
      snapshot.docs.forEach((doc) {
        EventModel event = EventModel.fromMap(doc);
        eventThread.add(event);
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  //Function to update the Event
  Future<bool> updateEvent(String eventId) async {
    try {
      isLoading.value = true;

      // Upload image to Firebase Storage if an image is selected
      String? imageUrl;
      if (selectedImage.value != null) {
        imageUrl = await _uploadImage(selectedImage.value!);
      }

      print(eventModelToUpdate);

      // Create an instance of your EventModel with the updated data
      EventModel updatedEvent = EventModel(
        title: eventTitleTextController.text == ""
            ? eventModelToUpdate?.value.title
            : eventTitleTextController.text,
        link: eventLinkTextController.text == ""
            ? eventModelToUpdate?.value.link
            : eventLinkTextController.text,
        date: eventDateTextController.text == ""
            ? eventModelToUpdate?.value.date
            : eventDateTextController.text,
        time: eventTimeTextController.text == ""
            ? eventModelToUpdate?.value.time
            : eventTimeTextController.text,
        imageUrl:
            imageUrl == null ? eventModelToUpdate?.value.imageUrl : imageUrl,
        attendees: eventModelToUpdate
            ?.value.attendees, // Initialize attendees as an empty list
        createdBy: userModelGlobal.value.userId ?? '',
        eventId: eventId, // Assign the provided eventId
        attendeesTotal: eventAttendeesTextController.text == ""
            ? eventModelToUpdate?.value.attendeesTotal
            : eventAttendeesTextController.text,
      );

      // Convert the updated event to a map
      Map<String, dynamic> updatedEventData = updatedEvent.toMap();

      // Update the event document in Firestore
      await eventsCollection.doc(eventId).update(updatedEventData);

      isLoading.value = false;
//      clearTextControllers();
      return true; // Return true indicating success
    } catch (e) {
      isLoading.value = false;
      print('Error updating event: $e');
      return false; // Return false indicating failure
    }
  }

  //Function to delete the event
  Future<bool> deleteEvent(String eventId) async {
    try {
      isLoading.value = true;

      // Delete the event document from Firestore
      await eventsCollection.doc(eventId).delete();

      isLoading.value = false;
      return true; // Return true indicating success
    } catch (e) {
      isLoading.value = false;
      print('Error deleting event: $e');
      return false; // Return false indicating failure
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

  Future<bool> addUserToEvent(String eventId, String userId) async {
    try {
      // Get the event document from Firestore
      DocumentReference eventDocRef = eventsCollection.doc(eventId);
      DocumentSnapshot eventDoc = await eventDocRef.get();

      // Check if the user ID is already in the attendees array
      List<dynamic> attendees = eventDoc['attendees'];
      if (!attendees.contains(userId)) {
        // If the user is not already in the attendees array, add the user ID
        attendees.add(userId);

        // Update the event document with the modified attendees array
        await eventDocRef.update({'attendees': attendees});
        return true; // User successfully added to the event
      } else {
        // User is already in the attendees array, do not add again
        print('User is already attending the event.');
        return false; // User already attending the event
      }
    } catch (e) {
      print('Error adding user to event: $e');
      return false; // Error occurred while adding user to event
    }
  }

  //Function to clear out the controllers
  void clearTextControllers() {
    eventTitleTextController.clear();
    eventLinkTextController.clear();
    eventDateTextController.clear();
    eventTimeTextController.clear();
    eventAttendeesTextController.clear();
  }
}
