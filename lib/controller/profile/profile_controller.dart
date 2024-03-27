import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gaa/core/globals/global_functions.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/globals/global_variables.dart';
import '../../core/utils/firebase_collections.dart';
import '../../models/user/user_model.dart';

class ProfileController extends GetxController {
  TextEditingController firstName = TextEditingController();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController bioTextController = TextEditingController();
  RegExp noNumbersRegex = RegExp(r'^[^\d]+$');

  RxBool isLoading = false.obs;

  FirebaseStorage _storage = FirebaseStorage.instance;

  Rx<File?> selectedImage = Rx<File?>(null);

  //checking user name
  bool checkUserName(String userName) {
    return noNumbersRegex.hasMatch(userName);
  }

  Future<void> saveUserInfo() async {
    try {
      // Upload image to Firebase Storage if an image is selected
      String? imageUrl;
      if (selectedImage.value != null) {
        imageUrl = await _uploadImage(selectedImage.value!);
      }

      print(firstName.text);
      // Add or update user information in Firestore
      // Update specific fields in Firestore
      await userCollection.doc(userModelGlobal.value.userId).update({
        'userFirstName': firstName.text.trim() == ""
            ? userModelGlobal.value.userFirstName
            : firstName.text.trim(),
        'userLocation': locationTextController.text.trim() == ""
            ? userModelGlobal.value.userLastName
            : locationTextController.text.trim(),
        'userBio': bioTextController.text.trim() == ""
            ? userModelGlobal.value.userBio
            : bioTextController.text.trim(),
        'userProfilePic': imageUrl ?? "",
      });

      clearTextControllers(
        firstName,
        locationTextController,
        bioTextController,
      );
      selectedImage = Rx<File?>(null);

      getUserData(userId: userModelGlobal.value.userId ?? "");
      print('User information saved successfully!');
    } catch (e) {
      print('Error saving user information: $e');
    }
  }

  // Function to upload image to Firebase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          _storage.ref().child('userProfileImages').child(fileName);
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

  void clearTextControllers(
    TextEditingController controller1,
    TextEditingController controller2,
    TextEditingController controller3,
  ) {
    controller1.clear();
    controller2.clear();
    controller3.clear();
  }
}
