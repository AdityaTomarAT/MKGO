// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unused_local_variable, sized_box_for_whitespace, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
// import 'dart:js_interop';

import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:fr.innoyadev.mkgodev/Utility/bottomSheet.dart';
// import 'package:fr.innoyadev.mkgodev/cart/cart.dart';
import 'package:fr.innoyadev.mkgodev/lists/driver/driverFilterListFuture.dart';
import 'package:fr.innoyadev.mkgodev/lists/driver/driverFilterListPast.dart';
import 'package:fr.innoyadev.mkgodev/lists/driver/driverFilterListToday.dart';
import 'package:fr.innoyadev.mkgodev/lists/driver/future.dart';
import 'package:fr.innoyadev.mkgodev/lists/driver/present.dart';
// import 'package:fr.innoyadev.mkgodev/login/loginModel.dart';
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
// import 'package:fr.innoyadev.mkgodev/tripDetails/tripDetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:intl/intl.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:pie_menu/pie_menu.dart';

import '../lists/driver/past.dart';

GetStorage fcm = GetStorage();

final storage = GetStorage();

GetStorage box = GetStorage();
bool isPasser = false;
bool isAujoudHui = false;
bool isAvenir = false;
bool isRefreshed = false;
bool isFiltererd = false;
bool isTodayDriverFiltered = false;
bool isPastDriverFiltered = false;
bool isAvenirDriverFiltered = false;
bool isloading = false;
List<Map<String, dynamic>> DriverListFilter = [];
List<List<Map<String, dynamic>>> appDriverToday = [];
List<List<Map<String, dynamic>>> appDriverPast = [];
List<List<Map<String, dynamic>>> appDriverAvenir = [];
// bool handOpen = false;

