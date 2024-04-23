// // ignore_for_file: unnecessary_new, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:fr.innoyadev.mkgodev/login/login.dart';

// // import '../signup/signUp.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToLoginScreen();
//   }

//   Future<void> _navigateToLoginScreen() async {
//     await Future.delayed(Duration(seconds: 3));

//     // Check if the widget is still mounted before navigating
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         PageRouteBuilder(
//           transitionDuration: Duration(milliseconds: 1750),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//           pageBuilder: (context, animation, secondaryAnimation) {
//             return loginScreen();
//           },
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Image.asset(
//         'assets/images/splash3.gif',
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//       ),
//     );
//   }
// }
// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fr.innoyadev.mkgodev/homeScreen/AdminPlanning.dart';
import 'package:fr.innoyadev.mkgodev/homeScreen/DriverPlanning.dart';
import 'package:fr.innoyadev.mkgodev/login/login.dart';
// import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

GetStorage box = GetStorage();

// import '../signup/signUp.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginScreen();
  }

  Future<void> _navigateToLoginScreen() async {
    await Future.delayed(Duration(seconds: 3));

    // Check if the widget is still mounted before navigating
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1750),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            if (box.hasData('splashToken') ||
                box.hasData('splash_user_id') ||
                box.hasData('splash_user_nom') ||
                box.hasData('splash_user_prenom')) {
              List<dynamic> role = box.read('splash_user_roles');
               if (role.contains('ROLE_CHAUFFEUR')) {
                return LandingScreen2();
              } else {
                return LandingScreen1();
              }
            } else {
              return loginScreen();
            }
            // return loginScreen();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/splash3.gif',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
