import 'package:cloud_firestore/cloud_firestore.dart';

final userCollection = FirebaseFirestore.instance.collection('users');
final bookingsCollection = FirebaseFirestore.instance.collection('bookings');
final reviewsCollection = FirebaseFirestore.instance.collection('reviews');
final eventsCollection = FirebaseFirestore.instance.collection('events');
