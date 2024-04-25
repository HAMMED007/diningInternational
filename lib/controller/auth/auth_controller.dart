import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gaa/core/globals/global_functions.dart';
import 'package:gaa/core/utils/firebase_collections.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user/user_model.dart';
import '../../view/screens/bottombar/bottombar.dart';

class AuthController extends GetxController {
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailSignUpTextController = TextEditingController();
  TextEditingController passwordSignUpTextController = TextEditingController();
  TextEditingController reEnterPasswordTextController = TextEditingController();
  TextEditingController emailForgotPasswordTextController =
      TextEditingController();

  bool isChecked02 = false;
  //Controller for signIn
  TextEditingController emailLogInTextController = TextEditingController();
  TextEditingController passwordLogInTextController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> user = Rx<User?>(null);

  RxBool isLoading = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> signUp() async {
    isLoading.value = true;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailSignUpTextController.text,
        password: passwordSignUpTextController.text,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Get the FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        try {
          // Reference to the Firestore document
          DocumentReference documentRef = deviceIdsCollection.doc('deviceIds');

          // Add the FCM token to the array field
          await documentRef.update({
            'ids': FieldValue.arrayUnion([fcmToken]),
          });

          print('FCM token added successfully.');
        } catch (e) {
          print('Error adding FCM token: $e');
        }
      } else {
        print('FCM token is null.');
      }

      // Create a new user object
      UserModel user = UserModel(
        userId: userCredential.user!.uid,
        userEmail: userCredential.user!.email,
        userFirstName: firstNameTextController.text.trim(),
        userLastName: lastNameTextController.text.trim(),
      );

      // Store the user data in Firestore with the user ID
      await userCollection.doc(user.userId).set(user.toMap());

      showSuccessSnackbar(
        title: "Account",
        msg: "Verification email has been sent. Please check your email.",
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isLoading.value = false;
  }

  // // new signUp function
  // Future<void> signUp() async {
  //   isLoading.value = true;
  //   try {
  //     UserCredential userCredential =
  //     await _auth.createUserWithEmailAndPassword(
  //       email: emailSignUpTextController.text,
  //       password: passwordSignUpTextController.text,
  //     );

  //     // Send email verification
  //     await userCredential.user!.sendEmailVerification();

  //     // Show success message
  //     showSuccessSnackbar(
  //       title: "Account",
  //       msg: "Verification email has been sent. Please check your email.",
  //     );

  //     // Wait for the user to verify their email address
  //     await userCredential.user!.reload();
  //     if (userCredential.user!.emailVerified) {
  //       // Email is verified, proceed with other actions
  //       UserModel user = UserModel(
  //         userId: userCredential.user!.uid,
  //         userEmail: userCredential.user!.email,
  //         userFirstName: firstNameTextController.text.trim(),
  //         userLastName: lastNameTextController.text.trim(),
  //         // You may want to add more user details here
  //       );

  //       // Store the user data in Firestore with the user ID
  //       await userCollection.doc(user.userId).set(user.toMap());

  //       // Proceed with other actions after email verification
  //     } else {
  //       // Email is not yet verified

  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   }
  //   isLoading.value = false;
  // }

  Future<void> login() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailLogInTextController.text,
        password: passwordLogInTextController.text,
      );

      //Check if the user's email is verified
      if (!userCredential.user!.emailVerified) {
        showFailureSnackbar(
          title: "Email not verified",
          msg: "Please verify your email address for successful login.",
        );
        isLoading.value = false;
        return;
      }

      // Get the FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        try {
          // Reference to the Firestore document
          DocumentReference documentRef = deviceIdsCollection.doc('deviceIds');

          // Add the FCM token to the array field
          await documentRef.update({
            'ids': FieldValue.arrayUnion([fcmToken]),
          });

          print('FCM token added successfully.');
        } catch (e) {
          print('Error adding FCM token: $e');
        }
      } else {
        print('FCM token is null.');
      }

      // Get the user ID from the authenticated user
      String userId = userCredential.user?.uid ?? '';

      // Retrieve user data using the obtained user ID
      await getUserData(userId: userId);
      showSuccessSnackbar(
          title: "Authentication", msg: "Your Authentication is complete");
      Get.offAll(() => BottomBar());
    } catch (e) {
      showFailureSnackbar(
        title: "User not found",
        msg:
            "Please verify your email address for successful login. If you haven't registered yet then do registered.",
      );
      // showFailureSnackbar(title: "Error", msg: e.toString());
      // Get.snackbar("Error", e.toString());
    }
    isLoading.value = false;
  }

  // A function for recovering the password
  Future<bool> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(
          email: emailForgotPasswordTextController.text);
      print("Successfully sent reset email");
      return true; // Return true if the email was successfully sent
    } catch (e) {
      print('Error sending reset email: $e');
      return false; // Return false if an error occurred while sending the email
    }
  }

  Future<void> signOut() async {
    if (_auth.currentUser != null) {
      if (_auth.currentUser!.providerData[0].providerId == 'password') {
        print("Logging Out from Simple");
        await signOutWithEmail();
      } else if (_auth.currentUser!.providerData[0].providerId ==
          'google.com') {
        print("Logging Out from Google");
        await signOutFromGoogle();
      }
    }
  }

  Future<void> signOutWithEmail() async {
    await _auth.signOut();
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<void> signInWithGoogle() async {
    try {
      await signOutFromGoogle(); // Sign out any previously signed-in accounts
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Sign in with Firebase using Google credentials
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // // Get the Firebase ID token
        // final idToken = await userCredential.user!.getIdToken();
        // box.write('bearerToken', idToken.toString());

        // Now, you can send this idToken to your server
        // to generate a Bearer token.
        //print('Firebase ID Token: $idToken');

        // await Get.find<ProductsController>().getProducts();
        //
        // await registerUser();
        // Create a new user object
        // Check if the user already exists
        final userExists = await doesUserExist(userCredential.user!.uid);

        if (!userExists) {
          UserModel user = UserModel(
            userId: userCredential.user!.uid,
            userEmail: userCredential.user!.email,
            userFirstName: firstNameTextController.text.trim(),
            userLastName: lastNameTextController.text.trim(),
          );

          // Store the user data in Firestore with the user ID
          await userCollection.doc(user.userId).set(user.toMap());
        } else {}

        await getUserData(userId: FirebaseAuth.instance.currentUser!.uid);
        showSuccessSnackbar(
            title: "Authentication", msg: "Your Authentication is Successful");
        Get.offAll(() => BottomBar());
      } else {
        showFailureSnackbar(
            title: "Authentication",
            msg: "Something went wrong, please try again");
        print('Google login cancelled.');
      }
    } catch (error) {
      showFailureSnackbar(title: "Authentication", msg: "$error");
      print('Google login failed: $error');
    }
  }

  Future<bool> doesUserExist(String userId) async {
    // Check if the user with the given userId already exists in Firestore
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.exists;
  }
}
