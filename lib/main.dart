import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fr.innoyadev.mkgodev/tripDetails/tripDetails.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fr.innoyadev.mkgodev/SplashScreen/splashScreen.dart';
import 'package:fr.innoyadev.mkgodev/download/takephotoModel.dart';
import 'package:fr.innoyadev.mkgodev/profile/takephotoControlller.dart';
import 'package:fr.innoyadev.mkgodev/signup/registerModel.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'login/loginModel.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  await _flutterLocalNotificationPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  await _flutterLocalNotificationPlugin
      .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitailizationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher.png');
    var iosInitailizationSettings = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitailizationSettings,
      iOS: iosInitailizationSettings,
    );

    await _flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

  tzdata.initializeTimeZones();
  await GetStorage.init();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  final box = GetStorage();
  box.write('version', version);

  print('Package data : $appName, $packageName, $version, $buildNumber');

  GetStorage storage = GetStorage();
  if (storage.hasData('imagePath2')) {
    storage.remove('imagePath2');
  }

  Get.put(AuthController());
  Get.put(UserController());
  Get.put(TakePhotoController());
  Get.put(TakePhotoController2());
  HttpOverrides.global = MyHttpOverrides();

  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? initialMessage) {
    if (initialMessage != null) {
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'flutter_local_notifications_channel',
        'flutter_local_notifications_channel',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      _flutterLocalNotificationPlugin.show(
        payload: initialMessage.data.toString(),
        0,
        initialMessage.notification!.title.toString(),
        initialMessage.notification!.body.toString(),
        notificationDetails,
      );

      final courseId = initialMessage.data['course-id'];

      _navigateToTripDetails(courseId);
    }
  });

  FirebaseMessaging.onMessage.listen((message) {
    print(
        "notification title ------------ ${message.notification!.title.toString()}");
    print(message.notification!.body.toString());

    playsound();
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'flutter_local_notifications_channel',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    _flutterLocalNotificationPlugin.show(
      payload: message.data.toString(),
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );

    final title = message.notification?.title;
    final description = message.notification?.body;

    Map<String, dynamic> data = message.data;
    print('Meta data: $data');
    final courseId = data['course-id'];
    QuickAlert.show(
      confirmBtnColor: Color(0xFF3954A4),
      context: Get.overlayContext!,
      showCancelBtn: false,
      showConfirmBtn: false,
      type: QuickAlertType.info,
      title: title,
      text: description,
      widget: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: DialogButton(
          color: Color(0xFF3954A4),
          child: Text(
            "Go To Trip",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            print('Meta data: $data');
            print("the id is this id -----------------------------${courseId}");
            print(
                "the id is this title -----------------------------${title}"); 
            print(
                "the id is this description -----------------------------${description}");

            Navigator.of(Get.overlayContext!)
                .push(MaterialPageRoute(builder: (context) {
              return TripDetails(
                id: courseId,
              );
            }));
           
          },
        ),
      ),
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print(
        "notification title ------------ ${message.notification!.title.toString()}");
    print(message.notification!.body.toString());

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'flutter_local_notifications_channel',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    _flutterLocalNotificationPlugin.show(
      payload: message.data.toString(),
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );

    Map<String, dynamic> data = message.data;
    print('Meta data: $data');
    final courseId = data['course-id'];


    Navigator.of(Get.overlayContext!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => TripDetails(id: courseId)),
      (route) => false, 
    );
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

final player = AudioPlayer();

Future<void> playsound() async {
  String audioPath = "sounds/mpns.mp3";
  await player.play(AssetSource(audioPath));
  print("sounplay");
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "notification title ------------ ${message.notification!.title.toString()}");
  print(message.notification!.body.toString());

  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'flutter_local_notifications_channel',
    'flutter_local_notifications_channel',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification'),
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  _flutterLocalNotificationPlugin.show(
    payload: message.data.toString(),
    0,
    message.notification!.title.toString(),
    message.notification!.body.toString(),
    notificationDetails,
  );

  Map<String, dynamic> data = message.data;
  print('Meta data: $data');
  final courseId = data['course-id'];

  print("going to navigate it bro --------------------$courseId");

  Navigator.of(Get.overlayContext!).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => TripDetails(id: courseId)),
    (route) => false,
  );

}

void _navigateToTripDetails(String courseId) {
  print("starting Navigation---------$courseId");
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.of(Get.overlayContext!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => TripDetails(id: courseId)),
      (route) => false, 
    );
    print("starting Navigation Done---------$courseId");
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final ImageController imageController = Get.put(ImageController());

  final SignupController signupController = Get.put(SignupController());

  final LoginController loginController = Get.put(LoginController());

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      title: 'MKGO Mobile',
      home: SplashScreen(),
    );
  }
}

class ImageController extends GetxController {
  RxString galleryFilePath = ''.obs;
  RxString cameraFilePath = ''.obs;

  void setGalleryFilePath(String? path) {
    galleryFilePath.value = path ?? '';
  }

  void setCameraFilePath(String? path) {
    cameraFilePath.value = path ?? '';
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
