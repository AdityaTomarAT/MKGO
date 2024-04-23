// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fr.innoyadev.mkgodev/lists/driver/panierDriverList.dart';
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:get/get.dart';
import 'package:pie_menu/pie_menu.dart';

class PanierDriver extends StatefulWidget {
  const PanierDriver({super.key});

  @override
  State<PanierDriver> createState() => PanierDriverState();
}

class PanierDriverState extends State<PanierDriver> {
  TextEditingController comment = TextEditingController();
  TextEditingController reassign = TextEditingController();
  TextEditingController returnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      isCalled = true;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      isCalled = true;
    });
  }

  bool isCalled = false;

  @override
  Widget build(BuildContext context) {
    return PieCanvas(
      theme: PieTheme(
          delayDuration: Duration.zero,
          tooltipTextStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          buttonSize: 65),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(color: Color(0xFF3954A4)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  'Panier',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.to(() => Profile());
                                  },
                                  icon: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.height / 45,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 45,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
                    height: 650,
                    child: isCalled ? PanierDriverList() : SizedBox.shrink()))
          ])),
    );
  }
}
