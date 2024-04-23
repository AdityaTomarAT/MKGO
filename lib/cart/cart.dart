// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print, unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/lists/admin/adminFilterListFuture.dart';
import 'package:fr.innoyadev.mkgodev/lists/admin/adminFilterListToday.dart';
import 'package:fr.innoyadev.mkgodev/lists/admin/futureAdmin.dart';
import 'package:fr.innoyadev.mkgodev/lists/admin/today.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:fr.innoyadev.mkgodev/Utility/bottomSheet.dart';
import 'package:fr.innoyadev.mkgodev/login/loginModel.dart';
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;



bool isToday = false;
bool isFuture = false;
String today = "";
String future = "";

bool isOptionsAndCommentVisible2 = false;

Color todayContainerColor = Colors.white;
Color futureContainerColor = Colors.white;

GetStorage box = GetStorage();

List<Map<String, dynamic>> AdminListFilter = [];
List<List<Map<String, dynamic>>> appAdminToday = [];
List<List<Map<String, dynamic>>> appAdminFuture = [];

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _PlanningState();
}

class _PlanningState extends State<Cart> {

      

  TextEditingController comment = TextEditingController();
  TextEditingController reassign = TextEditingController();

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

  Color todayColor = Colors.black;
  Color avenirColor = Colors.black;

  void _changeTodayContainerColor() {
    setState(() {
      isRefreshed = true;
    });

    TripListToday();
    if (isFiltered) {
      _fetchAdminDataToday();
    }

    setState(() {
      today = "today";
      future = "";
      isToday = true;
      isFuture = false;
      todayContainerColor = Color(0xFFFFB040);
      futureContainerColor = Colors.white;
      print('Passe/avenir/today: $today');
      todayColor = Colors.white;
      avenirColor = Colors.black;
    });
    setState(() {
      isRefreshed = false;
    });
  }

  void _changeFutureContainerColor() {
    setState(() {
      isRefreshed = true;
    });
    if (isFiltered) {
      _fetchAdminDataFuture();
    }

    TripListFutureAdmin();
    setState(() {
      future = "avenir";
      today = "";
      isToday = false;
      isFuture = true;
      futureContainerColor = Color(0xFFFFB040);
      todayContainerColor = Colors.white;
      print('Passe/avenir/today: $future');
      avenirColor = Colors.white;
      todayColor = Colors.black;
    });
    setState(() {
      isRefreshed = false;
    });
  }

