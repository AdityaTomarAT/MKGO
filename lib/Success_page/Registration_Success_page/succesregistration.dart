// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:fr.innoyadev.mkgodev/expenseReport/expenseReport.dart';
import 'package:fr.innoyadev.mkgodev/login/login.dart';
// import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:get/get.dart';

class SuccessregistrationScreen extends StatefulWidget {
  final String notes;

  SuccessregistrationScreen({Key? key, required this.notes}) : super(key: key);

  @override
  State<SuccessregistrationScreen> createState() => _SuccessSState();
}

class _SuccessSState extends State<SuccessregistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Intercept system back button press and navigate to Profile screen
        Get.offAll(() => loginScreen());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => loginScreen(),
        //   ),
        // );

        // Prevent default back navigation
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF18B59A),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/success.png')),
            SizedBox(height: 30),
            Text(
              'Thank you very much',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            SizedBox(height: 15),
            Text(
              widget.notes,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            SizedBox(height: 25),
            SizedBox(height: 35),
            GestureDetector(
              onTap: () {
                // Navigate to the Profile screen
                Get.offAll(() => loginScreen());
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => loginScreen(),
                //   ),
                // );
              },
              child: Container(
                width: 269,
                height: 64,
                decoration: ShapeDecoration(
                  color: Color(0x00D9D9D9),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
