import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/routes/routes.dart';
import 'config/theme/light_theme.dart';
import 'controller/notification/notification_handler.dart';
import 'core/bindings/bindings.dart';
import 'firebase_options.dart';
import 'models/notification/notification_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//  await GetStorage.init();
  await FirebaseMessagingApi().initNotifications();

  runApp(MyApp());
}

//DO NOT REMOVE Unless you find their usage.
String dummyImgForProfile =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqKptpW_v7E9wHinvNr95ZyP2dY__u6GKKLg&usqp=CAU';

class MyApp extends StatefulWidget {



  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'GAA',
      theme: LightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppLinks.splash_screen,
      getPages: AppRoutes.pages,
      initialBinding: InitialBindings(),
      defaultTransition: Transition.fadeIn,
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();

    //works only when the app is running on foreground
    FirebaseMessaging.onMessage.listen((event) async {
      CollectionReference _notificationCollection =
      FirebaseFirestore.instance.collection('notifications');
      if (event.notification != null) {
        // print(event.notification!.body);
        // print(event.notification!.title);
        // print(event.data);

        NotificationModel notification = NotificationModel(
          title: event.notification!.title ?? "No Title",
          subtitle: event.notification!.body ?? "No Subtitle",
          time: DateTime.now().millisecondsSinceEpoch,
          //TODO: Implement a real ID by using the message.data
          sentBy: event.data["sentBy"],
         // sentTo: event.data["sentTo"],
          type: event.data["type"],
          // status: 1, // You can set this as needed
        );
        DocumentReference documentRef =
        await _notificationCollection.add(notification.toMap());

        // Get the ID of the newly added document
        String documentId = documentRef.id;

        // Update the document with the notId field set to the document ID
        await documentRef.update({'notId': documentId});
        print("success from onMessage");
      }
    });
  }
}




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'config/routes/routes.dart';
// import 'config/theme/dark_theme.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 778),
//       builder: (context, child) => GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Popdarts',
//         theme: DartTheme,
//         themeMode: ThemeMode.light,
//         initialRoute: AppLinks.splash_screen,
//         getPages: AppRoutes.pages,
//         defaultTransition: Transition.fadeIn,
//       ),
//     );
//   }
// }
