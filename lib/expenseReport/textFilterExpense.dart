// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

List<List<Map<String, dynamic>>> subListsTextFilter = [];

GetStorage box = GetStorage();

class TextFilter extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  const TextFilter({super.key, required this.list});

  @override
  State<TextFilter> createState() => _TextFilterState();
}

class _TextFilterState extends State<TextFilter> {
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();

  bool isRefreshed = false;

  @override
  void initState() {
    super.initState();
    print('List from expense page: ${widget.list}');
    _fetchAdminData();
  }

  List<Map<String, dynamic>> expenseList = [];

  Future<void> _fetchAdminData() async {
    setState(() {
      isRefreshed = true;
      subListsTextFilter.clear();
    });
    try {
      subListsTextFilter.clear();
      final List<Map<String, dynamic>> adminData = widget.list;
      setState(() {
        expenseList = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < expenseList.length; i += 10) {
        final endIndex =
            (i + 10 < expenseList.length) ? i + 10 : expenseList.length;
        subListsTextFilter.add(expenseList.sublist(i, endIndex));
      }

      print('Admin data fetched successfully');
      setState(() {
        isRefreshed = false;
      });
    } catch (error) {
      print('Error fetching admin data: $error');
      setState(() {
        isRefreshed = false;
      });
    }
  }

  Future<dynamic> editReport(
      BuildContext context, String titre, double montant) async {
    return showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(
                'Edit Report',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextField(
                      controller: title,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: titre,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: amount,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: montant.toString(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF3954A4),
                        ),
                        child: Text('Edit'),
                        onPressed: () {
                          putExpenseReport();
                          _fetchAdminData();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(
      () => () {
        setState(
          () {
            amount.text = "";
            title.text = "";
            isRefreshed = true;
          },
        );
        // getExpenseReport();
        _fetchAdminData();
        Future.delayed(
          Duration(milliseconds: 500),
          () {
            setState(
              () {
                isRefreshed = false;
              },
            );
          },
        );
      },
    );
  }

  final box = GetStorage();
  Future<void> putExpenseReport() async {
    final _token = box.read('token') ?? '';
    print("token called: $_token");

    final id = box.read('reportId');
    print('Report Id for the edit: $id');

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['compta_baseUrl'];
    final gestionApiKey = configJson['compta_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "note-frais/" + id.toString();

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token,
      'Content-Type': 'application/json'
    };

    var request = http.Request(
      'PUT',
      Uri.parse(gestionMainUrl),
    );
    request.body = json.encode({
      "montant": amount.text,
      "titre": title.text,
      "updatedBy": UserID.toString()
    });
    request.headers.addAll(headers);

    print('Data for the body is: ${amount.text}, ${title.text}, $UserID');

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(
        await response.stream.bytesToString(),
      );
      _fetchAdminData();
      Get.snackbar(
        colorText: Colors.white,
        'Success',
        'Expense Report is Edited Successfully',
        backgroundColor: Color.fromARGB(255, 92, 246, 92),
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        isDismissible: true,
        dismissDirection: DismissDirection.up,
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInCirc,
        duration: const Duration(seconds: 3),
        barBlur: 0,
        messageText: const Text(
          'Expense Report is Edited Successfully',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );
      setState(
        () {
          amount.text = "";
          title.text = "";
        },
      );
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> delExpenseReport() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    print("token called: $_token");

    final id = box.read('reportId');
    print('Report Id for the delete: $id');

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['compta_baseUrl'];
    final gestionApiKey = configJson['compta_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "note-frais/" + id.toString();

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request(
      'DELETE',
      Uri.parse(gestionMainUrl),
    );
    request.body = json.encode({"deletedBy": UserID.toString()});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(
        await response.stream.bytesToString(),
      );
      Get.snackbar(
        colorText: Colors.white,
        'Success',
        'Expense Report is Deleted Successfully',
        backgroundColor: Color.fromARGB(255, 92, 246, 92),
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        isDismissible: true,
        dismissDirection: DismissDirection.up,
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInCirc,
        duration: const Duration(seconds: 3),
        barBlur: 0,
        messageText: const Text(
          'Expense Report is Deleted Successfully',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );
      _fetchAdminData();
    } else {
      print(response.reasonPhrase);
    }
  }

  void showDeleteReportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3.50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 10,
                child: Center(
                  child: Text(
                    'Delete Report',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  delExpenseReport().whenComplete(() {
                    _fetchAdminData();
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.5, color: Colors.black),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
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
              SizedBox(height: 10),
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
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1),
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
    ).whenComplete(
      () => () {
        setState(
          () {
            isRefreshed = true;
          },
        );
        // getExpenseReport();
        _fetchAdminData();
        Future.delayed(
          Duration(milliseconds: 500),
          () {
            setState(
              () {
                isRefreshed = false;
              },
            );
          },
        );
      },
    );
  }

  int currentIndex = 0;
  Future<void> handleRefresh() async {
    setState(() {
      subListsTextFilter.clear();
    });
    _fetchAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LiquidPullToRefresh(
            backgroundColor: Color(0xFF3954A4),
            height: 80,
            animSpeedFactor: 2,
            showChildOpacityTransition: false,
            color: Colors.white,
            onRefresh: handleRefresh,
            child: isRefreshed
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF3954A4)),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: subListsTextFilter.isEmpty
                        ? 0
                        : subListsTextFilter[currentIndex].length,
                    itemBuilder: (BuildContext context, int index) {
                      // Display each item in the sublist as a ListTile
                      final item = subListsTextFilter[currentIndex][index];

                      String date = item['date'];

                      DateTime dateTime = DateTime.parse(date);
                      tz.TZDateTime parisDateTime = tz.TZDateTime.from(
                        dateTime,
                        tz.getLocation('Europe/Paris'),
                      );

                      String formattedDate = DateFormat('dd-MMM-yyyy - HH:mm')
                          .format(parisDateTime);

                      if (subListsTextFilter.length == 0) {
                        Center(
                          child:
                              Text('No Expense Report available currently..!!'),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 8,
                          ),
                          child: Container(
                            width: 391,
                            // height: 100,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(0xFFEBE9E9),
                                ),
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
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ID : ${item['id'].toString()}',
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
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                          height: 0.09,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['amount'].toString(),
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                          height: 0.09,
                                        ),
                                      ),
                                      Container(
                                        width: 60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                box.write(
                                                  'reportId',
                                                  item['id'].toString(),
                                                );
                                                final id = box.read('reportId');
                                                print(
                                                    'Report Id for the edit: $id');

                                                setState(() {
                                                  title.text = item['title'];
                                                  amount.text =
                                                      item['amount'].toString();
                                                });

                                                editReport(
                                                    context,
                                                    item['title'],
                                                    item['amount']);
                                              },
                                              child: Image.asset(
                                                  'assets/images/edit.png'),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                box.write(
                                                  'reportId',
                                                  item['id'].toString(),
                                                );
                                                final id = box.read('reportId');
                                                print(
                                                    'Report Id for the edit: $id');

                                                showDeleteReportBottomSheet(
                                                    context);
                                              },
                                              child: Image.asset(
                                                  'assets/images/delete.png'),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
          ),
        ),
        Container(
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
                          isRefreshed = true;
                        });
                        setState(() {
                          currentIndex--;
                        });
                        Future.delayed(Duration(milliseconds: 500), () {
                          setState(() {
                            isRefreshed = false;
                          });
                        });
                      }
                    : null,
              ),
              Text(
                //  - ${subLists.length}
                '${currentIndex + 1} - ${subListsTextFilter.length}',
                style: TextStyle(fontSize: 18, fontFamily: 'Kanit'),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                onPressed: currentIndex < subListsTextFilter.length - 1
                    ? () {
                        setState(() {
                          isRefreshed = true;
                        });
                        setState(() {
                          currentIndex++;
                        });
                        Future.delayed(Duration(milliseconds: 500), () {
                          setState(() {
                            isRefreshed = false;
                          });
                        });
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
