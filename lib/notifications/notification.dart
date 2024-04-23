// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/Success_page/Notifications/notificaiton_error_page.dart';
// import 'package:fr.innoyadev.mkgodev/homeScreen/homeScreen.dart';
import 'package:fr.innoyadev.mkgodev/tripDetails/tripDetails.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:http/http.dart' as http;
// import 'package:loadmore/loadmore.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<void> handleRefresh() async {
    // loadInitialData();
    setState(() {
      subLists.clear();
    });
    _fetchAdminData();
  }

  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifiactions();
    setState(() {
      subLists.clear();
    });
    currentIndex = 0;
    _fetchAdminData();
  }

  List<Map<String, dynamic>> notificationsList = [];
  List<Map<String, dynamic>> notificationsList2 = [];

  int totalCountFinal = 0;

  Future<List<Map<String, dynamic>>> getNotifiactions() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "notification/" + UserID.toString();

    print('Notifications Url: $gestionMainUrl');

    print('User id: $UserID');

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('GET', Uri.parse(gestionMainUrl));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      print(apiData);
      // print('Chauffeur id for the specific trip: ${apiData['chauffeur']}');

      final totalCount = apiData['totalCount'];

      setState(() {
        totalCountFinal = totalCount;
      });

      List<Map<String, dynamic>> notifications = [];
      for (var courses in apiData['notifications']) {
        int Userid = courses['userId'];
        String role = courses['role'];
        String title = courses['title'];
        String body = courses['body'];
        String courseId = courses['courseId'];
        String timestamp = courses['timestamp'];

        notifications.add({
          'Userid': Userid,
          // 'start': start,
          'role': role,
          'title': title,
          'body': body,
          'courseId': courseId,
          'timestamp': timestamp,
        });
      }

      // print(tripList);
      // box.write('tripList', notifications);
      print('Checking list for chauffeurid: $notifications');
      setState(() {
        // trips = tripList;
        notificationsList = notifications;
      });

      return notifications;
    } else {
      Get.to(() => ErrorNotificaitonScreen(
            notes: 'Unable to Fetch Notifications..!!',
          ));
      print(response.reasonPhrase);
    }
    return [];
  }

  List<List<Map<String, dynamic>>> subLists = [];
  List<List<Map<String, dynamic>>> subLists2 = [];

  int currentIndex = 0;

  Future<void> _fetchAdminData() async {
    setState(() {
      isloading = true;
      // subLists.clear();
    });
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData = await getNotifiactions();
      setState(() {
        notificationsList = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < notificationsList.length; i += 10) {
        final endIndex = (i + 10 < notificationsList.length)
            ? i + 10
            : notificationsList.length;
        subLists.add(notificationsList.sublist(i, endIndex));
      }

      print('Admin data fetched successfully');
      setState(() {
        isloading = false;
      });
    } catch (error) {
      print('Error fetching admin data: $error');

      setState(() {
        isloading = false;
      });
    }
  }

  void loadInitialData() {
    print('loadmoredata fucntion is calling');

    setState(() {
      notificationsList = notificationsList.toList();
    });
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 100));
    getNotifiactions();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // SizedBox(
          //   height: MediaQuery.of(context).size.height / 25,
          // ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF3954A4),
                          size: 30,
                        )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      color: Color(0xFF3954A4),
                      fontSize: 20,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      height: 0,
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
          Expanded(
              child: LiquidPullToRefresh(
            backgroundColor: Color(0xFF3954A4),
            height: 80,
            animSpeedFactor: 2,
            showChildOpacityTransition: false,
            color: Colors.white60,
            onRefresh: handleRefresh,
            child: isloading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF3954A4),
                    ),
                  )
                : (notificationsList.isEmpty)
                    ? ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 150,
                                width: 200,
                                child: Image.asset(
                                    'assets/images/no-icons/no-notifications.png'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No Notification Available",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    : ListView.builder(
                        itemCount: subLists.isEmpty
                            ? 0
                            : subLists[currentIndex].length,
                        itemBuilder: (BuildContext context, int index) {
                          // Display each item in the sublist as a ListTile
                          final item = subLists[currentIndex][index];

                          String date = item['timestamp'];

                          DateTime dateTime = DateTime.parse(date);
                          tz.TZDateTime parisDateTime = tz.TZDateTime.from(
                              dateTime, tz.getLocation('Europe/Paris'));

                          String formattedDate = DateFormat('dd.MMM.yyyy HH:mm')
                              .format(parisDateTime);
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => TripDetails(id: item['courseId']),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8),
                              child: Container(
                                width: 391,
                                height: 78,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xFFEBE9E9)),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x11000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['title'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                              height: 0.05,
                                            ),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              color: Color(0xFF524D4D),
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            '[1] ${item['body']}',
                                            style: TextStyle(
                                              color: Color(0xFF524D4D),
                                              fontSize: 14,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w300,
                                              height: 0.05,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          )),
          (notificationsList.isEmpty)
              ? SizedBox()
              : Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        ),
                        onPressed: currentIndex > 0
                            ? () {
                                setState(() {
                                  isloading = true;
                                });
                                setState(() {
                                  currentIndex--;
                                });
                                Future.delayed(Duration(milliseconds: 500), () {
                                  setState(() {
                                    isloading = false;
                                  });
                                });
                              }
                            : null,
                      ),
                      Text(
                        //  - ${subLists.length}
                        '${currentIndex + 1} - ${subLists.length}',
                        style: TextStyle(fontSize: 18, fontFamily: 'Kanit'),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                        onPressed: currentIndex < subLists.length - 1
                            ? () {
                                setState(() {
                                  isloading = true;
                                });
                                setState(() {
                                  currentIndex++;
                                });
                                Future.delayed(Duration(milliseconds: 500), () {
                                  setState(() {
                                    isloading = false;
                                  });
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
