// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:oru_phones/provider/filterProvider.dart';
// import 'package:oru_phones/provider/homeProvider.dart';
// import 'package:oru_phones/provider/likeProvider.dart';
// import 'package:oru_phones/provider/sort_provider.dart';
// import 'package:oru_phones/provider/userProvider.dart';
// import 'package:oru_phones/router.dart';
// import 'package:oru_phones/screens/splashScreen.dart';
// import 'package:provider/provider.dart';
// import 'constant/global.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: "AIzaSyC7U3BlUEUbyt6BqXEvKuzDpFHMRnNT_Fc",
//       appId: "1:604923433904:android:24d17d22aa4553c2623c75",
//       messagingSenderId: "604923433904",
//       projectId: "oru-phones-6d36d",
//       storageBucket: "oru-phones-6d36d.firebasestorage.app",
//
//     ),
//   );
//
//
//
//   runApp(
//     MultiProvider(providers: [
//       ChangeNotifierProvider(create: (context) => UserProvider()),
//       ChangeNotifierProvider(create: (context) => LikeProvider()),
//       ChangeNotifierProvider(create: (context) => HomeProvider()),
//       ChangeNotifierProvider(create: (context) => SortProvider()),
//       ChangeNotifierProvider(create: (context) => FilterProvider()),
//     ], child: MyApp()),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       onGenerateRoute: (settings) => generateRoute(settings),
//       title: 'oru_phones',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         colorScheme: ColorScheme.light(secondary: GlobalVariables.primaryColor),
//         useMaterial3: true,
//       ),
//       home: SplashScreen(),
//     );
//   }
// }










import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:oru_phones/provider/filterProvider.dart';
import 'package:oru_phones/provider/homeProvider.dart';
import 'package:oru_phones/provider/likeProvider.dart';
import 'package:oru_phones/provider/sort_provider.dart';
import 'package:oru_phones/provider/userProvider.dart';
import 'package:oru_phones/screens/splashScreen.dart';
import 'firebase_options.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// Local Notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Local Notifications
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => LikeProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => SortProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _showNotificationOnAppOpen();
  }

  void _showNotificationOnAppOpen() async {
    var androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    var iosDetails = DarwinNotificationDetails();
    var generalNotificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is for testing',
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oru Phones',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}