  Future<void> handleRefresh() async {
    loadInitialData();
    TripListFutureAdmin();
    TripListToday();
    setState(() {
      isRefreshed = true;
    });
    await Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isRefreshed = false;
      });
    });
  }

  void loadInitialData() {
    print('loadmoredata fucntion is calling');

    TripListFutureAdmin();
    TripListToday();
  }

  void filterInitialdata() {
    print('loadmoredata fucntion is calling in filter sheet');

    AdminListFilter = box.read('finalfilteredList');

    print('Past Trips in loadmore : $AdminListFilter');

    setState(() {
      AdminListFilter = AdminListFilter.toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clear();
    setState(() {
      today = "today";
      future = "";
      isToday = true;
      isFuture = false;
      todayContainerColor = Color(0xFFFFB040);
      futureContainerColor = Colors.white;
      print('Passe/avenir/today: $today');
      todayColor = Colors.white;
    });
    setState(() {
      regionNameBox = "REGION";
      driverNameBox = "DRIVER";
      typeNameBox = "TYPE";
      clientNameBox = "CLIENT";
    });
    loadInitialData();
    todayContainerColor = Color(0xFFFFB040);
    futureContainerColor = Colors.white;

    setState(() {
      isToday = true;
    });
    setState(() {
      isRefreshed = true;
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        isRefreshed = false;
      });
    });

    setState(() {
      appAdminToday.clear();
    });
    // _fetchAdminData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    regionList();
    loadInitialData();
    typeList();
    print('today list is printing here');
    TripListToday();
    print('today list is ending here');
    TripListFutureAdmin();
  }

  bool hasInternetConnection() {
    var connectivityResult = Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.none;
  }

  Future<void> submitForm() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showNoInternetError();
    } else {}
  }

  void showNoInternetError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Color(0xFFE6F7FD),
          title: Text("No Internet Connection"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please connect to the internet and try again."),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF3954A4),
                    minimumSize: Size(200, 40),
                  ),
                  onPressed: () {
                    Get.offAll(() => false);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isRefreshed = false;
  bool isTodayFiltered = false;
  bool isFutureFiltered = false;

  List<dynamic> Region = [];

  Future<List<Map<String, dynamic>>> regionList() async {
    List<Map<String, dynamic>>? suggestions = [];
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    print("token called: $_token");

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "api/get/region";

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

      if (apiData.containsKey("collections")) {
        final List<dynamic> regionData = apiData["collections"];
        List<Map<String, dynamic>> regions = regionData.map((item) {
          return {
            "id": item["id"].toString(),
            "libelle": item["libelle"].toString(),
          };
        }).toList();

        box.write('regions', regions);
        return regions;
      } else {
        print("API response does not contain 'collections'");
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> typeList() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "api/liste/type/client";

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

      if (apiData.containsKey("collections")) {
        final List<dynamic> typeData = apiData["collections"];
        List<Map<String, dynamic>> type = typeData.map((item) {
          return {
            "id": item["id"].toString(),
            "libelle": item["libelle"].toString(),
          };
        }).toList();
        box.write('type', type);
        return type;
      } else {}
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> DriverList() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final regionId = box.read('regionId');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "api/liste/chauffeur/active/" + regionId.toString();

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

      List<Map<String, dynamic>> driverList = [];
      for (var driver in apiData['collections']) {
        int id = driver['id'];
        String nom = driver['nom'];
        String prenom = driver['prenom'];
        driverList.add({'id': id, 'nom': nom, 'prenom': prenom});
      }

      print(' Driver List With Id $driverList');
      box.write('driver', driverList);

      return driverList;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  // List<Map<String, dynamic>> driverList3 = [];

  Future<List<Map<String, dynamic>>> DriverList2() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    String regionId2 = box.read('regionId3').toString();

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "api/liste/chauffeur/active/" + regionId2.toString();

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

      List<Map<String, dynamic>> driverList = [];
      for (var driver in apiData['collections']) {
        int id = driver['id'];
        String nom = driver['nom'];
        String prenom = driver['prenom'];
        driverList.add({'id': id, 'nom': nom, 'prenom': prenom});
      }
      box.write('driver2', driverList);

      return driverList;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> ClientList() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final regionId = box.read('regionId');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "api/liste-clients-active/" + regionId.toString();

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

      List<Map<String, dynamic>> clientList = [];
      for (var client in apiData['collections']) {
        int id = client['id'];
        String nom = client['nom'];
        String prenom = client['prenom'];
        clientList.add({'id': id, 'nom': nom, 'prenom': prenom});
      }

      print('Clietn List with id: $clientList');
      box.write('client', clientList);

      return clientList;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> returnRide() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final courseId = box.read('courseId');

    final storage = GetStorage();
    final userId = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "api/affectation/course/" + courseId.toString();

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode(
        {"chauffeur": userId.toString(), "motifAnnulation": reassign.text});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      Get.snackbar(
        colorText: Colors.white,
        'Success',
        'Ride is Returned',
        backgroundColor: Color.fromARGB(255, 8, 213, 59),
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
          'Ride is Returned',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );

      Navigator.of(context).pop();
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> returnRide2() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final courseId = box.read('courseId2');

    print("courseId conditionally called in function : $courseId");

    final storage = GetStorage();
    final userId = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "api/affectation/course/" + courseId.toString();

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode(
        {"chauffeur": userId.toString(), "motifAnnulation": reassign.text});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      Get.snackbar(
        colorText: Colors.white,
        'Success',
        'Ride is Returned',
        backgroundColor: Color.fromARGB(255, 8, 213, 59),
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
          'Ride is Returned',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );

      Navigator.of(context).pop();
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  String regionNameBox = box.read('regionNameAdmin') ?? 'REGION';
  String typeNameBox = box.read('typeNameAdmin') ?? 'TYPE';
  String clientNameBox = box.read('clientNameAdmin') ?? 'CLIENT';
  String driverNameBox = box.read('driverNameAdmin') ?? 'DRIVER';

  void clear() {
    // resetValues();
    setState(() {
      box.remove('finalfilteredList');
      box.remove('regionNameAdmin');
      box.remove('driverNameAdmin');
      box.remove('clientNameAdmin');
      box.remove('typeNameAdmin');
      box.remove('typeId');
      box.remove('regionId');
      box.remove('driverId');
      box.remove('clientId');
      print('Region: $regionNameBox');
      print('Driver: $driverNameBox');
      print('Client: $clientNameBox');
      print('Type: $typeNameBox');
      AdminListFilter.clear();
      regionNameBox = "REGION";
      typeNameBox = "TYPE";
      clientNameBox = "CLIENT";
      driverNameBox = "DRIVER";
      AdminListFilter.clear();
      print('Region: $regionNameBox');
      print('Driver: $driverNameBox');
      print('Client: $clientNameBox');
      print('Type: $typeNameBox');
      box.remove('finalfilteredList');
      print('Filtered List: $AdminListFilter');
    });
    AdminListFilter.clear();
    AdminListFilter.clear();
  }

  Future<dynamic> adminFilterBottomSheet(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final currentheight = MediaQuery.of(context).size.height;
    final currentidht = MediaQuery.of(context).size.width;

    // String selectedRegion = '';
    final ValueNotifier<String> selectedRegionNotifier =
        ValueNotifier<String>("REGION");
    final ValueNotifier<String> selectedTypeNotifier =
        ValueNotifier<String>("TYPE");
    final ValueNotifier<String> selectedDriverNotifier =
        ValueNotifier<String>("DRIVER");
    final ValueNotifier<String> selectedClientNotifier =
        ValueNotifier<String>("CLIENT");

    void resetValues() {
      AdminListFilter.clear();
      selectedRegionNotifier.value = "REGION";
      selectedTypeNotifier.value = "TYPE";
      selectedDriverNotifier.value = "DRIVER";
      selectedClientNotifier.value = "CLIENT";
      AdminListFilter.clear();
    }

    bool _isRegionSelected = false;
    bool _isTypeSelected = false;
    bool _isDriverSelected = false;
    bool _isClientSelected = false;

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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                print("Device Height: $currentheight");
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: currentheight <= 616 ? MediaQuery.of(context).size.height / 1.30:  MediaQuery.of(context).size.height / 1.60,
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 45,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ' Filter the race here ',
                              style: TextStyle(
                                color: Color(0xFF524D4D),
                                fontSize: 20,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 85,
                        ),
                        Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 25),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor: Color(0xFFE6F7FD),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(38),
                                    ),
                                  ),
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (BuildContext context, index) {
                                      final box = GetStorage();
                                      List<dynamic> region =
                                          (box.read('regions') ?? []);
                                      print(
                                          "Region LIst in the Bottomsheet: $region");

                                      List<dynamic> filteredRegion =
                                          List.from(region);
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.5,
                                            child: Center(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              25,
                                                    ),
                                                    Divider(
                                                      thickness: 0.5,
                                                      color: Colors.grey,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 54,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: TextFormField(
                                                            onChanged: (text) {
                                                              setState(() {
                                                                print(
                                                                    'Search text: $text');
                                                                filteredRegion = region
                                                                    .where((item) => item[
                                                                            "libelle"]
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            text.toLowerCase()))
                                                                    .toList();
                                                                print(
                                                                    'Filtered List in the form field setstate: $filteredRegion');
                                                              });
                                                            },
                                                            controller:
                                                                searchController1,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'Search',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .search,
                                                                      color: Colors
                                                                          .black,
                                                                    )),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            region.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              region[index];
                                                          final String
                                                              regionName =
                                                              item["libelle"];
                                                          final bool
                                                              isSelected =
                                                              regionNameBox ==
                                                                  regionName;

                                                          final bool
                                                              shouldDisplay =
                                                              regionName
                                                                  .toLowerCase()
                                                                  .contains(
                                                                    searchController1
                                                                        .text
                                                                        .toLowerCase(),
                                                                  );

                                                          return shouldDisplay
                                                              ? Center(
                                                                  child:
                                                                      ListTile(
                                                                    onTap:
                                                                        () async {
                                                                      selectedRegionNotifier
                                                                              .value =
                                                                          regionName;
                                                                      _isRegionSelected =
                                                                          true;
                                                                      box.write(
                                                                          'regionNameAdmin',
                                                                          regionName);
                                                                      setState(
                                                                          () {
                                                                        regionNameBox =
                                                                            box.read('regionNameAdmin');
                                                                      });
                                                                      print(
                                                                          'Region Name using RegionNameBox: $regionNameBox');
                                                                      int Id = int
                                                                          .parse(
                                                                              item["id"]);
                                                                      box.write(
                                                                          'regionId',
                                                                          Id);
                                                                      final idregion =
                                                                          box.read(
                                                                              'regionId');
                                                                      print(
                                                                          'id in storage for api: $idregion');
                                                                      Get.dialog(
                                                                          Center(
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              color: Color(0xFF3954A4),
                                                                            ),
                                                                          ),
                                                                          barrierDismissible: false);
                                                                      await DriverList();
                                                                      await ClientList();
                                                                      Get.back();
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    title: Text(
                                                                        regionName),
                                                                    trailing: isSelected
                                                                        ? Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                Colors.blue,
                                                                          )
                                                                        : null,
                                                                  ),
                                                                )
                                                              : SizedBox
                                                                  .shrink();
                                                        },
                                                      ),
                                                    ),
                                                  ]),
                                            )),
                                      );
                                    });
                                  });
                            },
                            child: Container(
                              width: 280,
                              height: 45,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 20),
                                      if (regionNameBox != "REGION")
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isFutureFiltered = false;
                                                isTodayFiltered = false;
                                                selectedRegionNotifier.value ==
                                                    "REGION";

                                                final region =
                                                    box.read('regionName') ??
                                                        "Null hai value";
                                                appAdminToday.clear();

                                                print('Region: $region');

                                                box.remove('regionNameAdmin');
                                                box.remove('regionId');
                                                regionNameBox = "REGION";
                                                box.remove('finalfilteredList');
                                                box.remove('regionNameAdmin');
                                                box.remove('driverNameAdmin');
                                                box.remove('clientNameAdmin');
                                                box.remove('typeNameAdmin');
                                                box.remove('typeId');
                                                box.remove('regionId');
                                                box.remove('driverId');
                                                box.remove('clientId');
                                                print('Region: $regionNameBox');
                                                print('Driver: $driverNameBox');
                                                print('Client: $clientNameBox');
                                                print('Type: $typeNameBox');
                                                AdminListFilter.clear();
                                                appAdminToday.clear();
                                                regionNameBox = "REGION";
                                                typeNameBox = "TYPE";
                                                clientNameBox = "CLIENT";
                                                driverNameBox = "DRIVER";
                                                AdminListFilter.clear();
                                                print('Region: $regionNameBox');
                                                print('Driver: $driverNameBox');
                                                print('Client: $clientNameBox');
                                                print('Type: $typeNameBox');
                                                box.remove('finalfilteredList');
                                              });
                                            },
                                            child: Image.asset(
                                              'assets/images/cross2.png',
                                              color: Colors.red,
                                              scale: 1.5,
                                            )),
                                      SizedBox(width: 30),
                                      Text(
                                        regionNameBox,
                                        style: TextStyle(
                                          color: regionNameBox != "REGION"
                                              ? Colors.blue
                                              : Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(width: 30),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
                          child: GestureDetector(
                            onTap: () {
                              if (regionNameBox != "REGION" &&
                                  selectedClientNotifier.value != "REGION") {
                                showModalBottomSheet(
                                    backgroundColor: Color(0xFFE6F7FD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(38),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context, index) {
                                        final box = GetStorage();
                                        List<dynamic> type =
                                            (box.read('type') ?? []);
                                        print(
                                            "Type LIst in the Bottomsheet: $type");
                                        List<dynamic> filteredType =
                                            List.from(type);

                                        void clearTextField() {
                                          searchController2.text = "";
                                        }

                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  1.5,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              25,
                                                    ),
                                                    Divider(
                                                      thickness: 0.5,
                                                      color: Colors.grey,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 54,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: TextFormField(
                                                            onChanged: (text) {
                                                              setState(() {
                                                                print(
                                                                    'Search text: $text');
                                                                filteredType = type
                                                                    .where((item) => item[
                                                                            "libelle"]
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            text.toLowerCase()))
                                                                    .toList();
                                                                print(
                                                                    'Filtered List in the form field setstate: $filteredType');
                                                              });
                                                            },
                                                            controller:
                                                                searchController2,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'Search',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .search,
                                                                      color: Colors
                                                                          .black,
                                                                    )),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount: type.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              type[index];
                                                          final String
                                                              typeName =
                                                              item["libelle"];
                                                          final bool
                                                              isSelected =
                                                              typeNameBox ==
                                                                  typeName;
                                                          final bool
                                                              shouldDisplay =
                                                              typeName
                                                                  .toLowerCase()
                                                                  .contains(
                                                                    searchController2
                                                                        .text
                                                                        .toLowerCase(),
                                                                  );
                                                          return shouldDisplay
                                                              ? Center(
                                                                  child: ListTile(
                                                                      onTap: () {
                                                                        box.write(
                                                                            'typeNameAdmin',
                                                                            typeName);
                                                                        setState(
                                                                            () {
                                                                          typeNameBox =
                                                                              box.read('typeNameAdmin');
                                                                        });

                                                                        selectedTypeNotifier.value =
                                                                            typeName;
                                                                        int Id =
                                                                            int.parse(item["id"]);
                                                                        box.write(
                                                                            'typeId',
                                                                            Id);
                                                                        final idType =
                                                                            box.read('typeId');
                                                                        print(
                                                                            ' Type id in storage for api: $idType');
                                                                        DriverList();
                                                                        ClientList();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      title: Text(typeName),
                                                                      trailing: isSelected
                                                                          ? Icon(
                                                                              Icons.check,
                                                                              color: Colors.blue,
                                                                            )
                                                                          : null),
                                                                )
                                                              : SizedBox
                                                                  .shrink();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        );
                                      });
                                    });
                              } else {
                                null;
                              }
                            },
                            child: Container(
                              width: 280,
                              height: 45,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 20),
                                    if (typeNameBox != "TYPE")
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedTypeNotifier.value ==
                                                  "TYPE";

                                              final type =
                                                  box.read('typeName') ??
                                                      "Null hai value";

                                              print('Type: $type');

                                              box.remove('typeNameAdmin');
                                              box.remove('typeId');
                                              typeNameBox = "TYPE";
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/images/cross2.png',
                                            color: Colors.red,
                                            scale: 1.5,
                                          )),
                                    SizedBox(width: 30),
                                    Text(
                                      typeNameBox,
                                      style: TextStyle(
                                        color: typeNameBox != "TYPE"
                                            ? Colors.blue
                                            : Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(width: 30),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
                          child: GestureDetector(
                            onTap: () {
                              if (regionNameBox != "REGION" &&
                                  selectedClientNotifier.value != "REGION") {
                                showModalBottomSheet(
                                    backgroundColor: Color(0xFFE6F7FD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(38),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context, index) {
                                        final box = GetStorage();
                                        List<dynamic> allDrivers =
                                            (box.read('driver') ?? []);

                                        List<dynamic> filteredDrivers =
                                            List.from(allDrivers);
                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  1.5,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              25,
                                                    ),
                                                    Divider(
                                                      thickness: 0.5,
                                                      color: Colors.grey,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 54,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: TextFormField(
                                                            onChanged: (text) {
                                                              setState(() {
                                                                if (text
                                                                    .isEmpty) {
                                                                  filteredDrivers =
                                                                      List.from(
                                                                          allDrivers);
                                                                } else {
                                                                  filteredDrivers = allDrivers
                                                                      .where((item) =>
                                                                          item["nom"].toLowerCase().contains(text
                                                                              .toLowerCase()) ||
                                                                          item["prenom"]
                                                                              .toLowerCase()
                                                                              .contains(text.toLowerCase()))
                                                                      .toList();
                                                                }
                                                              });
                                                            },
                                                            controller:
                                                                searchController3,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'Search',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .search,
                                                                      color: Colors
                                                                          .black,
                                                                    )),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child:
                                                            allDrivers.isEmpty
                                                                ? Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            200,
                                                                        child: Image.asset(
                                                                            'assets/images/no-icons/no-drivers.png'),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                        'No Drivers available for this region..!!',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          height:
                                                                              0,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              20)
                                                                    ],
                                                                  )
                                                                : ListView
                                                                    .builder(
                                                                    itemCount:
                                                                        filteredDrivers
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      if (filteredDrivers
                                                                          .isEmpty) {
                                                                        return Center(
                                                                          child:
                                                                              Text(
                                                                            'No Drivers available',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontFamily: 'Kanit',
                                                                              fontWeight: FontWeight.w400,
                                                                              height: 0,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }

                                                                      final item =
                                                                          filteredDrivers[
                                                                              index];
                                                                      final String
                                                                          driverName =
                                                                          "${item["nom"]} ${item["prenom"]}"
                                                                              .toLowerCase();
                                                                      final bool
                                                                          isSelected =
                                                                          driverNameBox ==
                                                                              "${item["nom"]} ${item["prenom"]}";
                                                                      final bool
                                                                          shouldDisplay =
                                                                          driverName
                                                                              .contains(
                                                                        searchController3
                                                                            .text
                                                                            .toLowerCase(),
                                                                      );
                                                                      return shouldDisplay
                                                                          ? Center(
                                                                              child: ListTile(
                                                                                  onTap: () {
                                                                                    box.write('driverNameAdmin', driverName);
                                                                                    setState(() {
                                                                                      driverNameBox = box.read('driverNameAdmin');
                                                                                    });
                                                                                    // final box = GetStorage();
                                                                                    String driverid = item['id'].toString();
                                                                                    print('Driver Id for filter:  $driverid');
                                                                                    box.write('driverId', driverid);
                                                                                    selectedDriverNotifier.value = "${item["nom"]} ${item["prenom"]}";
                                                                                    Navigator.pop(context);
                                                                                    filteredDrivers.clear();
                                                                                  },
                                                                                  title: Row(
                                                                                    children: [
                                                                                      Text(item["nom"]),
                                                                                      SizedBox(width: 5),
                                                                                      Text(item["prenom"]),
                                                                                    ],
                                                                                  ),
                                                                                  trailing: isSelected ? Icon(Icons.check, color: Colors.blue) : null),
                                                                            )
                                                                          : SizedBox
                                                                              .shrink();
                                                                    },
                                                                  )),
                                                  ],
                                                ),
                                              )),
                                        );
                                      });
                                    });
                              }
                            },
                            child: Container(
                              width: 280,
                              height: 45,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 20),
                                    if (driverNameBox != "DRIVER")
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedDriverNotifier.value =
                                                  "DRIVER";
                                              final driver =
                                                  box.read('driverName') ??
                                                      "Null hai value";

                                              print('Driver: $driver');

                                              box.remove('driverNameAdmin');
                                              box.remove('driverId');
                                              driverNameBox = "DRIVER";
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/images/cross2.png',
                                            color: Colors.red,
                                            scale: 1.5,
                                          )),
                                    SizedBox(width: 30),
                                    Text(
                                      driverNameBox,
                                      style: TextStyle(
                                        color: driverNameBox != "DRIVER"
                                            ? Colors.blue
                                            : Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 35),
                          child: GestureDetector(
                            onTap: () {
                              if (regionNameBox != "REGION" &&
                                  selectedClientNotifier.value != "REGION") {
                                showModalBottomSheet(
                                    backgroundColor: Color(0xFFE6F7FD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(38),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context, index) {
                                        final box = GetStorage();
                                        List<dynamic> client =
                                            (box.read('client') ?? []);
                                        print(
                                            "Client LIst in the Bottomsheet: $client");
                                        List<dynamic> filteredClient =
                                            List.from(client);
                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  1.5,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              25,
                                                    ),
                                                    Divider(
                                                      thickness: 0.5,
                                                      color: Colors.grey,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 54,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: TextFormField(
                                                            onChanged: (text) {
                                                              setState(() {
                                                                if (text
                                                                    .isEmpty) {
                                                                  // Show the original list when the TextField is empty
                                                                  filteredClient =
                                                                      List.from(
                                                                          client);
                                                                } else {
                                                                  // Filter drivers based on the search text
                                                                  filteredClient = client
                                                                      .where((item) =>
                                                                          item["nom"].toLowerCase().contains(text
                                                                              .toLowerCase()) ||
                                                                          item["prenom"]
                                                                              .toLowerCase()
                                                                              .contains(text.toLowerCase()))
                                                                      .toList();
                                                                }
                                                              });
                                                            },
                                                            controller:
                                                                searchController4,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'Search',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .search,
                                                                      color: Colors
                                                                          .black,
                                                                    )),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: client.isEmpty
                                                          ? Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 150,
                                                                  width: 200,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/images/no-icons/no-clients.png'),
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                  'No Clients available for this region..!!',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Kanit',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                    height: 20)
                                                              ],
                                                            )
                                                          : ListView.builder(
                                                              itemCount:
                                                                  filteredClient
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                if (filteredClient
                                                                    .isEmpty) {
                                                                  return Center(
                                                                    child: Text(
                                                                      'No Clients available',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        height:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                final item =
                                                                    filteredClient[
                                                                        index];
                                                                final String
                                                                    clientName =
                                                                    "${item["nom"]} ${item["prenom"]}"
                                                                        .toLowerCase();
                                                                final bool
                                                                    isSelected =
                                                                    selectedClientNotifier ==
                                                                        clientName;
                                                                final bool
                                                                    shouldDisplay =
                                                                    clientName
                                                                        .contains(
                                                                  searchController4
                                                                      .text
                                                                      .toLowerCase(),
                                                                );
                                                                String
                                                                    selected =
                                                                    "";

                                                                return shouldDisplay
                                                                    ? Center(
                                                                        child:
                                                                            ListTile(
                                                                          onTap:
                                                                              () {
                                                                            box.write('clientNameAdmin',
                                                                                clientName);
                                                                            setState(() {
                                                                              clientNameBox = box.read('clientNameAdmin');
                                                                              clientNameBox = "${item["nom"]} ${item["prenom"]}";
                                                                              selected = "true";
                                                                              print('Selected text: $selected');
                                                                            });
                                                                            String
                                                                                clientid =
                                                                                item['id'].toString();
                                                                            box.write('clientId',
                                                                                clientid);
                                                                            final IdClient =
                                                                                box.read('clientId');
                                                                            print('Client in Storage for filter: $IdClient');
                                                                            selectedClientNotifier.value =
                                                                                "${item["nom"]} ${item["prenom"]}";
                                                                            Navigator.pop(context);
                                                                          },
                                                                          title:
                                                                              Row(
                                                                            children: [
                                                                              Text(item["nom"]),
                                                                              SizedBox(width: 5),
                                                                              Text(item["prenom"]),
                                                                            ],
                                                                          ),
                                                                          trailing: (selected == "true")
                                                                              ? Icon(
                                                                                  Icons.check,
                                                                                  color: Colors.blue,
                                                                                )
                                                                              : null,
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink();
                                                              },
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        );
                                      });
                                    });
                              } else {
                                null;
                              }
                            },
                            child: Container(
                              width: 280,
                              height: 45,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 20),
                                    if (clientNameBox != "CLIENT")
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedClientNotifier.value =
                                                  "CLIENT";
                                              final client =
                                                  box.read('clientName') ??
                                                      "Null hai value";
                                              print('Client: $client');
                                              box.remove('clientNameAdmin');
                                              box.remove('clientId');
                                              clientNameBox = "CLIENT";
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/images/cross2.png',
                                            color: Colors.red,
                                            scale: 1.5,
                                          )),
                                    SizedBox(width: 5),
                                    Text(
                                      clientNameBox,
                                      style: TextStyle(
                                        color: clientNameBox != "CLIENT"
                                            ? Colors.blue
                                            : Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
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
                                  child: Text('Valider'),
                                  onPressed: () {
                                    setState(() {
                                      isFiltered = true;
                                    });
                                    if (regionNameBox == "REGION") {
                                      Get.snackbar(
                                        colorText: Colors.white,
                                        'Please',
                                        '',
                                        backgroundColor: const Color.fromARGB(
                                            255, 244, 114, 105),
                                        snackStyle: SnackStyle.FLOATING,
                                        margin: const EdgeInsets.all(10),
                                        borderRadius: 10,
                                        isDismissible: true,
                                        dismissDirection: DismissDirection.up,
                                        forwardAnimationCurve:
                                            Curves.easeOutBack,
                                        reverseAnimationCurve:
                                            Curves.easeInCirc,
                                        duration: const Duration(seconds: 3),
                                        barBlur: 0,
                                        messageText: const Text(
                                          'Select REGION',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        isFiltered = true;
                                        isRefreshed = true;
                                      });
                                      print(
                                          '==================================================');
                                      setState(() {
                                        appAdminToday.clear();
                                      });
                                      (isToday)
                                          ? _fetchAdminDataToday()
                                              .whenComplete(() {
                                              Navigator.of(context).pop();
                                            })
                                          : (isFuture)
                                              ? _fetchAdminDataFuture()
                                                  .whenComplete(() {
                                                  Navigator.of(context).pop();
                                                })
                                              : null;
                                      // calculateItemCount();
                                      Future.delayed(
                                          Duration(milliseconds: 600), () {
                                        setState(() {
                                          isRefreshed = false;
                                        });
                                      });
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            print(
                                '==================================================');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 250,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                    ),
                                    child: Text('Reset'),
                                    onPressed: () {
                                      resetValues();
                                      setState(() {
                                        box.remove('finalfilteredList');
                                        box.remove('regionNameAdmin');
                                        box.remove('driverNameAdmin');
                                        box.remove('clientNameAdmin');
                                        box.remove('typeNameAdmin');
                                        box.remove('typeId');
                                        box.remove('regionId');
                                        box.remove('driverId');
                                        box.remove('clientId');
                                        print('Region: $regionNameBox');
                                        print('Driver: $driverNameBox');
                                        print('Client: $clientNameBox');
                                        print('Type: $typeNameBox');
                                        AdminListFilter.clear();
                                        appAdminToday.clear();
                                        regionNameBox = "REGION";
                                        typeNameBox = "TYPE";
                                        clientNameBox = "CLIENT";
                                        driverNameBox = "DRIVER";
                                        AdminListFilter.clear();
                                        print('Region: $regionNameBox');
                                        print('Driver: $driverNameBox');
                                        print('Client: $clientNameBox');
                                        print('Type: $typeNameBox');
                                        box.remove('finalfilteredList');
                                        print(
                                            'Filtered List: $AdminListFilter');
                                        isTodayFiltered = false;
                                        isFutureFiltered = false;
                                      });
                                      AdminListFilter.clear();
                                      AdminListFilter.clear();

                                      Navigator.of(context).pop();
                                      AdminListFilter.clear();
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
              ),
            );
          });
        }).whenComplete(() {
      setState(() {});
      setState(() {
        isRefreshed = true;
      });
      Future.delayed(Duration(milliseconds: 600), () {
        // filterInitialdata();
        setState(() {
          isRefreshed = false;
        });
      });
    });
  }

  bool logoutConfirmed = false;

  Future<void> showLogoutAccountBottomSheet2(BuildContext context) async {
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
          height: MediaQuery.of(context).size.height / 2.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 10,
                child: Center(
                  child: Text(
                    'Se déconnecter ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.find<AuthController>().logout();
                  setState(() {
                    logoutConfirmed = true;
                  });
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
                  Get.back(result: false); // Logout canceled
                  setState(() {
                    logoutConfirmed = false;
                  });
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

  Future<dynamic> annulerBottomSheet(
    BuildContext context,
  ) async {
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
          final box = GetStorage();
          List<dynamic> tripData = box.read('AdminToday');

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
                            'Annuler Affectation',
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text()
                          ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Client Absent',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 18,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  height: 0.05,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> returnBottomSheet(BuildContext context) {
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
                          print('Ontap 2 Triggered..!!');
                          annulerBottomSheet(context);
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

  Future<List<Map<String, dynamic>>> TripListToday() async {
    print('enter kar kya');

    final _token = box.read('token') ?? '';
    final storage = GetStorage();

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "mob/course-all-aujourdhui";

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('GET', Uri.parse(gestionMainUrl));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('header aur body add ho gyi');
    if (response.statusCode == 200) {
      print('200 aa gya');
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      print(apiData);

      List<Map<String, dynamic>> AdminToday = [];
      for (var courses in apiData['courses']) {
        // print('loop me aa gya');
        int id = courses['id'];
        // String start = courses['start'];
        int nombrePassager = courses['nombrePassager'];
        String commentaire = courses['commentaire'];
        String paiement = courses['paiement'];
        // String chauffeur = courses['chauffeur'];
        int client = courses['client'];
        String status1 = courses['affectationCourses'][0]['status1'];
        String status2 = courses['affectationCourses'][0]['status2'];
        String backgroundColor = courses['backgroundColor'];
        String dateCourse = courses['dateCourse'];
        String distanceTrajet = courses['distanceTrajet'];
        String dureeTrajet = courses['dureeTrajet'];
        String nom = courses['clientDetails']['nom'];
        String prenom = courses['clientDetails']['prenom'];
        String telephone = courses['clientDetails']['tel1'];
        String depart = courses['depart'] ?? '';
        String arrive = courses['arrive'] ?? '';
        int imgType = courses['clientDetails']['typeClient']['id'] ?? "";

        // print('Depart in admin list: $tarif');

        // print('sara data map ho gya');

        AdminToday.add({
          'id': id,
          // 'start': start,
          'nombrePassager': nombrePassager,
          'commentaire': commentaire,
          'paiement': paiement,
          'client': client,
          'status1': status1,
          'status2': status2,
          'backgroundColor': backgroundColor,
          'dateCourse': dateCourse,
          'distanceTrajet': distanceTrajet,
          'dureeTrajet': dureeTrajet,
          'nom': nom,
          'prenom': prenom,
          'tel1': telephone,
          'depart': depart,
          'arrive': arrive,
          "imgType": imgType,
          // "chauffeur": chauffeur
        });
        // print('list me add ho gya');
      }
      // print('list ban gyi');

      print(AdminToday);
      box.write('AdminToday5', AdminToday);

      print('Storage me write ho gya');
      List<dynamic> AdminToday2 = box.read('AdminToday5');
      print('Admin Today in storage with refernce and date : $AdminToday2');

      return AdminToday;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> TripListFutureAdmin() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "mob/course-all-avenir";

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

      List<Map<String, dynamic>> AdminAvenir = [];
      for (var courses in apiData['courses']) {
        int id = courses['id'];
        // String start = courses['start'];
        int nombrePassager = courses['nombrePassager'];
        String commentaire = courses['commentaire'];
        String paiement = courses['paiement'];
        String chauffeur = courses['chauffeur'];
        int client = courses['client'];
        var affectationCourses = courses['affectationCourses'];
        String reference = courses['reference'];
        String backgroundColor = courses['backgroundColor'];
        String dateCourse = courses['dateCourse'];
        // String distanceTrajet = courses['distanceTrajet'];
        // String dureeTrajet = courses['dureeTrajet'];
        String nom = courses['clientDetails']['nom'];
        String prenom = courses['clientDetails']['prenom'];
        String telephone = courses['clientDetails']['tel1'];
        int region = courses['region'];
        String depart = courses['depart'];
        String arrive = courses['arrive'];
        int tarif = courses['tarif'];

        int imgType = courses['clientDetails']['typeClient']['id'] ?? "";

        // print('Depart in admin list: $tarif');
        AdminAvenir.add({
          'id': id,
          // 'start': start,
          'nombrePassager': nombrePassager,
          'commentaire': commentaire,
          'paiement': paiement,
          'reference': reference,
          'dateCourse': dateCourse,
          'chauffeur': chauffeur,
          // 'distanceTrajet': distanceTrajet,
          // 'dureeTrajet': dureeTrajet,
          'client': client,
          'region': region,
          // 'status1': status1,
          // 'status2': status2,
          'backgroundColor': backgroundColor,
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
          'imgType': imgType,
          'depart': depart,
          'arrive': arrive,
          'tarif': tarif
        });
      }

      print('Admin AVenir with reference: ${AdminAvenir}');
      box.write('AdminAvenir5', AdminAvenir);

      return AdminAvenir;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  bool isFiltered = false;

  int TotalCount = 0;
  String DataFilterToday = "";
  String DataFilterFuture = "";

  Future<void> _fetchAdminDataToday() async {
    setState(() {
      isRefreshed = true;
      isTodayFiltered = true;
      appAdminToday.clear();
    });
    print('AdminFilter list ki length: ${AdminListFilter.length}');
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData =
          await filteredListAdminToday();
      setState(() {
        AdminListFilter = adminData;
      });

      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < AdminListFilter.length; i += 10) {
        final endIndex =
            (i + 10 < AdminListFilter.length) ? i + 10 : AdminListFilter.length;
        appAdminToday.add(AdminListFilter.sublist(i, endIndex));
      }

      if (appAdminToday.isNotEmpty) {
        setState(() {
          DataFilterToday = "hasDataToday";
        });
      } else {
        setState(() {
          DataFilterToday = "";
        });
      }

      print('Admin data fetched successfully');
      print('App admin list ki length: ${appAdminToday.length}');
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

  Future<void> _fetchAdminDataFuture() async {
    setState(() {
      isRefreshed = true;
      isFutureFiltered = true;
      appAdminFuture.clear();
    });
    print('AdminFilter list ki length: ${AdminListFilter.length}');
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData =
          await filteredListAdminFuture();
      setState(() {
        AdminListFilter = adminData;
      });

      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < AdminListFilter.length; i += 10) {
        final endIndex =
            (i + 10 < AdminListFilter.length) ? i + 10 : AdminListFilter.length;
        appAdminFuture.add(AdminListFilter.sublist(i, endIndex));
      }

      print('App Admin Future ki list: $appAdminFuture');

      if (appAdminFuture.isNotEmpty) {
        setState(() {
          DataFilterFuture = "hasDataFuture";
        });
      } else {
        setState(() {
          DataFilterFuture = "";
        });
      }

      print('Admin data fetched successfully');
      print('App admin list ki length: ${appAdminFuture.length}');
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

  Future<List<Map<String, dynamic>>> filteredListAdminToday() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final regionId = box.read('regionId');
    final typeId = box.read('typeId');
    final driverId = box.read('driverId');
    final clientId = box.read('clientId');

    print(
        'Ids in filter APi function: $regionId, $typeId, $clientId, $driverId, $today, $future');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "mob/filtre-course";

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode({
      "region": regionId,
      "typeCourse": typeId,
      "client": clientId,
      "chauffeur": driverId,
      "passeAvenirToday": today.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      List<Map<String, dynamic>> Filteredlist = [];
      int total = apiData['totalCount'];

      setState(() {
        TotalCount = total;
      });

      print('Total Count After setting it in variable: $TotalCount');

      print('Total Count : $total');
      for (var courses in apiData['courses']) {
        int id = courses['id'];
        // String start = courses['start'];
        int nombrePassager = courses['nombrePassager'];
        String commentaire = courses['commentaire'];
        String paiement = courses['paiement'];
        String chauffeur = courses['chauffeur'];
        int client = courses['client'];
        String status1 = courses['affectationCourses'][0]['status1'];
        String status2 = courses['affectationCourses'][0]['status2'];
        String reference = courses['reference'];
        int tarif = courses['tarif'];
        String backgroundColor = courses['backgroundColor'];
        String dateCourse = courses['dateCourse'];
        String nom = courses['clientDetails']['nom'];
        String prenom = courses['clientDetails']['prenom'];
        String telephone = courses['clientDetails']['tel1'];
        String driverNom = courses['chauffeurDetails']['nom'];
        String driverPrenom = courses['chauffeurDetails']['prenom'];
        int region = courses['region'];
        int statusCourse = courses['statusCourse'];
        String depart = courses['depart'];
        String arrive = courses['arrive'];

        int imgType = courses['clientDetails']['typeClient']['id'] ?? "";
        Filteredlist.add({
          'id': id,
          // 'start': start,
          'nombrePassager': nombrePassager,
          'commentaire': commentaire,
          'paiement': paiement,
          'reference': reference,
          'dateCourse': dateCourse,
          'client': client,
          'region': region,
          'status1': status1,
          'status2': status2,
          'backgroundColor': backgroundColor,
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
          'imgType': imgType,
          'depart': depart,
          'arrive': arrive,
          'tarif': tarif,
          'chauffeur': chauffeur,
          'driverNom': driverNom,
          "driverPrenom": driverPrenom,
          "statusCourse": statusCourse
        });
      }
      print('Filtered List in API: $Filteredlist');
      box.write('finalfilteredList', Filteredlist);
      List<dynamic> adminToday2 = box.read('finalfilteredList');
      print('Filtered list in Storage: $adminToday2');
      // Navigator.of(context).pop();
      return Filteredlist;
    } else {
      throw Exception('Failed to fetch admin data: ${response.reasonPhrase}');
    }
  }

  Future<List<Map<String, dynamic>>> filteredListAdminFuture() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final regionId = box.read('regionId');
    final typeId = box.read('typeId');
    final driverId = box.read('driverId');
    final clientId = box.read('clientId');

    print(
        'Ids in filter APi function: $regionId, $typeId, $clientId, $driverId, $today, $future');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "mob/filtre-course";

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode({
      "region": regionId,
      "typeCourse": typeId,
      "client": clientId,
      "chauffeur": driverId,
      "passeAvenirToday": future.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      List<Map<String, dynamic>> Filteredlist = [];
      int total = apiData['totalCount'];

      setState(() {
        TotalCount = total;
      });

      print('Total Count After setting it in variable: $TotalCount');

      print('Total Count : $total');
      for (var courses in apiData['courses']) {
        int id = courses['id'];
        // String start = courses['start'];
        int nombrePassager = courses['nombrePassager'];
        String commentaire = courses['commentaire'];
        String paiement = courses['paiement'];
        String chauffeur = courses['chauffeur'];
        int client = courses['client'];
        String status1 = courses['affectationCourses'][0]['status1'];
        String status2 = courses['affectationCourses'][0]['status2'];
        String reference = courses['reference'];
        int tarif = courses['tarif'];
        String backgroundColor = courses['backgroundColor'];
        String dateCourse = courses['dateCourse'];
        String nom = courses['clientDetails']['nom'];
        String prenom = courses['clientDetails']['prenom'];
        String telephone = courses['clientDetails']['tel1'];
        String driverNom = courses['chauffeurDetails']['nom'];
        String driverPrenom = courses['chauffeurDetails']['prenom'];
        int region = courses['region'];
        int statusCourse = courses['statusCourse'];
        String depart = courses['depart'];
        String arrive = courses['arrive'];

        int imgType = courses['clientDetails']['typeClient']['id'] ?? "";
        Filteredlist.add({
          'id': id,
          // 'start': start,
          'nombrePassager': nombrePassager,
          'commentaire': commentaire,
          'paiement': paiement,
          'reference': reference,
          'dateCourse': dateCourse,
          'client': client,
          'region': region,
          'status1': status1,
          'status2': status2,
          'backgroundColor': backgroundColor,
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
          'imgType': imgType,
          'depart': depart,
          'arrive': arrive,
          'tarif': tarif,
          'chauffeur': chauffeur,
          'driverNom': driverNom,
          "driverPrenom": driverPrenom,
          "statusCourse": statusCourse
        });
      }
      print('Filtered List in API: $Filteredlist');
      box.write('finalfilteredList', Filteredlist);
      List<dynamic> adminToday2 = box.read('finalfilteredList');
      print('Filtered list in Storage: $adminToday2');
      // Navigator.of(context).pop();
      return Filteredlist;
    } else {
      throw Exception('Failed to fetch admin data: ${response.reasonPhrase}');
    }
  }

  Future<dynamic> affectationBottomSheet(
      BuildContext context, GetStorage box, Map<String, dynamic> item) {
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
              height: MediaQuery.of(context).size.height / 1.5,
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
                          print('Ontap 2 Triggered..!!');
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
        });
  }

  Future<dynamic> clientAbsentBottomSheet(
      BuildContext context, Map<String, dynamic> item) {
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
          DateTime parsedDate = DateTime.parse(item['dateCourse']);
          DateTime utcDate = parsedDate.toUtc();
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x07000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: reassign,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.2),
                              ),
                              labelText: "Commentaire",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFA4A4A4),
                              ) // Placeholder text
                              ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Comment';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 250,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF3954A4)),
                              child: Text('Confirmer'),
                              onPressed: () {
                                // returnRide();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> AnnularAffectationBottomSheet(
      BuildContext context, GetStorage box, Map<String, dynamic> item) {
    GlobalKey<FormState> annularKey = GlobalKey<FormState>();

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
          final TextEditingController _controller = TextEditingController();
          String? _selectedValue;
          List<dynamic> driverList3 = box.read('driver2');
          DateTime parsedDate = DateTime.parse(item['dateCourse']);
          DateTime utcDate = parsedDate.toUtc();
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                child: Form(
                  key: annularKey,
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
                              'Annuler Affectation',
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (item['reference'] == "") Text("No Reference"),
                              Text(item['reference']),
                              Text('-'),
                              Text(DateFormat(
                                      'dd-MM-yyyy         -         hh:mm a')
                                  .format(utcDate)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x07000000),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: reassign,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1.2),
                                ),
                                labelText: "Motif d'annulation",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFA4A4A4),
                                ) // Placeholder text
                                ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Motif';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x07000000),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonFormField<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.2),
                              ),
                              labelText: "Choisir Chauffeur",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFA4A4A4),
                              ),
                            ),
                            value: _selectedValue,
                            items: driverList3.map((dynamic item) {
                              return DropdownMenuItem<String>(
                                value: item['nom'].toString() +
                                    item['prenom'].toString(),
                                child: Row(
                                  children: [
                                    Text(item['nom'].toString()),
                                    Text(item['prenom'].toString()),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedValue = value;
                                _controller.text = value ?? '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Choose an Option';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 250,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF3954A4)),
                                child: Text('Confirmer'),
                                onPressed: () {
                                  if (annularKey.currentState!.validate()) {
                                    returnRide2();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  String role = "";
  String deviceName = "";

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? mToken;

  Widget _buildTextButton(String text, bool hovered) {
    return Container(
      height: 90,
      width: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.white,
      ),
      child: Center(
          child: Text(
        overflow: TextOverflow.ellipsis,
        text,
        style: TextStyle(color: Colors.white, fontSize: 14.5),
      )),
    );
  }

  String M = " ";

  Future<bool> canLaunchGoogleMap() async {
    final url = 'https://www.google.com/maps/';
    return await canLaunch(url);
  }

  Future<bool> canLaunchWazeMap() async {
    final url = 'https://www.waze.com/';
    return await canLaunch(url);
  }

  Future<void> currentLocaionlaunchMap(String destination) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$destination';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showMapChooserDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.15,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFE6F7FD),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choisissez l'application pour lancer la carte",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Kanit',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () async {
                      if (await canLaunchGoogleMap()) {
                        currentLocaionlaunchMap(M);
                      } else {
                        _showAppNotInstalledSnackBar(context, 'Google Maps');
                      }
                    },
                    leading: Image.asset('assets/images/gmaps.png'),
                    title: Text(
                      'Google Maps',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () async {
                      if (await canLaunchWazeMap()) {
                        currentLocaionlaunchMap(M);
                      } else {
                        _showAppNotInstalledSnackBar(context, 'Waze');
                      }
                    },
                    leading: Image.asset('assets/images/waze.png'),
                    title: Text(
                      'Waze',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF3954A4),
                    ),
                    child: Text('Annuler'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAppNotInstalledSnackBar(BuildContext context, String appName) {
    Get.snackbar(
        backgroundColor: Colors.white,
        '$appName is not installed on your device',
        "Please Select other Option..!! ");
  }

  @override
  Widget build(BuildContext context) {
    // final box = GetStorage();



    // print('Height of device: $height');
    // print('Width of device: $widht');

    return PieCanvas(
      theme: PieTheme(
          delayDuration: Duration.zero,
          tooltipTextStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          buttonSize: 55),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    decoration: BoxDecoration(color: Color(0xFF3954A4)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  'Planning',
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
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          adminFilterBottomSheet(context);
                                        },
                                        child: Image.asset(
                                            'assets/images/filter.png'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      (isFutureFiltered || isTodayFiltered)
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isRefreshed = true;
                                                  appAdminToday.clear();
                                                });
                                                AdminListFilter.clear();
                                                setState(() {});
                                                AdminListFilter.clear();
                                                AdminListFilter = [];
                                                AdminListFilter.clear();
                                                setState(() {
                                                  appAdminToday.clear();
                                                  box.remove(
                                                      'finalfilteredList');
                                                  box.remove('regionNameAdmin');
                                                  box.remove('driverNameAdmin');
                                                  box.remove('clientNameAdmin');
                                                  box.remove('typeNameAdmin');
                                                  box.remove('typeId');
                                                  box.remove('regionId');
                                                  box.remove('driverId');
                                                  box.remove('clientId');
                                                  print(
                                                      'Region: $regionNameBox');
                                                  print(
                                                      'Driver: $driverNameBox');
                                                  print(
                                                      'Client: $clientNameBox');
                                                  print('Type: $typeNameBox');
                                                  AdminListFilter.clear();
                                                  regionNameBox = "REGION";
                                                  typeNameBox = "TYPE";
                                                  clientNameBox = "CLIENT";
                                                  driverNameBox = "DRIVER";
                                                  AdminListFilter.clear();
                                                  print(
                                                      'Region: $regionNameBox');
                                                  print(
                                                      'Driver: $driverNameBox');
                                                  print(
                                                      'Client: $clientNameBox');
                                                  print('Type: $typeNameBox');
                                                  box.remove(
                                                      'finalfilteredList');
                                                  print(
                                                      'Filtered List: $AdminListFilter');
                                                });
                                                AdminListFilter.clear();
                                                setState(() {
                                                  isRefreshed = false;
                                                  appAdminToday.clear();
                                                  isFiltered = false;
                                                  isFutureFiltered = false;
                                                  isTodayFiltered = false;
                                                });
                                              },
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/images/cross3.png',
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  )
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
                Positioned(
                  bottom: -15,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                _changeTodayContainerColor();
                              },
                              child: Container(
                                width: 150,
                                height: 43,
                                decoration: BoxDecoration(
                                    color: todayContainerColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                      )
                                    ]),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Today",
                                      style: TextStyle(
                                        color: todayColor,
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                _changeFutureContainerColor();
                              },
                              child: Container(
                                width: 150,
                                height: 43,
                                decoration: BoxDecoration(
                                    color: futureContainerColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                      )
                                    ]),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Future",
                                      style: TextStyle(
                                        color: avenirColor,
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.11,
                                      ),
                                    ),
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                height: 650,
                child: isToday
                    ? (isTodayFiltered)
                        ? AdminFilterToday(
                            data: DataFilterToday,
                          )
                        : TodayList()
                    : isFuture
                        ? (isFutureFiltered)
                            ? AdminFilterFuture(data: DataFilterFuture)
                            : FutureAdminList()
                        : SizedBox.shrink(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
