// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// import 'package:fr.innoyadev.mkgodev/expenseReport/expenseReport.dart';
// import 'package:get/get.dart';
// import 'package:fr.innoyadev.mkgodev/signup/signUp.dart';

class ErrorEditScreen extends StatefulWidget {
    final String notes;

  
  const ErrorEditScreen({Key? key, required this.notes}) : super(key: key);
  

  @override
  State<ErrorEditScreen> createState() => _ErroRState();
}

class _ErroRState extends State<ErrorEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD85052),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/images/error.png')),
          SizedBox(
            height: 30,
          ),
          Text(
            'OOOPS!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          SizedBox(
            height: 15,
          ),
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
          SizedBox(
            height: 45,
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
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
                  'Try Again',
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
          )
        ],
      ),
    );
  }
}
