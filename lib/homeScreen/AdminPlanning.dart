// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, deprecated_member_use, prefer_final_fields, unused_element

import 'dart:async';
import 'dart:convert';

// import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/lists/driver/panierDriver.dart';
// import 'package:fr.innoyadev.mkgodev/tripDetails/tripDetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:fr.innoyadev.mkgodev/homeScreen/Cart.dart';
import 'package:fr.innoyadev.mkgodev/homeScreen/homeScreen.dart';
import 'package:fr.innoyadev.mkgodev/notes/notes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:back_button_interceptor/back_button_interceptor.dart';

class LandingScreen2 extends StatefulWidget {
  const LandingScreen2({super.key});

  @override
  State<LandingScreen2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<LandingScreen2> {
  int? currentIndex;
  int myIndex = 0;
  List<Widget> widgetList = [
    HomeScreen(),
    Notes(),
    PanierDriver(),
  ];

  DateTime? _lastTap;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      locationPermission().whenComplete(() {
        _requestLocationAndNotificationPermission();
      });
    }

    final args = Get.arguments;

    if (args != null && args is int) {
      myIndex = args;
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // await Firebase.initializeApp();
    print('Message: ${message.notification!.title.toString()}');
    // print('C')
    Map<String, dynamic> data = message.data;

    int id = int.parse(data['courseId']);
    print('data: $data');

    print('Course Id: $id');
    // Get.to(() => TripDetails(), arguments: [id]);
  }

  FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;

  Future getDeviceToken() async {
    final fcm = GetStorage();
    String? deviceToken = await _firebaseMessage.getToken();

    fcm.write('FCMToken', deviceToken);

    // print('FCM Token in string for posting on backend api server: $mToken');

    return (deviceToken == null) ? "" : deviceToken;
  }

  Future<void> locationPermission() async {
    var status2 = await Permission.location.status;
    var status3 = await Permission.storage.status;
    if (status2.isDenied) {
      await Permission.location.request();
      print('permission : $status2');
    }
    if (status3.isDenied) {
      await Permission.storage.request();
      print('permission : $status2');
    } else {
      _requestLocationAndNotificationPermission();
    }
  }

  Future<void> _requestLocationAndNotificationPermission() async {
    var locationStatus = await Permission.location.request();
    // var notificationStatus = await Permission.notification.request();

    if (locationStatus.isGranted) {
      _startLocationUpdates();
    } else if (locationStatus.isDenied) {
    } else if (locationStatus.isPermanentlyDenied) {}
  }

  late Timer timer;

  void _startLocationUpdates() async {
    await CurrentLocation();
    setLocation();
    timer = Timer.periodic(Duration(minutes: 3), (timer) {
      CurrentLocation();
      Future.delayed(Duration(seconds: 2), () {
        setLocation();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer;
  }

  String? location1;
  String? location2;

  Future<void> CurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitude1 = position.latitude;
      double longitude1 = position.longitude;
      setState(() {
        location2 = longitude1.toString();
        location1 = latitude1.toString();
      });
      print(
          'Current location: latitude after setState: ${location1}, Longitude after setState ${location2}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  String role = "";

  final UserID = storage.read('user_id');

  Future<void> setLocation() async {
    final box = GetStorage();
    final token = box.read('token');

    final deviceName = box.read('deviceName');

    print('User Role is : $role');
    print('User id for locations : $UserID');
    print('User latitude is : $location1');
    print('User longitude is : $location2');
    print('Device Name is : $deviceName');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final LocationBaseUrl = configJson['planning_baseUrl'];
    final LocationApiKey = configJson['planning_apiKey'];

    final LocationMainUrl = LocationBaseUrl + "set/location";

    var headers = {
      'x-api-key': '$LocationApiKey',
      'Authorization': 'Bearer ' + token
    };

    List<dynamic> userRoles = storage.read('user_roles') ?? [];

    if (userRoles.contains('ROLE_CHAUFFEUR')) {
      setState(() {
        role = "ROLE_CHAUFFEUR";
      });
    }
    print('Role for the location function: $role');

    print(
        'Data for API Body in Location Function: $location1, $location2, $UserID, $role, $deviceName');

    var request = http.Request('POST', Uri.parse(LocationMainUrl));
    request.body = json.encode({
      "chauffeur-id": UserID.toString(),
      "role": role,
      "long": location2.toString(),
      "lat": location1.toString(),
      "userAgent": deviceName.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('Location is set after API');
    } else {
      print(response.reasonPhrase);
      print('Location is not set after API');
    }
  }

  bool isNavigatingToHome = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (myIndex == 0) {
          return true;
        } else {
          DateTime now = DateTime.now();
          if (_lastTap != null &&
              now.difference(_lastTap!) < Duration(milliseconds: 500)) {
            return true;
          } else {
            _lastTap = now;
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                myIndex = 0;
              });
            });
            return false;
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 14,
          selectedLabelStyle: TextStyle(fontFamily: 'kanit'),
          unselectedLabelStyle: TextStyle(fontFamily: 'kanit'),
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF3954A4),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              label: 'Planning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger_outline_rounded),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Panier',
            )
          ],
        ),
        body: IndexedStack(
          index: myIndex,
          children: widgetList,
        ),
      ),
    );
  }
}
