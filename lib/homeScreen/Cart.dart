// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utility/bottomSheet.dart';
import '../profile/profile.dart';

class CART extends StatefulWidget {
  const CART({super.key});

  @override
  State<CART> createState() => CARTState();
}

class CARTState extends State<CART> {
 TextEditingController comment = TextEditingController();
  TextEditingController reassign = TextEditingController();
  TextEditingController returnController =TextEditingController();

  bool isOn = false;

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
    });
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: Text('Reassign to Someone Else'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 0.5)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: reassign,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Reason to Reassign",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(
                    width: 90,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF3954A4),
                      ),
                      child: Text('Return Ride'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Client Absent??'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF3954A4),
                    ),
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool isOptionsAndCommentVisible1 = false;
  bool isOptionsAndCommentVisible2 = false;

  Color todayContainerColor = Colors.white;
  Color futureContainerColor = Colors.white;

  void _changeTodayContainerColor() {
    setState(() {
      todayContainerColor = Color(0xFFF8B43D);
      futureContainerColor = Colors.white;
    });
  }

  void _changeFutureContainerColor() {
    setState(() {
      futureContainerColor = Color(0xFFF8B43D);
      todayContainerColor = Colors.white;
    });
  }

  Future<void> handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    // TODO: implement initState
    todayContainerColor = Color(0xFFF8B43D);
    futureContainerColor = Colors.white;
    super.initState();
    setState(() {
      isRefreshed = true;
    });
    Future.delayed(Duration(milliseconds: 1500), () {
    setState(() {
      isRefreshed = false; 
    });
  });
  }

  bool isRefreshed = false;

  List<dynamic> Region = [];
  bool isAccepted = false;

  Future<dynamic> bottomSheet3(BuildContext context) {
    void clearTextField() {
      returnController.text = '';
    }

    return showModalBottomSheet(
        backgroundColor: Colors.white,
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
              height: MediaQuery.of(context).size.height / 3,
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
                            'Return Ride??',
                            style: TextStyle(
                              color:  Color(0xFF524D4D),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 54,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: TextField(
                              controller: returnController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Motive For Return",
                                border: InputBorder.none,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 250,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF3954A4),
                                ),
                                child: Text('Return'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
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
        }).whenComplete(clearTextField);
  }

 Widget _buildTripCard() {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: 393,
          height: 227,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(5),
            border: Border(
              left: BorderSide(color:  Color(0xFFEA0156)),
              top: BorderSide(width: 5, color:  Color(0xFFEA0156)),
              right: BorderSide(color:  Color(0xFFEA0156)),
              bottom: BorderSide(color:  Color(0xFFEA0156)),
            ),
            boxShadow: [
              BoxShadow(
                color:  Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(children: [
                ListTile(
                  minLeadingWidth: 0,
                  leading: IconButton(
                    onPressed: () async {
                      final call = Uri.parse('tel:+91 9830268966');
                      if (await canLaunchUrl(call)) {
                        launchUrl(call);
                      } else {
                        throw 'Could not launch $call';
                      }
                    },
                    icon: Icon(
                      Icons.phone,
                      color: Color(0xFF3954A4),
                      size: 30,
                    ),
                  ),
                  title: Text(
                    'Nom du client',
                    style: TextStyle(
                      color:  Color(0xFF524D4D),
                      fontSize: 16,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      // Get.to(() => TripDetails());
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: CircleBorder(),
                        shadows: [
                          BoxShadow(
                            color:  Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Image.asset('assets/images/ambulance.png'),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Image.asset('assets/images/location.png'),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Colomoers Gare SNCF, Coomiers',
                      style: TextStyle(
                        color:  Color(0xFF524D4D),
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w300,
                        height: 0.07,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      child: Image.asset('assets/images/location2.png'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        'Gare de, Rue Pierre Semard, 09000 Foix',
                        style: TextStyle(
                          color:  Color(0xFF524D4D),
                          fontSize: 16,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w300,
                          height: 0.07,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 0.5,
                  color:  Color(0xFFE6E6E6),
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Text(
                    isAccepted ? "Accepter" : "À l'attention",
                    style: TextStyle(
                      color:  Color(0xFFEA0156),
                      fontSize: 14,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            bottomSheet3(context);
                          },
                          child: Container(
                              width: 30,
                              height: 30,
                              child: Image.asset('assets/images/folder.png'))),
                      GestureDetector(
                          onTap: () {
                            // Get.to(() => TripDetails());
                          },
                          child: Image.asset('assets/images/search.png')),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset('assets/images/hand.png'),
                      )
                    ],
                  ),
                  trailing: Container(
                    child: Text(
                      '14 Sept.15:25',
                      style: TextStyle(
                        color:  Color(0xFF524D4D),
                        fontSize: 14,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ])),
        ));
  }

  Widget _buildTripCard2() {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: 393,
          height: 227,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(5),
            border: Border(
              left: BorderSide(color: Color(0xFF3954A4)),
              top: BorderSide(width: 5, color: Color(0xFF3954A4)),
              right: BorderSide(color: Color(0xFF3954A4)),
              bottom: BorderSide(color: Color(0xFF3954A4)),
            ),
            boxShadow: [
              BoxShadow(
                color:  Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(children: [
                ListTile(
                  minLeadingWidth: 0,
                  leading: IconButton(
                    onPressed: () async {
                      final call = Uri.parse('tel:+91 9830268966');
                      if (await canLaunchUrl(call)) {
                        launchUrl(call);
                      } else {
                        throw 'Could not launch $call';
                      }
                    },
                    icon: Icon(
                      Icons.phone,
                      color: Color(0xFF3954A4),
                      size: 30,
                    ),
                  ),
                  title: Text(
                    'Nom du client',
                    style: TextStyle(
                      color:  Color(0xFF524D4D),
                      fontSize: 16,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      // Get.to(() => TripDetails());
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: CircleBorder(),
                        shadows: [
                          BoxShadow(
                            color:  Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Image.asset('assets/images/taxi.png'),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Image.asset('assets/images/location.png'),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Colomoers Gare SNCF, Coomiers',
                      style: TextStyle(
                        color:  Color(0xFF524D4D),
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w300,
                        height: 0.07,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      child: Image.asset('assets/images/location2.png'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Gare de, Rue Pierre Semard, 09000 Foix',
                      style: TextStyle(
                        color:  Color(0xFF524D4D),
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w300,
                        height: 0.07,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 0.5,
                  color:  Color(0xFFE6E6E6),
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Text(
                    isAccepted ? "Accepter" : "À l'attention",
                    style: TextStyle(
                      color:  Color(0xFFEA0156),
                      fontSize: 14,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            bottomSheet3(context);
                          },
                          child: Container(
                              width: 30,
                              height: 30,
                              child: Image.asset('assets/images/folder.png'))),
                      GestureDetector(
                          onTap: () {
                            // Get.to(() => TripDetails());
                          },
                          child: Image.asset('assets/images/search.png')),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset('assets/images/hand.png'),
                      )
                    ],
                  ),
                  trailing: Container(
                    child: Text(
                      '14 Sept.15:25',
                      style: TextStyle(
                        color:  Color(0xFF524D4D),
                        fontSize: 14,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ])),
        ));
  }


  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    // final imagePath = storage.read('imagePath2');
    List<dynamic> userRoles = storage.read('user_roles') ?? [];
    bool isAdmin = userRoles.contains('ROLE_ADMIN');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
              child: LiquidPullToRefresh(
                  backgroundColor: Color(0xFF3954A4),
                  height: 80,
                  animSpeedFactor: 2,
                  showChildOpacityTransition: false,
                  color: Colors.white,
                  onRefresh: handleRefresh,
                  child: isRefreshed
                      ? Center(child: CircularProgressIndicator())
                      : isAdmin ? ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Container(
                                width: 411,
                                height: isOptionsAndCommentVisible1 ? 350 : 250,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color:  Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '20 sept. a 06:30',
                                            style: TextStyle(
                                              color: Color(0xFF3954A4),
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity(
                                          vertical: -4, horizontal: -4),
                                      minLeadingWidth: 0,
                                      leading: Image.asset(
                                          'assets/images/medkit.png'),
                                      title: Text(
                                        'Gnonkoue Didier',
                                        style: TextStyle(
                                          color:  Color(0xFF524D4D),
                                          fontSize: 18,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () async {
                                            final call =
                                                Uri.parse('tel:+91 9830268966');
                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          },
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                            size: 30,
                                          )),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 93,
                                          decoration: ShapeDecoration(
                                            color:  Color(0xFFEA690C),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(50),
                                                bottomRight:
                                                    Radius.circular(50),
                                              ),
                                            ),
                                          ),
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10, top: 10),
                                                child: Text(
                                                  'On hold',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.w300,
                                                    height: 0.12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.15,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/location3.png'),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      'Colomoers Gare SNCF, Coomiers',
                                                      style: TextStyle(
                                                        color:
                                                             Color(0xFF524D4D),
                                                        fontSize: 14,
                                                        fontFamily: 'Kanit',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              9.9,
                                                    ),
                                                    Flexible(
                                                      child: IconButton(
                                                          onPressed: () {
                                                            // Get.to(() =>
                                                                // TripDetails());
                                                          },
                                                          icon: Icon(
                                                            Icons.error_outline,
                                                            color: Colors.black,
                                                            size: 30,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      'assets/images/location4.png'),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    'Gare de, Rue Pierre Semard, 09000 Foix',
                                                    style: TextStyle(
                                                      color:  Color(0xFF524D4D),
                                                      fontSize: 14,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      leading: Image.asset(
                                          'assets/images/arrow.png'),
                                      title: Text(
                                        'Options and Comment :',
                                        style: TextStyle(
                                          color:  Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isOptionsAndCommentVisible1 =
                                              !isOptionsAndCommentVisible1;
                                        });
                                      },
                                      trailing: GestureDetector(
                                        onTap: () {
                                          // regionList();
                                          bottomSheet4(context);
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Image.asset(
                                                'assets/images/cont.png'),
                                            Positioned(
                                                top: 5,
                                                left: 3,
                                                child: Text(
                                                  'Daniel Union 3',
                                                  style: TextStyle(
                                                    color: Color(0xFF3954A4),
                                                    fontSize: 14,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                )),
                                            Positioned(
                                              bottom: 3,
                                              left: 9,
                                              child: Container(
                                                width: 95,
                                                height: 26,
                                                decoration: ShapeDecoration(
                                                  color:  Color(0xFFEA690C),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                bottom: 0,
                                                left: 40,
                                                child: Image.asset(
                                                    'assets/images/hand.png'))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isOptionsAndCommentVisible1,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.zero,
                                            width: double.infinity,
                                            // Adjust the height as needed
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.08,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      child: TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade400,
                                                          fontSize: 16,
                                                          fontFamily: 'Kanit',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          suffixIcon: Icon(
                                                            Icons
                                                                .euro_symbol_outlined,
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                          hintText:
                                                              'Tarif', // You can set the initial text as hintText
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey.shade400,
                                                            fontSize: 16,
                                                            fontFamily: 'Kanit',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 17),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Commmentaire: ',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 16,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.58,
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        child: TextField(
                                                          controller: comment,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Comments',
                                                            hintStyle:
                                                                TextStyle(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Kanit',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 12, top: 15),
                              child: Container(
                                width: 411,
                                height: isOptionsAndCommentVisible2 ? 350 : 250,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color:  Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '20 sept. a 06:30 ',
                                            style: TextStyle(
                                              color: Color(0xFF3954A4),
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity(
                                        vertical: -4,
                                      ),
                                      minLeadingWidth: 0,
                                      leading:
                                          Image.asset('assets/images/hat.png'),
                                      title: Text(
                                        'Lortet Poema',
                                        style: TextStyle(
                                          color:  Color(0xFF524D4D),
                                          fontSize: 18,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () async {
                                            final call =
                                                Uri.parse('tel:+91 9830268966');
                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          },
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                            size: 30,
                                          )),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 93,
                                          decoration: ShapeDecoration(
                                            color:  Color(0xFFEA690C),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(50),
                                                bottomRight:
                                                    Radius.circular(50),
                                              ),
                                            ),
                                          ),
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10, top: 10),
                                                child: Text(
                                                  'On hold',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.w300,
                                                    height: 0.12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.15,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/location3.png'),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      'Colomoers Gare SNCF, Coomiers',
                                                      style: TextStyle(
                                                        color:
                                                             Color(0xFF524D4D),
                                                        fontSize: 14,
                                                        fontFamily: 'Kanit',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
                                                    ),
                                                    Flexible(
                                                      child: IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            Icons.error_outline,
                                                            color: Colors.black,
                                                            size: 30,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      'assets/images/location4.png'),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    'Gare de, Rue Pierre Semard, 09000 Foix',
                                                    style: TextStyle(
                                                      color:  Color(0xFF524D4D),
                                                      fontSize: 14,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          isOptionsAndCommentVisible2 =
                                              !isOptionsAndCommentVisible2;
                                        });
                                      },
                                      minVerticalPadding: 0,
                                      minLeadingWidth: 0,
                                      leading: Image.asset(
                                          'assets/images/arrow.png'),
                                      title: Text(
                                        'Options and Comment :',
                                        style: TextStyle(
                                          color:  Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          bottomSheet4(context);
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Image.asset(
                                                'assets/images/cont.png'),
                                            Positioned(
                                                top: 5,
                                                left: 3,
                                                child: Text(
                                                  'MAXIME Gouk',
                                                  style: TextStyle(
                                                    color: Color(0xFF3954A4),
                                                    fontSize: 14,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                )),
                                            Positioned(
                                              bottom: 3,
                                              left: 9,
                                              child: Container(
                                                width: 95,
                                                height: 26,
                                                decoration: ShapeDecoration(
                                                  color:  Color(0xFFEA690C),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                bottom: 0,
                                                left: 40,
                                                child: Image.asset(
                                                    'assets/images/hand.png'))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isOptionsAndCommentVisible2,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.zero,
                                            width: double.infinity,
                                           // Adjust the height as needed
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Tarif ',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 16,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.euro_symbol_outlined,
                                                    color: Colors.grey.shade400,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Commmentaire: ',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 16,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.58,
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        child: TextField(
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Comments',
                                                            hintStyle:
                                                                TextStyle(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Kanit',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 12, top: 15),
                              child: Container(
                                width: 411,
                                height: 220,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color:  Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '20 sept. a 06:30',
                                            style: TextStyle(
                                              color: Color(0xFF3954A4),
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity(
                                          vertical: -4, horizontal: -4),
                                      minLeadingWidth: 0,
                                      leading: Image.asset(
                                          'assets/images/medkit.png'),
                                      title: Text(
                                        'Gnonkoue Didier',
                                        style: TextStyle(
                                          color:  Color(0xFF524D4D),
                                          fontSize: 18,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () async {
                                            final call =
                                                Uri.parse('tel:+91 9830268966');
                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          },
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                            size: 30,
                                          )),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 93,
                                          decoration: ShapeDecoration(
                                            color:  Color(0xFFEA690C),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(50),
                                                bottomRight:
                                                    Radius.circular(50),
                                              ),
                                            ),
                                          ),
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10, top: 10),
                                                child: Text(
                                                  'On hold',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.w300,
                                                    height: 0.12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.15,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/location3.png'),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      'Colomoers Gare SNCF, Coomiers',
                                                      style: TextStyle(
                                                        color:
                                                             Color(0xFF524D4D),
                                                        fontSize: 14,
                                                        fontFamily: 'Kanit',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
                                                    ),
                                                    Flexible(
                                                      child: IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            Icons.error_outline,
                                                            color: Colors.black,
                                                            size: 30,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      'assets/images/location4.png'),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    'Gare de, Rue Pierre Semard, 09000 Foix',
                                                    style: TextStyle(
                                                      color:  Color(0xFF524D4D),
                                                      fontSize: 14,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: ListTile(
                                        minVerticalPadding: 0,
                                        minLeadingWidth: 0,
                                        leading: Image.asset(
                                            'assets/images/arrow.png'),
                                        title: Text(
                                          'Options and Comment :',
                                          style: TextStyle(
                                            color:  Color(0xFF524D4D),
                                            fontSize: 14,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            bottomSheet4(context);
                                          },
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Image.asset(
                                                  'assets/images/cont.png'),
                                              Positioned(
                                                  top: 5,
                                                  left: 3,
                                                  child: Text(
                                                    'Daniel Union 3',
                                                    style: TextStyle(
                                                      color: Color(0xFF3954A4),
                                                      fontSize: 14,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  )),
                                              Positioned(
                                                bottom: 3,
                                                left: 9,
                                                child: Container(
                                                  width: 95,
                                                  height: 26,
                                                  decoration: ShapeDecoration(
                                                    color:  Color(0xFFEA690C),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 0,
                                                  left: 40,
                                                  child: Image.asset(
                                                      'assets/images/hand.png'))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 90,
                            )
                          ],
                        ): ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        _buildTripCard(),
                        SizedBox(
                          height: 15,
                        ),
                        _buildTripCard2(),
                        SizedBox(
                          height: 15,
                        ),
                        _buildTripCard(),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    ),),
            ),
          )
        ],
      ),
    );
  }
}