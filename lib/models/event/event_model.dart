import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? title;
  String? link;
  String? date;
  String? time;
  String? imageUrl;
  List<String>? attendees; // Updated to List<String> type
  String? createdBy;
  String? eventId;
  String? attendeesTotal;

  EventModel({
    this.title = '',
    this.link = '',
    this.date = '',
    this.time = '',
    this.imageUrl = '',
    this.attendees = const [],
    this.createdBy = '',
    this.eventId = '',
    this.attendeesTotal = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'link': link,
      'date': date,
      'time': time,
      'imageUrl': imageUrl,
      'attendees': attendees, // Store List<String> directly
      'createdBy': createdBy,
      'eventId': eventId,
      'attendeesTotal': attendeesTotal,
    };
  }

  factory EventModel.fromMap(DocumentSnapshot snapshot) {
    return EventModel(
      title: snapshot['title'] ?? '',
      link: snapshot['link'] ?? '',
      date: snapshot['date'] ?? '',
      time: snapshot['time'] ?? '',
      imageUrl: snapshot['imageUrl'],
      attendees: List<String>.from(
          snapshot['attendees'] ?? []), // Convert to List<String>
      createdBy: snapshot['createdBy'] ?? '',
      eventId: snapshot['eventId'] ?? '',
      attendeesTotal: snapshot['attendeesTotal'] ?? '',
    );
  }
}
