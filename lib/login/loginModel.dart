// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fr.innoyadev.mkgodev/Utility/bottomSheet.dart';
// import 'package:fr.innoyadev.mkgodev/homeScreen/homeScreen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
import 'package:fr.innoyadev.mkgodev/homeScreen/AdminPlanning.dart';
import 'package:fr.innoyadev.mkgodev/homeScreen/DriverPlanning.dart';
import 'package:fr.innoyadev.mkgodev/login/login.dart';
// import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/timezone.dart' as tz;

final box = GetStorage();

class LoginUser {
  String email;
  String password;

  LoginUser({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthController authController = Get.find();

  var data = {}.obs;

  List<dynamic> trips = [];
  List<dynamic> tripsPresent = [];
  List<dynamic> tripsFuture = [];
  List<dynamic> tripsAdminToday = [];
  List<dynamic> tripsAdminFuture = [];

  // GetStorage box = GetStorage();

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

      print('Chauffeur id for the specific trip: ${apiData['chauffeur']}');
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

      return [];
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> tripListFuture() async {
    // final box = GetStorage();
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
      // List<dynamic> tripFuture2 = box.read('future') ?? [];

      return [];
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> TripListToday() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    // final storage = GetStorage();

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

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final apiData = jsonDecode(responseBody);

      List<Map<String, dynamic>> AdminToday = [];
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
        String depart = courses['depart'];
        String arrive = courses['arrive'];

        int imgType = courses['clientDetails']['typeClient']['id'] ?? "";

        // print('Depart in admin list: $tarif');

        AdminToday.add({
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
          "driverPrenom": driverPrenom
        });
      }

      print(AdminToday);
      box.write('AdminToday5', AdminToday);
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
    // final storage = GetStorage();
    // final UserID = storage.read('user_id');

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
        // var affectationCourses = courses['affectationCourses'];
        String status1 = courses['affectationCourses'][0]['status1'];
        String status2 = courses['affectationCourses'][0]['status2'];
        String reference = courses['reference'];
        String backgroundColor = courses['backgroundColor'];
        String dateCourse = courses['dateCourse'];
        // String distanceTrajet = courses['distanceTrajet'];
        // String dureeTrajet = courses['dureeTrajet'];
        String nom = courses['clientDetails']['nom'];
        String prenom = courses['clientDetails']['prenom'];
        String telephone = courses['clientDetails']['tel1'];
        String driverNom = courses['chauffeurDetails']['nom'];
        String driverPrenom = courses['chauffeurDetails']['prenom'];
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
          'driverNom': driverNom,
          "driverPrenom": driverPrenom
        });
      }

      print('Admin AVenir with reference: $AdminAvenir');
      box.write('AdminAvenir5', AdminAvenir);

      return AdminAvenir;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  String today = "";
  String future = "";
  String passer = "";

  void loadInitialData() {
    print('loadmoredata fucntion is calling');

    trips = box.read('tripList') ?? [];
    tripsPresent = box.read('present') ?? [];
    tripsFuture = box.read('future') ?? [];
    tripsAdminToday = box.read('AdminToday5') ?? [];
    tripsAdminFuture = box.read('AdminAvenir5') ?? [];
    // filteredList = box.read('filteredListDriver');

    // print('Past Trips in loadmore : $trips');
  }

  Future<void> handleRefresh() async {
    await Future.delayed(Duration(milliseconds: 500), () {
      tripListPast();
      tripListPresent();
      tripListFuture();
      // loadInitialData();
      // filteredListDriver();
    });
  }

  Future<void> setFCMToken() async {
    final box = GetStorage();
    final fcm = GetStorage();
    final token = box.read('token');

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final notificationToken = fcm.read('FCMToken');

    List<dynamic> userRoles = storage.read('user_roles') ?? [];
    bool isChauffeur = userRoles.contains('ROLE_CHAUFFEUR');

    String role = "";

    if (isChauffeur) {
      role = 'ROLE_CHAUFFEUR';
      print('Role : $role');
    }

    final deviceName = box.read('deviceName');

    print('Device Name in fcm function: $deviceName');

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
        // Get.snackbar('Notification Permission Granted',
        //     'Your Android API is greater than 12 so Notification is always Allowed',
        //     backgroundColor: Colors.green);
      }
    } else {
      // Get.snackbar('Notification Permission Granted',
      //     'Your Android API is greater than 12 so Notifications are always Allowed',
      //     backgroundColor: Colors.green);
    }
  }

  // String deviceName = box.read('deviceName') ?? "";
  String role = "";
  // String mToken = box.read('FCMToken') ?? "";

  FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;

  Future<void> postFCMToken(String role) async {
    final token = box.read('token');

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    // List<dynamic> userRoles = storage.read('user_roles') ?? [];

    final Messagetoken = await getDeviceToken();
    final deviceName = await getDeviceName();

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final NotificationBaseUrl = configJson['planning_baseUrl'];
    final NotificationApiKey = configJson['planning_apiKey'];

    final NotificationToken = NotificationBaseUrl + "notification/token";

    var headers = {
      'x-api-key': '$NotificationApiKey',
      'Authorization': 'Bearer ' + token
    };

    print('Data for API Body: $Messagetoken, $UserID, $role, $deviceName');

    var request = http.Request('POST', Uri.parse(NotificationToken));
    request.body = json.encode({
      "userID": UserID.toString(),
      "role": role,
      "token": Messagetoken,
      "userAgent": deviceName
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('Data for API Body: $Messagetoken, $UserID, $role, $deviceName');

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('Token is set after API with data body');
    } else {
      print(response.reasonPhrase);
      print('Token is not set after API');
    }
  }

  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      box.write('deviceName', androidInfo.model);

      print('Device Name:- ${androidInfo.model}');

      return androidInfo.model;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      box.write('deviceName', iosInfo.model);
      print('Device Name:- ${iosInfo.model}');

      return iosInfo.model;
    }
    return "";
  }

  GetStorage fcm = GetStorage();
  Future getDeviceToken() async {
    String? deviceToken = await _firebaseMessage.getToken();

    box.write('FCMToken', deviceToken);
    return (deviceToken == null) ? "" : deviceToken;
  }

  void locationPermission() async {
    var status2 = await Permission.location.status;
    var status3 = await Permission.storage.status;

    print("Location Permission Status: $status2");

    if (status2.isDenied) {
      await Permission.location.request();
      print('permission in admin Plamning screen for login : $status2');
    }
    if (status3.isDenied) {
      await Permission.storage.request();
      print('permission for storage : $status2');
    }
  }

  Future<void> login(BuildContext context) async {
    final box = GetStorage();
    final Storagepassword = box.write(
      'password',
      passwordController.text,
    );
    print('Password in Storage : $Storagepassword');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionAuthUrl = gestionBaseUrl + "mob/auth";

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse(gestionAuthUrl));
    request.body = json.encode(
        {"email": emailController.text, "password": passwordController.text});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (box.hasData('tripList') ||
          box.hasData('present') ||
          box.hasData('future')) {
        print('if chal rha hia idhar');
        trips.clear();
        tripsPresent.clear();
        tripsFuture.clear();
        // box.write('tripList', []);
        // box.write('present', []);
        // box.write('future', []);
        print('Data is clear at login : $trips');
        print('Data is clear at login : $tripsPresent');
        print('Data is clear at login : $tripsFuture');
      }
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);

      if (responseJson.containsKey('token')) {
        final token = responseJson['token'];
        box.write('splashToken', token);
        Get.find<AuthController>().setToken(token);

        // Save user credentials in shared preferences
        saveUserCredentials(responseJson);

        print('Generated Token is set: $token');
      } else {
        print('Token not found in the response');
      }

      if (responseJson.containsKey('user')) {
        final userJson = responseJson['user'];
        final user = UserModel(
            id: userJson['id'],
            nom: userJson['nom'],
            prenom: userJson['prenom'],
            email: userJson['email'],
            telephone: userJson['telephone'],
            address: userJson['adresse'],
            roles: List<String>.from(userJson['roles']),
            date: userJson['dateNaissance'],
            employeId: userJson['typeEmploye'] != null
                ? userJson['typeEmploye']['id']
                : 0,
            region: userJson['region'] != null ? userJson['region']['id'] : 0);

        Get.find<UserController>().setUser(user);
        print(
            "User Data: ${user.id}, ${user.nom}, ${user.prenom}, ${user.email}, ${user.roles}, ${user.address}, ${user.date}, ${user.employeId}, ${user.region}");

        if (user.roles.contains('ROLE_CHAUFFEUR')) {
          Future.delayed(Duration(milliseconds: 500), () {
            runFunctionBasedOnSdkVersion().whenComplete(() {
              RequestNotificationPermission();
              // postFCMToken();
            });
            // locationPermission();

            getDeviceName().whenComplete(() {
              getDeviceToken().whenComplete(() {
                postFCMToken("ROLE_CHAUFFEUR").whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LandingScreen2()));
                });
              });
            });
          });
        }
        if (user.roles.contains('ROLE_ADMIN')) {
          loadInitialData();
          TripListFutureAdmin();
          TripListToday();
          // getDeviceName(context);
          // setFCMToken();

          runFunctionBasedOnSdkVersion().whenComplete(() {
            RequestNotificationPermission();
          });
          getDeviceName().whenComplete(() {
            getDeviceToken().whenComplete(() {
              postFCMToken("ROLE_ADMIN").whenComplete(() {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LandingScreen1()));
              });
            });
          });
        }
      } else {
        print('User data not found in the response');
      }
    } else {
      print(response.reasonPhrase);
      Get.snackbar(
        colorText: Colors.white,
        'Error',
        'Login failed',
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
          'Login failed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );
    }
  }

  // Save user credentials in shared preferences
  void saveUserCredentials(Map<String, dynamic> responseJson) {
    final storage = GetStorage();

    final userJson = responseJson['user'];
    final user = UserModel(
        id: userJson['id'],
        nom: userJson['nom'],
        prenom: userJson['prenom'],
        email: userJson['email'],
        telephone: userJson['telephone'],
        address: userJson['adresse'],
        roles: List<String>.from(userJson['roles']),
        date: userJson['dateNaissance'],
        employeId:
            userJson['typeEmploye'] != null ? userJson['typeEmploye']['id'] : 0,
        region: userJson['region'] != null ? userJson['region']['id'] : 0);

    storage.write('user_id', user.id);
    box.write('splash_user_id', user.id);
    storage.write('user_nom', user.nom);
    box.write('splash_user_nom', user.nom);
    storage.write('user_prenom', user.prenom);
    box.write('splash_user_prenom', user.prenom);
    storage.write('user_email', user.email);
    storage.write('user_roles', user.roles);
    box.write('splash_user_roles', user.roles);
    storage.write('user_telephone', user.telephone);
    storage.write('user_adresse', user.address);
    storage.write('user_DOB', user.date);
    storage.write('user_employe_Id', user.employeId);
    storage.write('user_region_Id', user.region);
  }
}

