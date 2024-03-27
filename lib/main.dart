import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/routes/routes.dart';
import 'config/theme/light_theme.dart';
import 'core/bindings/bindings.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

//DO NOT REMOVE Unless you find their usage.
String dummyImgForProfile =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqKptpW_v7E9wHinvNr95ZyP2dY__u6GKKLg&usqp=CAU';

class MyApp extends StatelessWidget {
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