// filteredList = box.read('filteredListDriver');

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TextEditingController returnController = TextEditingController();

  Future<List<Map<String, dynamic>>> tripListPast() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "mob/course-chauffeur-passe/" + UserID.toString();

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

      // print(apiData);
      print('Chauffeur id for the specific trip: ${apiData['chauffeur']}');

      List<Map<String, dynamic>> tripList = [];
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
        tripList.add({
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
          "chauffeur": chauffeur
        });
      }

      // print(tripList);
      box.write('tripList', tripList);
      print('Checking list for chauffeurid: $tripList');
      setState(() {
        // trips = tripList;
      });

      return [];
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> tripListPresent() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "mob/course-chauffeur-aujourdhui/" + UserID.toString();

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

      // print('Chauffeur id for the specific trip: ${apiData['courses']['chauffeur'].toString()}');
      print(apiData);

      List<Map<String, dynamic>> tripPresentAPI = [];
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

        tripPresentAPI.add({
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
          "chauffeur": chauffeur
        });
      }

      // print(tripPresent);
      box.write('present', tripPresentAPI);
      print('Checking list for chauffeurid: $tripPresentAPI');
      setState(() {
        // tripsPresent = tripPresentAPI;
      });

      return [];
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  int currentIndex2 = 0;

  String DriverFilterToday = "";
  String DriverFilterpast = "";
  String DriverFilterAvenir = "";

  Future<void> _fetchAdminDataToday() async {
    setState(() {
      isRefreshed = true;
      isTodayDriverFiltered = true;
      appDriverToday.clear();
    });
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData =
          await filteredListDriverToday();
      setState(() {
        DriverListFilter = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < DriverListFilter.length; i += 10) {
        final endIndex = (i + 10 < DriverListFilter.length)
            ? i + 10
            : DriverListFilter.length;
        appDriverToday.add(DriverListFilter.sublist(i, endIndex));
      }

      print('Admin data fetched successfully');
      if (appDriverToday.isNotEmpty) {
        setState(() {
          DriverFilterToday = "hasDataToday";
        });
      } else {
        setState(() {
          DriverFilterToday = "";
        });
      }
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

  Future<void> _fetchAdminDataPast() async {
    setState(() {
      isRefreshed = true;
      isPastDriverFiltered = true;
      appDriverPast.clear();
    });
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData =
          await filteredListDriverPast();
      setState(() {
        DriverListFilter = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < DriverListFilter.length; i += 10) {
        final endIndex = (i + 10 < DriverListFilter.length)
            ? i + 10
            : DriverListFilter.length;
        appDriverPast.add(DriverListFilter.sublist(i, endIndex));
      }

      print('Admin data fetched successfully');
      if (appDriverPast.isNotEmpty) {
        setState(() {
          DriverFilterpast = "hasDataToday";
        });
      } else {
        setState(() {
          DriverFilterpast = "";
        });
      }
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
      isAvenirDriverFiltered = true;
      appDriverAvenir.clear();
    });
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData =
          await filteredListDriverAvenir();
      setState(() {
        DriverListFilter = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < DriverListFilter.length; i += 10) {
        final endIndex = (i + 10 < DriverListFilter.length)
            ? i + 10
            : DriverListFilter.length;
        appDriverAvenir.add(DriverListFilter.sublist(i, endIndex));
      }

      print('Admin data fetched successfully');
      if (appDriverAvenir.isNotEmpty) {
        setState(() {
          DriverFilterAvenir = "hasDataToday";
        });
      } else {
        setState(() {
          DriverFilterAvenir = "";
        });
      }
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

  Future<List<Map<String, dynamic>>> tripListFuture() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "mob/course-chauffeur-avenir/" + UserID.toString();

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

      List<Map<String, dynamic>> tripFutureAPI = [];
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
        tripFutureAPI.add({
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
          'chauffeur': chauffeur
        });
      }

      // print(tripFuture);
      box.write('future', tripFutureAPI);
      print('Checking list for chauffeurid: $tripFutureAPI');
      setState(() {
        // tripsFuture = tripFutureAPI;
      });

      return [];
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<void> getDetails() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    print("token called: $_token");

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "mob/one-employe/" + UserID.toString();

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

      String name2 = apiData['nom'];
      String surname2 = apiData['prenom'];
    } else {
      print(response.reasonPhrase);
    }
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: Text('Return Ride??'),
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Motive For Return",
                    ),
                  ),
                ),
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
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF3954A4)),
                    child: Text('Return\nRide'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  int currentPage = 1;
  int itemsPerPage = 10;
  int itemsPerPage2 = 5;
  bool isAtEndOfList = false;

  // final GlobalKey<_HomeScreen2State> _key = GlobalKey<_HomeScreen2State>();

  @override
  void initState() {
    super.initState();
    // setLocation();
    // if()
    if (isAujoudHui && appDriverToday.isNotEmpty) {
      _fetchAdminDataToday();
    } else if (isPasser && appDriverPast.isNotEmpty) {
      _fetchAdminDataPast();
    } else if (isAvenir && appDriverAvenir.isNotEmpty) {
      _fetchAdminDataFuture();
    } else {
      null;
    }
    loadInitialData();
    // _changeAujourdHuiContainerColor();
    setState(() {
      currentPage = 1;
      print('Current index: $currentPage');
      today = 'today';
      passer = "";
      future = "";
      passerContainerColor = Colors.white;
      aujourdhuiContainerColor = Color(0xFFF8B43D);
      avenirContainerColor = Colors.white;
      print('passeAvenirToday : $today');
      isAujoudHui = true;
      isRefreshed = true;
      isPasser = false;
      isAvenir = false;
      aujurdHuiTextColor = Colors.white;
      avenirTextColor = Color(0xFF524D4D);
      // aujurdHuiTextColor = ;
      passerTextColor = Color(0xFF524D4D);
    });

    passerContainerColor = Colors.white;
    aujourdhuiContainerColor = Color(0xFFF8B43D);
    avenirContainerColor = Colors.white;

    setState(() {
      isAujoudHui = true;
      isPasser = false;
      isAvenir = false;
      // isRefreshed = true;
    });
    setState(() {
      isRefreshed = true;
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        isRefreshed = false;
      });
    });
    submitForm();
    getHotline();
    typeList();

    controller = ScrollController()..addListener(_scrollListener);
    print('Controller : $controller');
    print('Testinf in inistState');
    // DriverListFilter!.clear();
    setState(() {
      // appDriverToday.clear();
    });
    // _fetchAdminData();
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

  Color passerContainerColor = Colors.white;
  Color aujourdhuiContainerColor = Color(0xFFF8B43D);
  Color avenirContainerColor = Colors.white;

  Color passerTextColor = Color(0xFF524D4D);
  Color avenirTextColor = Color(0xFF524D4D);
  Color aujurdHuiTextColor = Color(0xFF524D4D);

  void _changePasserContainerColor() {
    setState(() {
      isRefreshed = true;
    });
    if (isFiltererd) {
      _fetchAdminDataPast();
    }

    tripListPast();
    loadInitialData();
    setState(() {
      currentPage = 1;
      print('Current index: $currentPage');
      passer = "passer";
      today = "";
      future = "";
      passerContainerColor = Color(0xFFF8B43D);
      aujourdhuiContainerColor = Colors.white;
      avenirContainerColor = Colors.white;
      print('passeAvenirToday : $passer');
      passerTextColor = Colors.white;
      aujurdHuiTextColor = Color(0xFF524D4D);
      avenirTextColor = Color(0xFF524D4D);
      // aujurdHuiTextColor = ;
      // passerTextColor = ;
    });
    setState(() {
      isPasser = true;
      // isRefreshed = true;
      isAujoudHui = false;
      isAvenir = false;
    });
    setState(() {
      isRefreshed = false;
    });
  }

  void _changeAujourdHuiContainerColor() {
    setState(() {
      isRefreshed = true;
    });
    if (isFiltererd) {
      _fetchAdminDataToday();
    } 

    tripListPresent();
    loadInitialData();
    setState(() {
      currentPage = 1;
      print('Current index: $currentPage');
      today = 'today';
      passer = "";
      future = "";
      passerContainerColor = Colors.white;
      aujourdhuiContainerColor = Color(0xFFF8B43D);
      avenirContainerColor = Colors.white;
      print('passeAvenirToday : $today');
      isAujoudHui = true;
      // isRefreshed = true;
      isPasser = false;
      isAvenir = false;
      aujurdHuiTextColor = Colors.white;
      avenirTextColor = Color(0xFF524D4D);
      // aujurdHuiTextColor = ;
      passerTextColor = Color(0xFF524D4D);
    });
    setState(() {
      isRefreshed = false;
    });
  }

  void _changeAvenirContainerColor() {
    setState(() {
      isRefreshed = true;
    });
    if (isFiltererd) {
      _fetchAdminDataFuture();
    } 

    tripListFuture();
    loadInitialData();
    setState(() {
      currentPage = 1;
      print('Current index: $currentPage');
      future = "avenir";
      today = "";
      passer = "";
      passerContainerColor = Colors.white;
      aujourdhuiContainerColor = Colors.white;
      avenirContainerColor = Color(0xFFF8B43D);
      print('passeAvenirToday : $future');
      avenirTextColor = Colors.white;
      aujurdHuiTextColor = Color(0xFF524D4D);
      passerTextColor = Color(0xFF524D4D);
    });
    setState(() {
      isAvenir = true;
      // isRefreshed = true;
      isPasser = false;
      isAujoudHui = false;
    });
    setState(() {
      isRefreshed = false;
    });
  }

  Future<void> handleRefresh() async {
    setState(() {
      isRefreshed = true;
    });
    await Future.delayed(Duration(milliseconds: 500), () {
      // tripListPast();
      // tripListPresent();
      // tripListFuture();
      loadInitialData();
      // filteredListDriver();
      setState(() {
        isRefreshed = false;
      });
    });
  }

  bool showOptions = false;
  bool isDimmed = false;
  List<String> selectedItems = [];
  String selectedType = '';
  final TextEditingController _typeController = TextEditingController();

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
        final List<dynamic> typeData = apiData["collections"] ?? [];
        List<Map<String, dynamic>> type = typeData.map((item) {
          return {
            "id": item["id"].toString(),
            "libelle": item["libelle"].toString(),
          };
        }).toList();
        box.write('type2', type);

        return type;
      } else {}
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<dynamic> bottomSheet1(BuildContext context) {
    ScrollController _controller2 = ScrollController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController searchController1 = TextEditingController();

    void clearTextField() {
      searchController1.text = '';
    }

    final box = GetStorage();
    List<dynamic> type = (box.read('type2') ?? []);
    print("Type List in the Bottomsheet: $type");
    List<dynamic> filteredType = List.from(type);

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
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.6,
                child: Center(
                  child: Form(
                    key: _formKey,
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
                                'Select the type of race',
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
                              child: TextFormField(
                                onChanged: (text) {
                                  setState(() {
                                    filteredType = type
                                        .where((item) => item["libelle"]
                                            .toLowerCase()
                                            .contains(text.toLowerCase()))
                                        .toList();
                                        print("Filtered LIst: $filteredType");
                                        print("original LIst: $type");
                                  });
                                },
                                controller: searchController1,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: searchController1.text.isEmpty
                              ? ListView.builder(
                                  itemCount: type.length,
                                  itemBuilder: ((context, index) {
                                    final item = type[index];

                                    return ListTile(
                                      title: Text(
                                        item["libelle"],
                                        style: TextStyle(fontFamily: 'Kanit'),
                                      ),
                                      trailing: selectedItems
                                              .contains(item["libelle"])
                                          ? Icon(Icons.check,
                                              color: Colors.blue)
                                          : null,
                                      onTap: () {
                                        selectedItems.clear();

                                        final box = GetStorage();
                                        final typeDriverFilter =
                                            box.write('typeFilter', item['id']);
                                        final typeID = box.read('typeFilter');
                                        print(
                                            'Type id for filter in get storage : $typeID');
                                        setState(() {
                                          if (selectedItems
                                              .contains(item["libelle"])) {
                                            selectedItems
                                                .remove(item["libelle"]);
                                          } else {
                                            selectedItems.add(item["libelle"]);
                                          }
                                        });
                                      },
                                    );
                                  }),
                                )
                              : ListView.builder(
                                  itemCount: filteredType.length,
                                  itemBuilder: ((context, index) {
                                    final item = filteredType[index];

                                    return ListTile(
                                      title: Text(item["libelle"]),
                                      trailing: (isTodayDriverFiltered ||
                                              isPastDriverFiltered ||
                                              isAvenirDriverFiltered)
                                          ? Icon(Icons.check,
                                              color: Colors.blue)
                                          : null,
                                      onTap: () {
                                        selectedItems.clear();
                                        final box = GetStorage();
                                        final typeDriverFilter =
                                            box.write('typeFilter', item['id']);
                                        final typeID = box.read('typeFilter');
                                        print(
                                            'Type id for filter in get storage : $typeID');
                                        setState(() {
                                          if (selectedItems
                                              .contains(item["libelle"])) {
                                            selectedItems
                                                .remove(item["libelle"]);
                                          } else {
                                            selectedItems.add(item["libelle"]);
                                          }
                                          // selectedItems.clear();
                                        });
                                      },
                                    );
                                  }),
                                ),
                        ),
                        Row(
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
                                    isFiltererd = true;
                                    appDriverToday.clear();
                                    isRefreshed = true;
                                  });
                                  appDriverToday.clear();
                                  (isAujoudHui)
                                      ? _fetchAdminDataToday()
                                      : (isPasser)
                                          ? _fetchAdminDataPast()
                                          : (isAvenir)
                                              ? _fetchAdminDataFuture()
                                              : null;

                                  Navigator.of(context, rootNavigator: true)
                                      .pop(
                                    selectedItems.join(''),
                                  );
                                  setState(() {
                                    isRefreshed = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
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
                                  DriverListFilter.clear();
                                  tripListFuture();
                                  tripListPresent();
                                  tripListPast();
                                  setState(() {
                                    isRefreshed = true;
                                    isFiltererd = false;
                                    isTodayDriverFiltered = false;
                                    isPastDriverFiltered = false;
                                    isAvenirDriverFiltered = false;
                                    selectedItems.clear();
                                    appDriverToday.clear();
                                    appDriverPast.clear();
                                    appDriverAvenir.clear();
                                    selectedType = '';
                                    GetStorage box = GetStorage();
                                    if (box.hasData('filteredList')) {
                                      box.remove('filteredList');
                                    }
                                    DriverListFilter.clear();
                                  });
                                  Navigator.of(context).pop();
                                  Future.delayed(Duration(milliseconds: 800),
                                      () {
                                    setState(() {
                                      isRefreshed = false;
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        isloading = true;
      });
      Future.delayed(Duration(milliseconds: 600), () {
        setState(() {
          isloading = false;
        });
      });
    });
  }

  Future<dynamic> bottomSheet3(BuildContext context) {
    void clearTextField() {
      returnController.text = '';
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
                          ),
                        ),
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
                                  primary: Color(0xFF3954A4)),
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
      },
    ).whenComplete(clearTextField);
  }

  String today = "";
  String future = "";
  String passer = "";

  Future<List<Map<String, dynamic>>> filteredListDriverToday() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final storage = GetStorage();

    final regionId = storage.read('user_region_Id');
    final typeId = box.read('typeFilter');
    final driverId = storage.read('user_id');

    print(
        'Ids for filter list admin: $regionId, $typeId, $driverId, $today, $passer, $future');

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
      // "client": clientId,
      "chauffeur": driverId,
      "passeAvenirToday": today.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      List<Map<String, dynamic>> Filteredlist = [];

      print('Chauffeur id for the specific trip: ${apiData['chauffeur']}');

      int total = apiData['totalCount'];
      print('Total Count : $total');
      for (var courses in apiData['courses']) {
        int id = courses['id'];
        // String start = courses['start'];
        int nombrePassager = courses['nombrePassager'];
        String commentaire = courses['commentaire'];
        String paiement = courses['paiement'];
        String chauffeur = courses['chauffeur'];
        int client = courses['client'];
        int statusCourse = courses['statusCourse'];
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

        // int imgType = courses['clientDetails']['typeClient']['id'] ?? "";
        Filteredlist.add({
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
          'chauffeur': chauffeur,
          "statusCourse": statusCourse
        });
      }
      print('Filtered List in API: $Filteredlist');
      box.write('filteredListDriver', Filteredlist);
      List<dynamic> adminToday2 = box.read('filteredListDriver');
      print('Filtered list in Storage: $adminToday2');
      filteredData();

      return Filteredlist;
    } else {
      throw Exception('Failed to fetch admin data: ${response.reasonPhrase}');
    }
  }

  Future<List<Map<String, dynamic>>> filteredListDriverPast() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final storage = GetStorage();

    final regionId = storage.read('user_region_Id');
    final typeId = box.read('typeFilter');
    final driverId = storage.read('user_id');

    print(
        'Ids for filter list admin: $regionId, $typeId, $driverId, $today, $passer, $future');

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
      // "client": clientId,
      "chauffeur": driverId,
      "passeAvenirToday": passer.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      List<Map<String, dynamic>> Filteredlist = [];

      print('Chauffeur id for the specific trip: ${apiData['chauffeur']}');

      int total = apiData['totalCount'];
      print('Total Count : $total');
      for (var courses in apiData['courses']) {
        int id = courses['id'];
        // String start = courses['start'];
        int nombrePassager = courses['nombrePassager'];
        String commentaire = courses['commentaire'];
        String paiement = courses['paiement'];
        String chauffeur = courses['chauffeur'];
        int client = courses['client'];
        int statusCourse = courses['statusCourse'];
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

        // int imgType = courses['clientDetails']['typeClient']['id'] ?? "";
        Filteredlist.add({
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
          'chauffeur': chauffeur,
          "statusCourse": statusCourse
        });
      }
      print('Filtered List in API: $Filteredlist');
      box.write('filteredListDriver', Filteredlist);
      List<dynamic> adminToday2 = box.read('filteredListDriver');
      print('Filtered list in Storage: $adminToday2');
      filteredData();

      return Filteredlist;
    } else {
      throw Exception('Failed to fetch admin data: ${response.reasonPhrase}');
    }
  }

  Future<List<Map<String, dynamic>>> filteredListDriverAvenir() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final storage = GetStorage();

    final regionId = storage.read('user_region_Id');
    final typeId = box.read('typeFilter');
    final driverId = storage.read('user_id');

    print(
        'Ids for filter list admin: $regionId, $typeId, $driverId, $today, $passer, $future');

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
      // "client": clientId,
      "chauffeur": driverId,
      "passeAvenirToday": future.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      List<Map<String, dynamic>> Filteredlist = [];

      print('Chauffeur id for the specific trip: ${apiData['chauffeur']}');

      int total = apiData['totalCount'];
      print('Total Count : $total');
      for (var courses in apiData['courses']) {
        int id = courses['id'];
        // String start = courses['start'];
        int nombrePassager = courses['nombrePassager'];
        String commentaire = courses['commentaire'];
        String paiement = courses['paiement'];
        String chauffeur = courses['chauffeur'];
        int client = courses['client'];
        int statusCourse = courses['statusCourse'];
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

        // int imgType = courses['clientDetails']['typeClient']['id'] ?? "";
        Filteredlist.add({
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
          'chauffeur': chauffeur,
          "statusCourse": statusCourse
        });
      }
      print('Filtered List in API: $Filteredlist');
      box.write('filteredListDriver', Filteredlist);
      List<dynamic> adminToday2 = box.read('filteredListDriver');
      print('Filtered list in Storage: $adminToday2');
      filteredData();

      return Filteredlist;
    } else {
      throw Exception('Failed to fetch admin data: ${response.reasonPhrase}');
    }
  }

  String hotlineNumber = "";

  Future<void> getHotline() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    print("token called: $_token");

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "api/get/entreprise/31";

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

      String hotlineTelephone = apiData['telephone'];

      print("Hotline from api : $hotlineTelephone");

      setState(() {
        hotlineNumber = hotlineTelephone;
      });

      print('Hotline number in string: $hotlineNumber');
    } else {
      print(response.reasonPhrase);
    }
  }

  ScrollController controller = ScrollController();
  bool isLoadingMore = false;

  void loadInitialData() {
    print('loadmoredata fucntion is calling');

    tripListPast();
    tripListPresent();
    tripListFuture();
  }

  void filteredData() {
    print('loadmoredata fucntion is calling');

    DriverListFilter = box.read('filteredListDriver');

    // print('Past Trips in loadmore : $trips');

    setState(() {
      DriverListFilter = DriverListFilter.toList();
    });
  }

  int currentIndex = 0; // Keeps track of the current index

  Future<void> _scrollListener() async {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() {
        isAtEndOfList = true;
      });
    }
  }

  int itemNumber = 0;

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;

    print('Status: $status');

    if (status.isDenied) {
      Permission.notification.request();
      Permission.accessNotificationPolicy.request();
      print('Status: $status');
    }

    if (status.isGranted) {
      // Permission granted, you can proceed with notification-related tasks
      print('Notification permission granted');
    } else {
      // Permission denied, handle accordingly
      print('Notification permission denied');
    }
  }

  Future<void> _requestLocationAndNotificationPermission() async {
    var locationStatus = await Permission.location.request();
    // var notificationStatus = await Permission.notification.request();

    if (locationStatus.isGranted) {
      _startLocationUpdates();
    } else if (locationStatus.isDenied) {
    } else if (locationStatus.isPermanentlyDenied) {}
  }

  late Timer timer;

  void _startLocationUpdates() async {
    await CurrentLocation();
    setLocation();
    timer = Timer.periodic(Duration(minutes: 3), (timer) {
      CurrentLocation();
      Future.delayed(Duration(seconds: 2), () {
        setLocation();
      });
    });
  }

  String? location1;
  String? location2;

  Future<void> CurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitude1 = position.latitude;
      double longitude1 = position.longitude;
      setState(() {
        location2 = longitude1.toString();
        location1 = latitude1.toString();
      });
      print(
          'Current location: latitude after setState: ${location1}, Longitude after setState ${location2}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  String role = "";

  final UserID = storage.read('user_id');

  Future<void> setLocation() async {
    final box = GetStorage();
    final token = box.read('token');

    final deviceName = box.read('deviceName');

    print('User Role is : $role');
    print('User id for locations : $UserID');
    print('User latitude is : $location1');
    print('User longitude is : $location2');
    print('Device Name is : $deviceName');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final LocationBaseUrl = configJson['planning_baseUrl'];
    final LocationApiKey = configJson['planning_apiKey'];

    final LocationMainUrl = LocationBaseUrl + "set/location";

    var headers = {
      'x-api-key': '$LocationApiKey',
      'Authorization': 'Bearer ' + token
    };

    print(
        'Data for API Body: $location1, $location2, $UserID, $role, $deviceName');

    var request = http.Request('POST', Uri.parse(LocationMainUrl));
    request.body = json.encode({
      "chauffeur-id": UserID.toString(),
      "role": role,
      "long": location2.toString(),
      "lat": location1.toString(),
      "userAgent": deviceName.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('Location is set after API');
    } else {
      print(response.reasonPhrase);
      print('Location is not set after API');
    }
  }

  void locationPermission() async {
    var status2 = await Permission.location.status;
    var status3 = await Permission.storage.status;
    var status4 = await Permission.notification.status;
    print('Location permission status: $status2');
    print('Storage permission status: $status3');
    print('Notification permission status: $status4');
    if (status2.isDenied) {
      Permission.location.request();
      print('permission : $status2');
    }
    //
    if (status4.isDenied) {
      Permission.notification.request();
      print('permission : $status3');
    }

    Permission.location.isDenied.then((value) => {
          if (value) {Permission.location.request()}
        });
    Permission.storage.isDenied.then((value) => {
          if (value) {Permission.storage.request()}
        });
  }

  Future<int> runFunctionBasedOnSdkVersion() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    print('Android Sdk Version: ${androidInfo.version.sdkInt}');
    return androidInfo.version.sdkInt;
  }

  void RequestNotificationPermission() async {
    int sdkVersion = await runFunctionBasedOnSdkVersion();
    if (sdkVersion <= 12) {
      var Status = await Permission.notification.status;
      if (Status.isDenied) {
        await Permission.notification.request();
      } else {
        Get.snackbar('Notification Permission Granted',
            'Your Android API is greater than 12 so Notification is always Allowed',
            backgroundColor: Colors.green);
      }
    } else {
      Get.snackbar('Notification Permission Granted',
          'Your Android API is greater than 12 so Notifications are always Allowed',
          backgroundColor: Colors.green);
    }
  }

  Future<void> setFCMToken() async {
    final box = GetStorage();
    final token = box.read('token');

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final deviceName = box.read('deviceName');

    final notificationToken = fcm.read('FCMToken');

    List<dynamic> userRoles = storage.read('user_roles') ?? [];

    if (userRoles.contains('ROLE_CHAUFFEUR')) {
      setState(() {
        role = "ROLE_CHAUFFEUR";
      });
    }

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final NotificationBaseUrl = configJson['planning_baseUrl'];
    final NotificationApiKey = configJson['planning_apiKey'];

    final NotificationMainUrl = NotificationBaseUrl + "notification/token";

    var headers = {
      'x-api-key': '$NotificationApiKey',
      'Authorization': 'Bearer ' + token
    };

    var request = http.Request('POST', Uri.parse(NotificationMainUrl));
    request.body = json.encode({
      "userID": UserID.toString(),
      "role": role.toString(),
      "token": notificationToken.toString(),
      "userAgent": deviceName.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('Notification token is set through API');
    } else {
      print(response.reasonPhrase);
      print('Notification token is not set through API');
    }
  }

  // DateTime? _lastTap;

  Widget _buildTextButton(String text, bool hovered) {
    return Container(
      height: 100,
      width: 200,
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

  Widget _buildIconButton(IconData icon, bool hovered) {
    return Container(
      height: 100,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[400],
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ]),
      child: Center(child: Icon(icon)),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this as BuildContext).removeCurrentSnackBar();
    ScaffoldMessenger.of(this as BuildContext).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
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

  String page = isPasser
      ? "Passer"
      : isAujoudHui
          ? "Today"
          : isAvenir
              ? "Future"
              : "";

  void clear() {
    if (isAujoudHui) {
      setState(() {
        appDriverToday.clear();
        isTodayDriverFiltered = false;
      });
    } else if (isPasser) {
      setState(() {
        appDriverPast.clear();
        isPastDriverFiltered = false;
      });
    } else if (isAvenir) {
      setState(() {
        appDriverAvenir.clear();
        isAvenirDriverFiltered = false;
      });
    } else {
      null;
    }
  }

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
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 185,
                      decoration: BoxDecoration(color: Color(0xFF3954A4)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Planning',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Profile()));
                                  },
                                  icon: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 405,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        bottomSheet1(context).then(
                                          (value) {
                                            if (value != null &&
                                                value.isNotEmpty) {
                                              setState(
                                                () {
                                                  selectedType = value;
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x3F000000),
                                                blurRadius: 4,
                                                offset: Offset(0, 0),
                                                spreadRadius: 0,
                                              )
                                            ]),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(width: 10),
                                              if (isTodayDriverFiltered ||
                                                  isPastDriverFiltered ||
                                                  isAvenirDriverFiltered)
                                                GestureDetector(
                                                  onTap: () {
                                                    DriverListFilter.clear();
                                                    tripListFuture();
                                                    tripListPresent();
                                                    tripListPast();
                                                    // clear();
                                                    isTodayDriverFiltered =
                                                        false;
                                                    isPastDriverFiltered =
                                                        false;
                                                    isAvenirDriverFiltered =
                                                        false;
                                                    selectedItems.clear();
                                                    appDriverToday.clear();
                                                    appDriverPast.clear();
                                                    appDriverAvenir.clear();
                                                    setState(() {
                                                      isRefreshed = true;
                                                      isFiltererd = false;
                                                      selectedItems.clear();

                                                      selectedType = '';
                                                      GetStorage box =
                                                          GetStorage();
                                                      if (box.hasData(
                                                          'filteredList')) {
                                                        box.remove(
                                                            'filteredList');
                                                      }
                                                      DriverListFilter.clear();
                                                    });
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 800),
                                                        () {
                                                      setState(() {
                                                        isRefreshed = false;
                                                      });
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/cross2.png',
                                                    color: Colors.red,
                                                    scale: 1.6,
                                                  ),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Text(
                                                  selectedItems.isNotEmpty
                                                      ? selectedItems.join(', ')
                                                      : _typeController
                                                              .text.isEmpty
                                                          ? 'Type'
                                                          : _typeController
                                                              .text,
                                                  style: TextStyle(
                                                    color: Color(0xFF524D4D),
                                                    fontSize: 14,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0.11,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final call =
                                            Uri.parse('tel: $hotlineNumber');
                                        if (await canLaunchUrl(call)) {
                                          launchUrl(call);
                                        } else {
                                          throw 'Could not launch $call';
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Center(
                                          child: Image.asset(
                                              'assets/images/phone.png'),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -12.5,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _changePasserContainerColor();
                                },
                                child: Container(
                                  width: 110,
                                  height: 43,
                                  decoration: BoxDecoration(
                                      color: passerContainerColor,
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
                                    child: Text(
                                      'Passer',
                                      style: TextStyle(
                                        color: passerTextColor,
                                        fontSize: 12,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _changeAujourdHuiContainerColor();
                                },
                                child: Container(
                                  width: 110,
                                  height: 43,
                                  decoration: BoxDecoration(
                                      color: aujourdhuiContainerColor,
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
                                    child: Text(
                                      "Aujourd'hui",
                                      style: TextStyle(
                                        color: aujurdHuiTextColor,
                                        fontSize: 12,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _changeAvenirContainerColor();
                                },
                                child: Container(
                                  width: 110,
                                  height: 43,
                                  decoration: BoxDecoration(
                                      color: avenirContainerColor,
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
                                    child: Text(
                                      "Avenir",
                                      style: TextStyle(
                                        color: avenirTextColor,
                                        fontSize: 12,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.11,
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 55,
              ),
              Expanded(
                child: isloading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3954A4),
                        ),
                      )
                    : isAujoudHui
                        ? (isTodayDriverFiltered)
                            ? DriverFilter(
                                data: DriverFilterToday,
                                screen: "Today",
                              )
                            : PresentList()
                        : isPasser
                            ? (isPastDriverFiltered)
                                ? DriverFilterPast(
                                    data: DriverFilterpast,
                                    screen: "Passer",
                                  )
                                : PastList()
                            : isAvenir
                                ? (isAvenirDriverFiltered)
                                    ? DriverFilterFuture(
                                        data: DriverFilterAvenir,
                                        screen: "Future",
                                      )
                                    : FutureList()
                                : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
