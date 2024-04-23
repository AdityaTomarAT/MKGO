// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_is_empty, avoid_print, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, sized_box_for_whitespace, deprecated_member_use, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

// List<List<Map<String, dynamic>>> subListsDateFilter = [];
  List<List<Map<String, dynamic>>> subListsExpense = [];
  List<Map<String, dynamic>> expenseList = [];



GetStorage box = GetStorage();

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key,});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();
  List<List<Map<String, dynamic>>> subListsFilter = [];

  @override
  void initState() {
    super.initState();

    // getExpenseReport();
    setState(() {
      subListsExpense.clear();
    });
    currentIndex = 0;
    _fetchAdminData();
  }

  int currentIndex = 0;

  Future<void> _fetchAdminData() async {
    setState(() {
      isRefreshed = true;
      subListsExpense.clear();
    });
    try {
      subListsExpense.clear();
      final List<Map<String, dynamic>> adminData = await getExpenseReport();
      setState(() {
        expenseList = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < expenseList.length; i += 10) {
        final endIndex =
            (i + 10 < expenseList.length) ? i + 10 : expenseList.length;
        subListsExpense.add(expenseList.sublist(i, endIndex));
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
        getExpenseReport();
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
        getExpenseReport();
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

  Future<List<Map<String, dynamic>>> getExpenseReport() async {
    setState(() {
      isRefreshed = true;
    });
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['compta_baseUrl'];
    final gestionApiKey = configJson['compta_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "note-frais/search/" + UserID.toString();

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request(
      'GET',
      Uri.parse(gestionMainUrl),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      print('Expense Reports from the API :$apiData');

      final totalCount = apiData['totalCount'];

      List<Map<String, dynamic>> expenseReport = [];
      if (apiData['collections'] != null) {
        for (var collections in apiData['collections']) {
          int id = collections['id'] ?? 0;
          String title = collections['titre'] ?? '';
          double amount = collections['montant']?.toDouble() ?? 0.0;
          String updatedDate = collections['createdAt'] ?? '';
          expenseReport.add({
            'totalCount': totalCount,
            'id': id,
            'title': title,
            'date': updatedDate,
            'amount': amount
          });
        }
      } else {
        print('Collections data is null');
      }

      print('List of expense report after populating the data: $expenseReport');
      box.write('expenseList', expenseReport);

      setState(() {
        expenseList = expenseReport;
      });

      setState(() {
        isRefreshed = false;
      });
      return expenseReport;
    } else {
      print(response.reasonPhrase);
      setState(() {
        isRefreshed = false;
      });
      Get.snackbar(
        colorText: Colors.white,
        'Error in Fetching',
        '',
        backgroundColor: const Color.fromARGB(255, 244, 114, 105),
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
          'Could Not fetch Expense Reports',
          style: TextStyle(
              color: Colors.white, fontSize: 16.0, fontFamily: "Kanit"),
        ),
      );
    }
    return expenseList;
  }

  bool isRefreshed = false;

  Future<void> handleRefresh() async {
    setState(() {
      isRefreshed = true;
    });
    await Future.delayed(
      Duration(milliseconds: 500),
      () {
        _fetchAdminData();
        List<dynamic> expenseList = box.read('expenseList');
        setState(
          () {
            expenseList = expenseList.toList();
            isRefreshed = false;
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> filterListByTitle(
      String query, List<Map<String, dynamic>> originalList) {
    List<Map<String, dynamic>> filteredList = [];

    // Filtering logic
    for (var item in originalList) {
      if (item['title'].toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(item);
      }
    }
    return filteredList;
  }

  TextEditingController searchController = TextEditingController();

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
                    itemCount: subListsExpense.isEmpty
                        ? 0
                        : subListsExpense[currentIndex].length,
                    itemBuilder: (BuildContext context, int index) {
                      // Display each item in the sublist as a ListTile
                      final item = subListsExpense[currentIndex][index];

                      String date = item['date'];

                      DateTime dateTime = DateTime.parse(date);
                      tz.TZDateTime parisDateTime = tz.TZDateTime.from(
                        dateTime,
                        tz.getLocation('Europe/Paris'),
                      );

                      String formattedDate = DateFormat('dd-MMM-yyyy - HH:mm')
                          .format(parisDateTime);

                      if (subListsExpense.length == 0) {
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
                '${currentIndex + 1} - ${subListsExpense.length}',
                style: TextStyle(fontSize: 18, fontFamily: 'Kanit'),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                onPressed: currentIndex < subListsExpense.length - 1
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
