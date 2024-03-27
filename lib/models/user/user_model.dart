import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userFirstName;
  String? userLastName;
  String? userEmail;
  String? userProfilePic;
  String? userLocation;
  String? userId;
  String? userBio;

  UserModel({
    this.userFirstName = '',
    this.userLastName = '',
    this.userEmail = '',
    this.userProfilePic = '',
    this.userLocation = '',
    this.userId = '',
    this.userBio = '',
  });

  // Convert UserModel object to a map
  Map<String, dynamic> toMap() {
    return {
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'userEmail': userEmail,
      'userProfilePic': userProfilePic,
      'userLocation': userLocation,
      'userId': userId,
      'userBio': userBio,
    };
  }

  // Create UserModel object from a map
  factory UserModel.fromMap(DocumentSnapshot map) {
    return UserModel(
      userFirstName: map['userFirstName'],
      userLastName: map['userLastName'],
      userEmail: map['userEmail'],
      userProfilePic: map['userProfilePic'],
      userLocation: map['userLocation'],
      userId: map['userId'],
      userBio: map['userBio'],
    );
  }
}
