import 'dart:io';

import 'package:admin_banja/controllers/dashboard_controller.dart';
import 'package:admin_banja/pager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';

import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (message.notification != null) {
    // ignore: avoid_print
    print(
        'Message also contained a notification: ${message.notification!.body}');

    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // icon: android?.smallIcon,
            // other properties...
          ),
        ));
  }
  // ignore: avoid_print
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// since the plugin is initialised in the `main` function

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();

  Get.put(DashboardController());

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     print(
  //         'Message also contained a notification: ${message.notification!.body}');

  //     flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification!.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             channelDescription: channel.description,
  //             // icon: android?.smallIcon,
  //             // other properties...
  //           ),
  //         ));
  //   }
  // });

  // if (!kIsWeb) {
  //   var initializationSettingsAndroid =
  //       const AndroidInitializationSettings('mipmap/ic_launcher');
  //   channel = const AndroidNotificationChannel(
  //     'new_loan_request_channel', // id
  //     'New Loan Application ', // title
  //     description:
  //         'This channel receives new loan application requests from clients.', // description
  //     importance: Importance.high,
  //   );

  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //   /// Create an Android Notification Channel.
  //   ///
  //   /// We use this channel in the `AndroidManifest.xml` file to override the
  //   /// default FCM channel to enable heads up notifications.
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);

  //   /// Update the iOS foreground notification presentation options to allow
  //   /// heads up notifications.
  //   // await FirebaseMessaging.instance
  //   //     .setForegroundNotificationPresentationOptions(
  //   //   alert: true,
  //   //   badge: true,
  //   //   sound: true,
  //   // );

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: (String? payload) async {
  //     if (payload != null) {
  //       debugPrint('notification payload: $payload');
  //     }
  //     // selectedNotificationPayload = payload;
  //     // selectNotificationSubject.add(payload);
  //   });
  // }

  // bool isSubscribedToTopic =
  //     GetStorage().read('is_subscribed_to_new_requests') ?? true;
  //       await FirebaseMessaging.instance.subscribeToTopic("new_loan_request");

  // if (isSubscribedToTopic) {

  //   GetStorage().write('is_subscribed_to_new_requests', false);
  // }

  runApp(
    Phoenix(
      child: const OKToast(
        animationCurve: Curves.easeIn,
        animationDuration: Duration(milliseconds: 200),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: ScreenUtilInit(
          designSize: const Size(1520, 890),
          builder: (buildContext, context) {
            return GetMaterialApp(
              title: 'Tuula Admin',
              theme: ThemeData(
                useMaterial3: true,
                primarySwatch: Colors.blue,
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
                  },
                ),
              ),
              builder: (context, widget) {
                return MediaQuery(
                  //Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 0.95),
                  child: widget!,
                );
              },
              debugShowCheckedModeBanner: false,
              home: const Pager(),
            );
          }),
    );
  }
}
