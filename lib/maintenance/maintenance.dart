// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({super.key});

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/maintenance.png'),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Nous serons de retour bientot',
            style: TextStyle(
              color: Color(0xFF524D4D),
              fontSize: 25,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'LA maintenance est en cours',
            style: TextStyle(
              color: Color(0xFF524D4D),
              fontSize: 18,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 240,
            width: 128,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
              'assets/images/MKGOLogo.png',
            ))),
          ),
          Text(
            'Copyright © 2023 - Innoya Services',
            style: TextStyle(
              color: Color(0xFF524D4D),
              fontSize: 14,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          )
        ],
      ),
    );
  }
}
