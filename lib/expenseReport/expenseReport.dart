// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/expenseReport/dateFilterList.dart';
import 'package:fr.innoyadev.mkgodev/expenseReport/expenseList.dart';
import 'package:fr.innoyadev.mkgodev/expenseReport/textFilterExpense.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:fr.innoyadev.mkgodev/homeScreen/AdminPlanning.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:fr.innoyadev.mkgodev/download/download.dart';
import 'package:http/http.dart' as http;
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:timezone/timezone.dart' as tz;

GetStorage box = GetStorage();

class ExpenseReport extends StatefulWidget {
  const ExpenseReport({super.key});

  @override
  State<ExpenseReport> createState() => _ExpenseReportState();
}

class _ExpenseReportState extends State<ExpenseReport> {
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();
  List<List<Map<String, dynamic>>> subLists = [];
  List<List<Map<String, dynamic>>> subListsFilter = [];

  @override
  void initState() {
    super.initState();

    // getExpenseReport();
    setState(() {
      subLists.clear();
      subListsExpense.clear();
      subListsDateFilter.clear();
      subListsTextFilter.clear();
      dateSelected = false;
    });
    currentIndex = 0;
    _fetchAdminData();
  }

  int currentIndex = 0;

  Future<void> _fetchAdminData() async {
    setState(() {
      isRefreshed = true;
      subLists.clear();
    });
    try {
      subLists.clear();
      final List<Map<String, dynamic>> adminData = await getExpenseReport();
      setState(() {
        expenseList = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < expenseList.length; i += 10) {
        final endIndex =
            (i + 10 < expenseList.length) ? i + 10 : expenseList.length;
        subLists.add(expenseList.sublist(i, endIndex));
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

  // List<Map<String, dynamic>> expenseList = [];

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

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  DateTime? pickedStartDate;
  DateTime? pickedEndDate;
  DateTime? startDate;
  DateTime? endDate;
  bool dateSelected = false;

  String finaldate = "";
  String finalEndDate = "";

  void pickDate() async {
    setState(() {
      isRefreshed = true;
      finaldate = "";
      finalEndDate = "";
      print('Dates in date range selecter: $finaldate, $finalEndDate');
    });
    pickedStartDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (pickedStartDate != null ) {
      Get.snackbar('End Date not selected', "Select End Date",
          backgroundColor: Color.fromARGB(255, 81, 116, 221));
      pickedEndDate = await showDatePicker(
        context: context,
        initialDate: pickedStartDate!,
        firstDate: pickedStartDate!,
        lastDate: DateTime(2100),
      );
    }

    if (pickedStartDate != null && pickedEndDate != null) {
      String startDateString =
          DateFormat('yyyy-MM-dd').format(pickedStartDate!);
      String endDateString = DateFormat('yyyy-MM-dd').format(pickedEndDate!);
      print('Selected date range: $pickedStartDate to $pickedEndDate');

      setState(() {
        finaldate = startDateString;
        finalEndDate = endDateString;
      });

      dateRangeFilter();

      setState(() {
        startDate = pickedStartDate;
        endDate = pickedEndDate;
        isRefreshed = false;
        // dateSelected = true;
        print('Dates after setting state: $finaldate, $finalEndDate');
      });
    } else if (pickedStartDate != null) {
      print('Selected single date: $pickedStartDate');
      setState(() {
        startDate = pickedStartDate;
        endDate = null;
        isRefreshed = false;
        // dateSelected = true;
      });
    } else {
      setState(() {
        isRefreshed = false;
      });
    }
  }

  List<Map<String, dynamic>> dateRangeFilterList = [];

  Future<void> dateRangeFilter() async {
    setState(() {
      print('Inside filter fucntion');
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
      'x-api-key': "$gestionApiKey",
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse(gestionMainUrl));
    request.body = json.encode({"from": finaldate, "to": finalEndDate});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);
      print('Data: $apiData');

      final totalCount = apiData['totalCount'];

      List<Map<String, dynamic>> filteredList = [];
      if (apiData['collections'] != null) {
        for (var collections in apiData['collections']) {
          int id = collections['id'] ?? 0;
          String title = collections['titre'] ?? '';
          double amount = collections['montant']?.toDouble() ?? 0.0;
          String updatedDate = collections['createdAt'] ?? '';
          filteredList.add({
            'totalCount': totalCount,
            'id': id,
            'title': title,
            'date': updatedDate,
            'amount': amount
          });
        }
        setState(() {
          dateRangeFilterList = filteredList;
          dateSelected = true;
        });
        print('List for date filter page: $dateRangeFilterList');
      } else {
        print('Collections data is null');
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> singleDateFilter() async {
    setState(() {
      print('Inside filter fucntion');
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
      'x-api-key': "$gestionApiKey",
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse(gestionMainUrl));
    request.body = json.encode({"date": singleDate});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);
      print('Data: $apiData');

      final totalCount = apiData['totalCount'];

      List<Map<String, dynamic>> filteredList = [];
      if (apiData['collections'] != null) {
        for (var collections in apiData['collections']) {
          int id = collections['id'] ?? 0;
          String title = collections['titre'] ?? '';
          double amount = collections['montant']?.toDouble() ?? 0.0;
          String updatedDate = collections['createdAt'] ?? '';
          filteredList.add({
            'totalCount': totalCount,
            'id': id,
            'title': title,
            'date': updatedDate,
            'amount': amount
          });
        }
        setState(() {
          dateRangeFilterList = filteredList;
          dateSelected = true;
          isRefreshed = false;
        });
        print('List for date filter page: $dateRangeFilterList');
      } else {
        print('Collections data is null');
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  String singleDate = "";

  List<Map<String, dynamic>> filteredList = [];
  @override
  Widget build(BuildContext context) {
    // List<dynamic> expenseList = box.read('expenseList');
    // DateTime? selectedDate;
    // bool dateSelected = false;

    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Profile()));

          // Return true to allow popping the current screen
          return true;
        },
        child: Material(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            Get.to(() => Profile());
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color(0xFF3954A4),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        'Note des frais',
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
                Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 70,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => Download(),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.green.shade300,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by title...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF3954A4),
                            ),
                          ),
                          // onTap: ,
                          onChanged: (value) {
                            setState(() {
                              filteredList.clear();
                              filteredList = dateSelected
                                  ? dateRangeFilterList
                                      .where((item) => item["title"]
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList()
                                  : expenseList
                                      .where((item) => item["title"]
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();

                              print('Filtered List: $filteredList');
                            });
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: Color(0xFF3954A4),
                      ),
                      onPressed: () async {
                        pickDate();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF3954A4),
                      ),
                      onPressed: () async {
                        setState(() {
                          isRefreshed = true;
                        });
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          print('Selected date: $pickedDate');
                          setState(() {
                            singleDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate!);
                          });
                          singleDateFilter();
                          
                        }
                      },
                    ),
                    Visibility(
                      visible: dateSelected || searchController.text.isNotEmpty,
                      child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Color(0xFF3954A4),
                        ),
                        onPressed: () {
                          setState(() {
                            dateSelected = false;
                            // selectedDate = null;
                            dateSelected = false;
                            subListsFilter.clear();
                            searchController.clear();
                            searchController.text == "";
                            subListsDateFilter.clear();
                            subListsExpense.clear();
                            subListsTextFilter.clear();
                            print('Filteerd Ranged List: $subListsDateFilter');
                            print('Filteerd Single List: $subListsExpense');
                            print('Filteerd text List: $subListsTextFilter');
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: isRefreshed
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF3954A4),
                          ),
                        )
                      : (searchController.text.isNotEmpty)
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredList.length,
                              itemBuilder: (BuildContext context, int index) {
                                // Display each item in the sublist as a ListTile
                                final item = filteredList[index];

                                String date = item['date'];

                                DateTime dateTime = DateTime.parse(date);
                                tz.TZDateTime parisDateTime =
                                    tz.TZDateTime.from(
                                  dateTime,
                                  tz.getLocation('Europe/Paris'),
                                );

                                String formattedDate =
                                    DateFormat('dd-MMM-yyyy - HH:mm')
                                        .format(parisDateTime);
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        box.write(
                                                          'reportId',
                                                          item['id'].toString(),
                                                        );
                                                        final id = box
                                                            .read('reportId');
                                                        print(
                                                            'Report Id for the edit: $id');

                                                        setState(() {
                                                          title.text =
                                                              item['title'];
                                                          amount.text =
                                                              item['amount']
                                                                  .toString();
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
                                                        final id = box
                                                            .read('reportId');
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
                              })
                          : dateSelected
                              ? isRefreshed
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: Color(0xFF3954A4)),
                                    )
                                  : DateFilter(list: dateRangeFilterList)
                              : ExpenseList(),
                )
              ],
            ),
          ),
        ));
  }
}
