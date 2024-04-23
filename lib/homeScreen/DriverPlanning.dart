// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last
// 
// import 'dart:convert';

// import 'package:device_info/device_info.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/lists/admin/PanierAdmin.dart';
// import 'package:fr.innoyadev.mkgodev/tripDetails/tripDetails.dart';
import 'package:get/get.dart';
// import 'package:fr.innoyadev.mkgodev/add/add.dart';
import 'package:fr.innoyadev.mkgodev/cart/cart.dart';
// import 'package:fr.innoyadev.mkgodev/homeScreen/Cart.dart';
// import 'package:fr.innoyadev.mkgodev/homeScreen/homeScreen.dart';
import 'package:fr.innoyadev.mkgodev/notes/notes.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:platform_info/platform_info.dart';
// import 'package:http/http.dart' as http;
// import 'package:rflutter_alert/rflutter_alert.dart';

class LandingScreen1 extends StatefulWidget {
  const LandingScreen1({super.key});

  @override
  State<LandingScreen1> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<LandingScreen1> {

  int? currentIndex;
  int myIndex = 0;
  List<Widget> widgetList = [
    Cart(),
    Notes(),
    PanierAdmin(),
    // Add(),
  ];

  DateTime? _lastTap;

  @override
  void initState() {
    super.initState();
    // notificationServices.requestNotificationPermission();
    // notificationServices.firebaseInit();
    // locationPermission();

    // in

    final args = Get.arguments;

    if (args != null && args is int) {
      myIndex = args;
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if the user is on the HomeScreen
        if (myIndex == 0) {
          // If on HomeScreen, exit on a single tap
          return true;
        } else {
          // If on other screens, handle navigation to HomeScreen and double-tap exit
          DateTime now = DateTime.now();

          if (_lastTap != null &&
              now.difference(_lastTap!) < Duration(milliseconds: 500)) {
            // Exiting the app on double-tap
            return true;
          } else {
            // If it's a single tap, update _lastTap and navigate to HomeScreen
            _lastTap = now;
            // Navigate to HomeScreen after a short delay
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                myIndex = 0;
              });
            });

            // Prevent immediate exit
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
              ]),
          body: IndexedStack(
            index: myIndex,
            children: widgetList,
          )),
    );
  }
}
