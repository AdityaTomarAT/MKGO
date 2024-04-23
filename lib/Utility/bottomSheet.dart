// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/login/login.dart';
import 'package:fr.innoyadev.mkgodev/registrationsScreens/success.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
// import 'package:fr.innoyadev.mkgodev/Model/typeData.dart';
// import 'package:fr.innoyadev.mkgodev/login/loginModel.dart';
// import 'package:searchfield/searchfield.dart';

final TextEditingController searchController1 = TextEditingController();
final TextEditingController searchController2 = TextEditingController();
final TextEditingController searchController3 = TextEditingController();
final TextEditingController searchController4 = TextEditingController();
final TextEditingController searchController5 = TextEditingController();
final TextEditingController searchController6 = TextEditingController();
final TextEditingController assignController = TextEditingController();
final TextEditingController nom = TextEditingController();
final TextEditingController prenom = TextEditingController();
final TextEditingController telephone = TextEditingController();
final TextEditingController email = TextEditingController();
final TextEditingController address = TextEditingController();

Future<dynamic> bottomSheet4(BuildContext context) {
  void clearTextField5() {
    assignController.text = '';
  }

  return showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'ReturnTrip',
                          style: TextStyle(
                            color: Color(0xFF524D4D),
                            fontSize: 18,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                            height: 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 95,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        // print('Ontap 2 Triggered..!!');
                        // annulerBottomSheet(context);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            'Return Ride',
                            style: TextStyle(
                              color: Color(0xFF524D4D),
                              fontSize: 18,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        print('Ontap 2 Triggered..!!');
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            'Client Absent',
                            style: TextStyle(
                              color: Color(0xFF524D4D),
                              fontSize: 18,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      }).whenComplete(clearTextField5);
}

String selectedValue2 = 'Belongs To';
List<String> values1 = [
  "'INNOYA SERVICES // L'UNION 2",
  "INNOYA SERVICES /@/ AUZIELLE",
  "TAXI ATM"
];
String selectedValueForDialog = 'Belongs To';
FocusNode _textFieldFocus = FocusNode();
bool isTapped = false; // Track if the TextField is tapped

Future<dynamic> editSheet(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Flexible(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue.shade50, Color(0xFFECF4FF)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              height: MediaQuery.of(context).size.height / 1.6,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Color(0xFF524D4D),
                                fontSize: 18,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                                height: 0.05,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 0.85,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nom*',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 16,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(15)),
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.40,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: TextField(
                                    cursorHeight: 20,
                                    controller: nom,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.05,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      filled: true,
                                      fillColor: Colors.blue.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 0.85,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Prenom*',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 16,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(15)),
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.40,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: TextField(
                                    cursorHeight: 20,
                                    controller: prenom,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 0.85,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email*',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 16,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(15)),
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.40,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: TextField(
                                    cursorHeight: 20,
                                    controller: email,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 0.85,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Telephone*',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 16,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(15)),
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.40,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: TextField(
                                    cursorHeight: 20,
                                    controller: telephone,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 0.85,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Address*',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 16,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(15)),
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.40,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: TextField(
                                    cursorHeight: 20,
                                    controller: address,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 55,
                    ),
                    Flexible(
                      child: Container(
                        width: 180,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

Future<dynamic> editSheet2(BuildContext context) {
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController security = TextEditingController();
  TextEditingController mutelle = TextEditingController();
  TextEditingController telephone = TextEditingController();
  return showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.15,
            child: Center(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Add Client',
                            style: TextStyle(
                              color: Color(0xFF524D4D),
                              fontSize: 18,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                              height: 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 0.85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: 150,
                            child: TextFormField(
                              controller: nom,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Remove the TextField's default border
                                ),
                                labelText: 'Nom: ',
                                labelStyle: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 16,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: 150,
                            child: TextFormField(
                              controller: prenom,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Remove the TextField's default border
                                ),
                                labelText: 'Prenom: ',
                                labelStyle: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 16,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.05,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 0.85,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 150,
                              child: TextFormField(
                                controller: title,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Remove the TextField's default border
                                  ),
                                  labelText: 'Titre 1 * : ',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF524D4D),
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0.05,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 150,
                              child: TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Remove the TextField's default border
                                  ),
                                  labelText: 'Adresse 1 * : ',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF524D4D),
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 0.85,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 150,
                              child: TextFormField(
                                controller: title,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Remove the TextField's default border
                                  ),
                                  labelText: 'Titre 2 * : ',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF524D4D),
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0.05,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 150,
                              child: TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Remove the TextField's default border
                                  ),
                                  labelText: 'Adresse 2 * : ',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF524D4D),
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 0.85,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 150,
                              child: TextFormField(
                                controller: title,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Remove the TextField's default border
                                  ),
                                  labelText: 'Titre 3 * : ',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF524D4D),
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0.05,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 150,
                              child: TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Remove the TextField's default border
                                  ),
                                  labelText: 'Adresse 3 * : ',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF524D4D),
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //   child: TextFormField(
                  //     style: TextStyle(
                  //       color: Color(0xFF524D4D),
                  //       fontSize: 16,
                  //       fontFamily: 'Kanit',
                  //       fontWeight: FontWeight.w400,
                  //       height: 0.05,
                  //     ),
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(
                  //             10), // Remove the TextField's default border
                  //       ),
                  //       labelText: 'N* Securite Number * : ',
                  //       labelStyle: TextStyle(
                  //         color: Color(0xFF524D4D),
                  //         fontSize: 16,
                  //         fontFamily: 'Kanit',
                  //         fontWeight: FontWeight.w400,
                  //         height: 0.05,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 10),
                    child: Container(
                      child: TextFormField(
                        controller: security,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Remove the TextField's default border
                          ),
                          labelText: 'N* Securite Number * : ',
                          labelStyle: TextStyle(
                            color: Color(0xFF524D4D),
                            fontSize: 16,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            height: 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 10),
                    child: Container(
                      child: TextFormField(
                        controller: mutelle,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Remove the TextField's default border
                          ),
                          labelText: 'Type mutuelle * : ',
                          labelStyle: TextStyle(
                            color: Color(0xFF524D4D),
                            fontSize: 16,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            height: 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 10),
                    child: Container(
                      child: TextFormField(
                        controller: telephone,
                        maxLength: 15,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Remove the TextField's default border
                          ),
                          labelText: 'Telephone * : ',
                          labelStyle: TextStyle(
                            color: Color(0xFF524D4D),
                            fontSize: 16,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            height: 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff3954a4)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3954A4)),
                      onPressed: () async {},
                      child: Text("Submit",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

void showDeleteAccountBottomSheet(BuildContext context) {
  final currentheight = MediaQuery.of(context).size.height;
  final currentidht = MediaQuery.of(context).size.width;
  Future<void> deleteAccount() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    // final storage = GetStorage();

    final id = box.read('user_id') ?? '';

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionRegisterUrl =
        gestionBaseUrl + "mob/delete-compte/" + id.toString();

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionRegisterUrl));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3954A4),
          ),
        ),
        barrierDismissible: false,
      );
      GetStorage().erase();
      Get.offAll(() => loginScreen());
      String notes = "Account Deleted Successfully";
      Get.to(() => SuccessRegistrationScreen(
            notes: notes,
          ));
      print(await response.stream.bytesToString());
      Get.back();
    } else {
      print(response.reasonPhrase);
    }
  }

  showModalBottomSheet(
    backgroundColor: Color(0xFFE6F7FD),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(38),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: currentheight <= 616
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height / 3.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 10,
              child: Center(
                child: Text(
                  'Supprimer le compte',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                deleteAccount();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(width: 0.5, color: Colors.black),
                )),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Confirmer',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        height: 0.09,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(width: 0.5, color: Colors.black),
                )),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Annuler',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        height: 0.09,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

Future<dynamic> deleteAccount(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Delete Account??',
                          style: TextStyle(
                            color: Color(0xFF524D4D),
                            fontSize: 18,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            height: 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 75,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF3954A4),
                            ),
                            child: Text('Delete Account'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Future<dynamic> logOut(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade50, Color(0xFFECF4FF)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            height: MediaQuery.of(context).size.height / 3.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Are You Sure Want to Log Out ??',
                          style: TextStyle(
                            color: Color(0xFF524D4D),
                            fontSize: 18,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            height: 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 75,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF3954A4),
                            ),
                            child: Text('Log Out'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