class AuthController extends GetxController {
  final box = GetStorage();
  RxString token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    token.value = box.read('token') ?? '';
  }

  void setToken(String newToken) {
    token.value = newToken;
    box.write('token', newToken);
    print('Token is set in Get Storage : $newToken');
  }

  void logout() {
    // Clear the token and user data when logging out
    token.value = '';
    GetStorage().erase();
    box.remove('token');
    box.remove('splashToken');
    box.remove('splashToken');
    box.remove('splash_user_id');
    box.remove('splash_user_nom');
    box.remove('splash_user_prenom');
    box.remove('splash_user_roles');
    GetStorage().erase();
    Get.find<UserController>().setUser(UserModel(
        id: 0,
        nom: '',
        prenom: '',
        email: '',
        telephone: '',
        address: '',
        roles: [],
        date: '',
        employeId: 0,
        region: 0));
    // You may also need to clear any other user-related data or perform additional cleanup
    // box.write('filteredListDriver', []);
    // box.write('tripList', []);
    // box.write('present', []);
    // box.write('future', []);
    // Navigate to the login screen
    Get.offAll(loginScreen());
  }
}

class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String address;
  final List<String> roles;
  final String date;
  final int employeId;
  final int region;

  UserModel(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.email,
      required this.telephone,
      required this.address,
      required this.roles,
      required this.date,
      required this.employeId,
      required this.region});
}

class UserController extends GetxController {
  Rx<UserModel> user = UserModel(
          id: 0,
          nom: '',
          prenom: '',
          email: '',
          telephone: '',
          address: '',
          roles: [],
          date: '',
          employeId: 0,
          region: 0)
      .obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }

  void loadUserFromStorage() {
    final storage = GetStorage();

    final newUser = UserModel(
      id: storage.read('user_id') ?? 0,
      nom: storage.read('user_nom') ?? '',
      prenom: storage.read('user_prenom') ?? '',
      email: storage.read('user_email') ?? '',
      telephone: storage.read('user_telephone') ?? '',
      address: storage.read('user_adresse') ?? '',
      roles: List<String>.from(storage.read('user_roles') ?? []),
      date: storage.read('user_DOB') ?? '',
      employeId: storage.read('user_employe_Id') ?? 0,
      region: storage.read('user_region_Id') ?? 0,
    );

    setUser(newUser);
  }

  void setUser(UserModel newUser) {
    user.value = newUser;
  }
}
