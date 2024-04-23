// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fr.innoyadev.mkgodev/homeScreen/AdminPlanning.dart';
import 'package:fr.innoyadev.mkgodev/homeScreen/DriverPlanning.dart';
import 'package:fr.innoyadev.mkgodev/tripDetails/webview.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:map_launcher/map_launcher.dart';
// import 'package:fr.innoyadev.mkgodev/tripDetails/route.dart';
// import 'package:fr.innoyadev.mkgodev/tripDetails/tripLocation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

GetStorage storage = GetStorage();
List<dynamic> userRoles = storage.read('user_roles') ?? [];

class TripDetails extends StatefulWidget {
  final String id;

  final String? Screen;
  TripDetails({super.key, this.Screen, required this.id});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  List<Map<String, dynamic>> tripsPresent = [];
  List<Map<String, dynamic>> tripsFuture = [];

  // String id = Get.arguments[0].toString();

  bool isRefreshed = false;

  String name = "";
  String surname = "";
  String chauffeur = "";
  String bkgColor = "";

  String M = " ";

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

      print(apiData);

      List<Map<String, dynamic>> tripPresentAPI = [];
      for (var courses in apiData['courses']) {
        int id = courses['id'];
        // String start = courses['start'];
        int nombrePassager = courses['nombrePassager'];
        String commentaire = courses['commentaire'];
        String paiement = courses['paiement'];
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
        });
      }

      // print(tripPresent);
      box.write('present', tripPresentAPI);
      setState(() {
        tripsPresent = tripPresentAPI;
      });

      return [];
    } else {
      print(response.reasonPhrase);
    }
    return [];
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
        });
      }

      // print(tripFuture);
      box.write('future', tripFutureAPI);
      // List<dynamic> tripFuture2 = box.read('future') ?? [];
      setState(() {
        tripsFuture = tripFutureAPI;
      });

      return [];
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  // late GoogleMapController _controller;
  // final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    configData();
    decoding();

    setState(() {
      isRefreshed = true;
    });

    print('Coming Screen: ${widget.Screen}');

    tripDetails();
    if (widget.Screen == "panier") {
      setState(() {
        status = "Refuser";
      });
    }
  }

  bool isChauffeur = userRoles.contains('ROLE_CHAUFFEUR');
  bool isAdmin = userRoles.contains('ROLE_ADMIN');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('before function');

    print('after function');
  }

  List<dynamic> mainTripDetails = [];

  String comment = "";
  String payment = "";
  String referenceNumber = "";
  String address1 = "";
  String address2 = "";
  String file1 = "";
  String file2 = "";
  String telephoneNumber = "";
  String distance = '';
  String time = '';
  String WebFile1 = "";
  String WebFile2 = "";
  String Status1 = "";
  String Status2 = "";

  String dataUrl = "";

  Future<void> configData() async {
    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    dataUrl = configJson['webView_baseURL']; // Corrected the assignment

    print('object');
    // Assuming you intended to update dataUrl
    setState(() {
      dataUrl = configJson['webView_baseURL'];
    });

    print('Config Url: $dataUrl');
  }

     void decoding() {
    String base64File1 = base64Encode(utf8.encode(file1));
    String base64File2 = base64Encode(utf8.encode(file2));

    setState(() {
      WebFile1 = base64File1;
      WebFile2 = base64File2;
      BaseUrl1 = "$dataUrl$WebFile1";
      BaseUrl2 = "$dataUrl$WebFile2";
    });

    print('Url1 after decoding: $BaseUrl1');
    print('Url2 after decoding: $BaseUrl2');
  }

  String BaseUrl1 = "";
  String BaseUrl2 = "";
  double latitude1 = 0.00;
  double longitude1 = 0.00;
  double latitude2 = 0.00;
  double longitude2 = 0.00;

  Future<Map<String, double>> addressToCoordinates1(String address) async {
    print('inside the function');
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;

        setState(() {
          latitude1 = latitude;
          longitude1 = longitude;
        });

        print('Latitude1: $latitude1');
        print('longitude1: $longitude1');
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        throw Exception("No coordinates found for the given address");
      }
    } catch (e) {
      print("Error converting address to coordinates: $e");
      rethrow;
    }
  }

  Future<Map<String, double>> addressToCoordinates2(String address) async {
    print('inside the function');

    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;

        setState(() {
          latitude2 = latitude;
          longitude2 = longitude;
        });

        print('Latitude2: $latitude2');
        print('longitude2: $longitude2');
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        throw Exception("No coordinates found for the given address");
      }
    } catch (e) {
      print("Error converting address to coordinates: $e");
      rethrow;
    }
  }

  Future<List<Map<String, String>>> tripDetails() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "mob/detailscourse/" + widget.id;

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

      print('File Name 1 from API :${apiData["filename1"]}');
      print('File Name 2 from API :${apiData["filename2"]}');

      String status1 = "";
      String status2 = "";

      // Initialize maxId to the smallest possible integer value
      int maxId = 0;

      // Iterate over 'affectationCourses' to find the entry with the highest ID
      for (var affectation in apiData['affectationCourses']) {
        int affectationId = affectation['id'];
        if (affectationId > maxId) {
          maxId = affectationId;
          status1 = affectation['status1'];
          status2 = affectation['status2'];
          print('Affectation course highest id: $maxId');
        }
      }

      setState(() {
        if (widget.Screen == "panier" || widget.Screen == "admin") {
          referenceNumber = apiData['reference'];
          comment = apiData['commentaire'];
          payment = apiData['paiement'];
          address1 = apiData['depart'];
          address2 = apiData['arrive'];
          file1 = apiData['filename1'];
          file2 = apiData['filename2'];
          telephoneNumber = apiData['clientDetails']['tel1'];
          distance = apiData['distanceTrajet'];
          time = apiData['dureeTrajet'];
          Status1 = status1;
          Status2 = status2;
          // Status2 = apiData['affectationCourses'][0]['status2'];
          chauffeur = apiData['modifiePar'] ?? '';
          bkgColor = apiData['backgroundColor'] ?? '';
        } else {
          name = apiData['chauffeurDetails']['nom'] ?? "";
          surname = apiData['chauffeurDetails']['prenom'] ?? "";
          referenceNumber = apiData['reference'];
          comment = apiData['commentaire'];
          payment = apiData['paiement'];
          address1 = apiData['depart'];
          address2 = apiData['arrive'];
          file1 = apiData['filename1'];
          file2 = apiData['filename2'];
          telephoneNumber = apiData['clientDetails']['tel1'];
          distance = apiData['distanceTrajet'];
          time = apiData['dureeTrajet'];
          Status1 = status1;
          Status2 = status2;
          // Status2 = apiData['affectationCourses'][0]['status2'];
          chauffeur = apiData['modifiePar'] ?? '';
          bkgColor = apiData['backgroundColor'] ?? '';
        }
      });

      addressToCoordinates1(address1);
      addressToCoordinates2(address2);

      print("File Name !:$file1");

      decoding();

      List<Map<String, String>> tripDetailsList = [];

      int id = apiData['id'];
      int nombrePassager = apiData['nombrePassager'];
      String commentaire = apiData['commentaire'];
      String paiement = apiData['paiement'];
      int client = apiData['client'];
      String reference = apiData['reference'];
      // String referencefinal = apiData['reference'];
      // String reference = apiData['reference'];
      // String status1 = apiData['affectationCourses'][0]['status1'];
      // String status2 = apiData['affectationCourses'][0]['status2'];
      String backgroundColor = apiData['backgroundColor'];
      String dateCourse = apiData['dateCourse'];
      String distanceTrajet = apiData['distanceTrajet'];
      String dureeTrajet = apiData['dureeTrajet'];
      String nom = apiData['clientDetails']['nom'];
      String prenom = apiData['clientDetails']['prenom'];
      String telephone = apiData['clientDetails']['tel1'];
      String depart = apiData['depart'] ?? '';
      String arrive = apiData['arrive'] ?? '';

      int imgType = apiData['clientDetails']['typeClient']['id'] ?? "";

      // Create a map with the extracted values
      Map<String, String> tripDetails = {
        'id': id.toString(),
        'nombrePassager': nombrePassager.toString(),
        'commentaire': commentaire,
        'paiement': paiement,
        'client': client.toString(),
        'refernce': reference,
        'status1': status1,
        'status2': status2,
        'backgroundColor': backgroundColor,
        'dateCourse': dateCourse,
        'distanceTrajet': distanceTrajet,
        'dureeTrajet': dureeTrajet,
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'depart': depart,
        'arrive': arrive,
        "chauffeur": chauffeur,
        'imgType': imgType.toString(),
      };

      tripDetailsList.add(tripDetails);

      print('Data of the trip: $tripDetails');

      print('Status1 : $status1 & Status1 : $status2');

      tripListPresent();
      tripListFuture();

      setState(() {
        mainTripDetails = tripDetailsList;
        isRefreshed = false;
      });
      return tripDetailsList;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  String status = "";

  Future<dynamic> acceptTrip(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    // print("Statues :${Status1}, ${Status2}, ${bkgColor}");
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
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                // height: MediaQuery.of(context).size.height / 2,
                height: currentWidth <= 360
                    ? MediaQuery.of(context).size.height / 1.75
                    : MediaQuery.of(context).size.height / 3,
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
                              'Status',
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
                      Container(
                        color: Color(0xFFE6F7FD),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Flexible(
                              child: RadioListTile(
                                title: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        status = "Accepte";
                                      });
                                    },
                                    child: Text(
                                      'Accepte',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                value: "Accepte",
                                groupValue: status,
                                onChanged: (value) {
                                  setState(() {
                                    status = value.toString();
                                  });
                                },
                              ),
                            ),
                            (widget.Screen != "panier")
                                ? Flexible(
                                    child: RadioListTile(
                                      title: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            accpeted = "Refuse";
                                            print('Trip Status: $accpeted');
                                          });
                                          await clientAbsentBottomSheet();
                                        },
                                        child: Text(
                                          'Refuser',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      value: "Refuser",
                                      groupValue: status,
                                      onChanged: (value) async {
                                        setState(() {
                                          status = value.toString();

                                          accpeted = "Refuse";

                                          print('Trip Status: $accpeted');
                                        });
                                        await clientAbsentBottomSheet();
                                      },
                                    ),
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          print(
                              '==================================================');
                          setState(() {
                            isRefreshed = true;
                          });
                          updateTripStatus();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 333,
                          height: 49,
                          decoration: ShapeDecoration(
                            color: Color(0xFF3556A7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            shadows: [
                              BoxShadow(
                                color: Color(0x07000000),
                                blurRadius: 10,
                                offset: Offset(0, 0),
                                spreadRadius: 8,
                              )
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                'Valider',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  height: 0.04,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    )..whenComplete(() => setState(() {
          // isRefreshed = true;
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              isRefreshed = false;
            });
          });
        }));
  }

  Future<dynamic> openAccepterBottomSheet(
      BuildContext context, String status1, String status2) {
    final currentWidth = MediaQuery.of(context).size.width;

    switch ("$status1-$status2") {
      case "1-0":
        acceptedStatus = "Accepte";
        break;
      case "1-1":
        acceptedStatus = "En route";
        break;
      case "1-2":
        acceptedStatus = "Sur place";
        break;
      case "1-3":
        acceptedStatus = "Client absent";
        break;
      case "1-4":
        acceptedStatus = "Terminee";
        break;
      case "1-5":
        acceptedStatus = "Client abord";
        break;
      case "3-6":
        acceptedStatus = "Cancelled";
        break;
      default:
        acceptedStatus = "En Attente";
        break;
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
        return StatefulBuilder(
          builder: (
            context,
            setState,
          ) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the bottom sheet if needed

                setState(() {
                  status = "";
                  acceptedStatus = "";
                });
              },
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SizedBox(
                  height: currentWidth <= 360
                      ? MediaQuery.of(context).size.height / 1.25
                      : MediaQuery.of(context).size.height / 1.5,
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
                                'Status',
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
                        RadioListTile(
                          title: Text('En Route'),
                          value: "En route",
                          groupValue: acceptedStatus,
                          onChanged: (value) {
                            setState(() {
                              acceptedStatus = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Sur Place'),
                          value: "Sur place",
                          groupValue: acceptedStatus,
                          onChanged: (value) {
                            setState(() {
                              acceptedStatus = value.toString();
                              print(
                                  'Second Status after accepted: $acceptedStatus');
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Client Abord'),
                          value: "Client abord",
                          groupValue: acceptedStatus,
                          onChanged: (value) {
                            setState(() {
                              acceptedStatus = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Absent + Displacement'),
                          value: "Client absent",
                          groupValue: acceptedStatus,
                          onChanged: (value) {
                            setState(() {
                              acceptedStatus = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Terminer'),
                          value: "Terminee",
                          groupValue: acceptedStatus,
                          onChanged: (value) {
                            setState(() {
                              acceptedStatus = value.toString();
                            });
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isRefreshed = true;
                              print('Accpeted Status: $acceptedStatus');
                            });
                            updateTripStatus2().whenComplete(() {
                              tripDetails();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 333,
                            height: 49,
                            decoration: ShapeDecoration(
                              color: Color(0xFF3556A7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x07000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 0),
                                  spreadRadius: 8,
                                )
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  'Valider',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w500,
                                    height: 0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() => setState(() {
          isRefreshed = true;
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              isRefreshed = false;
            });
          });
        }));
  }

  Color _getStatusColor(String status1, String status2) {
    switch ("$status1-$status2") {
      case '1-1':
        return HexColor('#bbacac');
      case '0-0':
        return HexColor('#f17407');
      case '1-2':
        return Colors.yellow.shade600;
      case '1-5':
        return HexColor('#0F056B');
      case '1-3':
        return HexColor('#fd6c9e');
      case '1-4':
        return HexColor('#811453');
      case '1-6':
        return HexColor('#E21313');
      case '1-0':
        return HexColor('#0AAF20');
      case '3-6':
        return HexColor("#000000");
      case '2-0':
        return HexColor("#000000");
      default:
        return Color(0xFF135DB9);
    }
  }

  String getStatusText(String status1, String status2) {
    String statusText = "No Status Available"; // Assign an initial value

    switch ("$status1-$status2") {
      case "0-0":
        statusText = "En Attente";
        break;
      case "1-0":
        statusText = "Accepter";
        break;
      case "1-1":
        statusText = "En Route";
        break;
      case "1-2":
        statusText = "Sur Place";
        break;
      case "1-3":
        statusText = "Absent + Displacement";
        break;
      case "1-4":
        statusText = "Terminé";
        break;
      case "1-5":
        statusText = "Abord";
        break;
      case "1-6":
        statusText = "Client Absent";
        break;
      case "3-6":
        statusText = "Cancelled";
        break;
      case "2-0":
        statusText = "Refuse";
        break;
      default:
        break;
    }

    return statusText;
  }

  Image? getImageBasedOnType(String imgType) {
    switch (imgType) {
      case "1":
        return Image.asset(
          'assets/images/taxi.png',
          scale: 2,
          filterQuality: FilterQuality.high,
        );
      case "2":
        return Image.asset(
          'assets/images/ambulance.png',
          scale: 2,
          filterQuality: FilterQuality.high,
        );
      case "3":
        return Image.asset(
          'assets/images/school.png',
          scale: 2,
          filterQuality: FilterQuality.high,
        );
      default:
        return null;
    }
  }

  Future<void> updateTripStatus() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "mob/course-accepte-refuse/" + widget.id;

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode({
      "etat": status,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      Get.snackbar(
        colorText: Colors.white,
        'Success',
        'Trip is Accepted',
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
          'Trip is Accepted',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );
      tripDetails();

      Get.to(() => TripDetails(
            id: widget.id,
          ));

      setState(() {
        isRefreshed = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  String acceptedStatus = "";

  Future<void> updateTripStatus2() async {
    print('Trip Status for phase 2 trip status management: $acceptedStatus');

    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "mob/course-etat/" + widget.id.toString();

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode({
      "etat2": acceptedStatus,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      // _fetchAdminData();

      Get.snackbar(
        colorText: Colors.white,
        'Success',
        'Trip is Updated',
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
          'Trip is Updated',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );

      setState(() {
        isRefreshed = false;
      });
      tripDetails();

      // Navigator.of(context).pop();
    } else {
      print(response.reasonPhrase);
      setState(() {
        isRefreshed = false;
      });
    }
  }

  void loadInitialData() {
    print('loadmoredata fucntion is calling');

    tripDetails();
    tripListPresent();
    tripListFuture();

    setState(() {
      tripsPresent = tripsPresent.toList();
      tripsFuture = tripsFuture.toList();
    });
  }

  Future<void> handleRefresh() async {
    setState(() {
      isRefreshed = true;
    });
    await Future.delayed(Duration(milliseconds: 600), () {
      // tripListPast();
      // tripListPresent();
      // tripListFuture();
      // loadInitialData();
      tripDetails();
      // filteredListDriver();
      setState(() {
        isRefreshed = false;
      });
    });
  }

  String accpeted = "";

  TextEditingController reassgin = TextEditingController();

  Future<void> updateTripStatus3() async {
    print('Accpedt status for API: $accpeted');

    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "mob/course-accepte-refuse/" + widget.id;

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode({"etat": accpeted, "motifRefus": reassgin.text});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      Get.snackbar(
        colorText: Colors.white,
        'Success',
        'Trip is Rejected',
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
          'Trip is Rejected',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );

      // Navigator.of(context).pop();

      tripDetails();

      // tripDetails();
      print("==================After API for trip management");
      tripListPresent();
      print("==================After API for trip management");
      Navigator.of(context).pop();
      (widget.Screen == "Admin")
          ? Get.to(() => LandingScreen1())
          : Get.to(() => LandingScreen2());

      setState(() {
        isRefreshed = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> clientAbsentBottomSheet() {
    final currentWidth = MediaQuery.of(context).size.width;

    GlobalKey<FormState> key = GlobalKey<FormState>();

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
              height: currentWidth <= 360
                  ? MediaQuery.of(context).size.height / 2.45
                  : MediaQuery.of(context).size.height / 3.75,
              child: Center(
                child: Form(
                  key: key,
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
                              'Refuser Une Course',
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
                            controller: reassgin,
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
                                  if (key.currentState!.validate()) {
                                    print('Comment not entered');
                                    updateTripStatus3();
                                    Navigator.of(context).pop();
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
        }).whenComplete(() {
      setState(() {
        Navigator.pop(context);
        status = '';
      });
      // setState(() {
      //   isRefreshed = true;
      // });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          isRefreshed = false;
        });
      });
    });
  }

  Future<Coords> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return Coords(position.latitude, position.longitude);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void showMapDialog(
      BuildContext context, double latitude, double longitude) async {
    final availableMaps = await MapLauncher.installedMaps;

    Coords currentLocation = await getCurrentLocation();

    print('Latitude1: $latitude');
    print('longitude1: $longitude');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFE6F7FD),
            borderRadius: BorderRadius.circular(16.0),
          ),
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: availableMaps.length,
                itemBuilder: (context, index) {
                  final map = availableMaps[index];
                  return Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Available Map Options',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.black,
                        height: 1,
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 50,
                          width: 50,
                        ),
                        title: Text(
                          map.mapName,
                          style: TextStyle(
                            color: Color(0xFF6E6868),
                            fontSize: 22,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        onTap: () async {
                          await map.showDirections(
                            directionsMode: DirectionsMode.driving,
                            origin: currentLocation,
                            destination: Coords(latitude, longitude),
                          );

                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 333,
                  height: 49,
                  decoration: ShapeDecoration(
                    color: Color(0xFF3556A7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x07000000),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                        spreadRadius: 8,
                      )
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                          height: 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showMapBottomSheet2(
      BuildContext context,
      double originLatitude,
      double originLongitude,
      double destinationLatitude,
      double destinationLongitude) async {
    final availableMaps = await MapLauncher.installedMaps;

    // Coords currentLocation = await getCurrentLocation();

    print('Latitude1: $originLatitude');
    print('longitude1: $originLongitude');
    print('Latitude1: $destinationLatitude');
    print('longitude1: $destinationLongitude');

    addressToCoordinates1(address1).whenComplete(() {
      addressToCoordinates2(address2).whenComplete(() {
        Get.back();
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFE6F7FD),
                borderRadius: BorderRadius.circular(16.0),
              ),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Available Map Options',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableMaps.length,
                      itemBuilder: (context, index) {
                        final map = availableMaps[index];
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            ListTile(
                              leading: SvgPicture.asset(
                                map.icon,
                                height: 50,
                                width: 50,
                              ),
                              title: Text(
                                map.mapName,
                                style: TextStyle(
                                  color: Color(0xFF6E6868),
                                  fontSize: 22,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              onTap: () async {
                                await map.showDirections(
                                  directionsMode: DirectionsMode.driving,
                                  origin:
                                      Coords(originLatitude, originLongitude),
                                  destination: Coords(destinationLatitude,
                                      destinationLongitude),
                                );

                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 333,
                      height: 42,
                      decoration: ShapeDecoration(
                        color: Color(0xFF3556A7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x07000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 8,
                          )
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  Future<void> showMapDialog1(BuildContext context, String address) async {
    // Get.back();

    final availableMaps = await MapLauncher.installedMaps;

    Coords currentLocation = await getCurrentLocation();

    addressToCoordinates1(address).whenComplete(
      () {
        Get.back();
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFE6F7FD),
                borderRadius: BorderRadius.circular(16.0),
              ),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Available Map Options',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableMaps.length,
                      itemBuilder: (context, index) {
                        final map = availableMaps[index];
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            ListTile(
                              leading: SvgPicture.asset(
                                map.icon,
                                height: 50,
                                width: 50,
                              ),
                              title: Text(
                                map.mapName,
                                style: TextStyle(
                                  color: Color(0xFF6E6868),
                                  fontSize: 22,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              onTap: () async {
                                await map.showDirections(
                                  directionsMode: DirectionsMode.driving,
                                  origin: currentLocation,
                                  destination: Coords(latitude1, longitude1),
                                );

                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 333,
                      height: 42,
                      decoration: ShapeDecoration(
                        color: Color(0xFF3556A7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x07000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 8,
                          )
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showMapDialog2(BuildContext context, String address) async {
    // Get.back();

    final availableMaps = await MapLauncher.installedMaps;

    Coords currentLocation = await getCurrentLocation();

    addressToCoordinates2(address).whenComplete(
      () {
        Get.back();
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFE6F7FD),
                borderRadius: BorderRadius.circular(16.0),
              ),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Available Map Options',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableMaps.length,
                      itemBuilder: (context, index) {
                        final map = availableMaps[index];
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            ListTile(
                              leading: SvgPicture.asset(
                                map.icon,
                                height: 50,
                                width: 50,
                              ),
                              title: Text(
                                map.mapName,
                                style: TextStyle(
                                  color: Color(0xFF6E6868),
                                  fontSize: 22,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              onTap: () async {
                                await map.showDirections(
                                  directionsMode: DirectionsMode.driving,
                                  origin: currentLocation,
                                  destination: Coords(latitude2, longitude2),
                                );

                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 333,
                      height: 42,
                      decoration: ShapeDecoration(
                        color: Color(0xFF3556A7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x07000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 8,
                          )
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final storage = GetStorage();

    // String statusText = getStatusText(Status1, Status2);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 0, top: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color(0xFF3954A4),
                  ),
                )
              ],
            ),
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height / 35,
          // ),
          isRefreshed
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Color(0xFF3954A4),
                  ))
              : Expanded(
                  child: LiquidPullToRefresh(
                    backgroundColor: Color(0xFF3954A4),
                    height: 80,
                    animSpeedFactor: 2,
                    showChildOpacityTransition: false,
                    color: Colors.white,
                    onRefresh: handleRefresh,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.of(context).size.width / 1.12,
                              height: 170,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: isRefreshed
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: Color(0xFF3954A4),
                                    ))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: mainTripDetails.length,
                                      itemBuilder: (context, index) {
                                        final item = mainTripDetails[index];
                                        // String Status1 = item['status1'];
                                        // String Status2 = item['status2'];

                                        print('Status1 : $Status1');
                                        print('Status2 : $Status2');
                                        String imgType =
                                            item['imgType'].toString();
                                        String date = item['dateCourse'];
                                        String borderColor =
                                            item['backgroundColor'];
                                        print(
                                            'Background color from the list: $borderColor');
                                        DateTime dateTime =
                                            DateTime.parse(date);
                                        tz.TZDateTime parisDateTime =
                                            tz.TZDateTime.from(dateTime,
                                                tz.getLocation('Europe/Paris'));

                                        String formattedDate =
                                            DateFormat("dd.MMM.yyyy HH:mm")
                                                .format(parisDateTime);
                                        return Column(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${item['nom']}\n${item['prenom']}",
                                                    // '$nom $prenom',
                                                    style: TextStyle(
                                                      color: Color(0xFF524D4D),
                                                      fontSize: 15,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  Text(
                                                    formattedDate,
                                                    style: TextStyle(
                                                      color: Color(0xFF524D4D),
                                                      fontSize: 15,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.zero,
                                                    width: 40,
                                                    height: 40,
                                                    decoration: ShapeDecoration(
                                                      color: Colors.white,
                                                      shape: OvalBorder(),
                                                      shadows: [
                                                        BoxShadow(
                                                          color:
                                                              Color(0x3F000000),
                                                          blurRadius: 4,
                                                          offset: Offset(0, 0),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                    child: getImageBasedOnType(
                                                        imgType),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (!isAdmin) {
                                                        if (acceptedStatus !=
                                                                "Terminee" &&
                                                            acceptedStatus !=
                                                                "Client absent") {
                                                          if (widget.Screen ==
                                                                  "Passer" ||
                                                              widget.Screen ==
                                                                  "pastfilter") {
                                                            null;
                                                          } else if ((Status1 ==
                                                                      "1" &&
                                                                  Status2 ==
                                                                      "0") &&
                                                              (widget.Screen ==
                                                                      "avenir" ||
                                                                  widget.Screen ==
                                                                      "futureFilter")) {
                                                            null;
                                                          } else if ((Status1 ==
                                                                      "1" &&
                                                                  Status2 ==
                                                                      "3") &&
                                                              (Status1 == "1" &&
                                                                  Status2 ==
                                                                      "4")) {
                                                            null;
                                                          } else if (Status1 ==
                                                                  "0" &&
                                                              Status2 == "0") {
                                                            acceptTrip(context);
                                                          } else if (widget
                                                                  .Screen ==
                                                              "panier") {
                                                            acceptTrip(context);
                                                          } else if ((widget
                                                                      .Screen ==
                                                                  "panier") &&
                                                              (Status1 == "2" &&
                                                                  Status2 ==
                                                                      "0")) {
                                                            null;
                                                          } else if (Status1 ==
                                                                  "2" &&
                                                              Status2 == "0") {
                                                            acceptTrip(context);
                                                          } else {
                                                            openAccepterBottomSheet(
                                                                context,
                                                                Status1,
                                                                Status2);
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      // width: 220,
                                                      height: 24,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: _getStatusColor(
                                                            Status1, Status2),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                        child: Center(
                                                          child: Text(
                                                            getStatusText(
                                                                Status1,
                                                                Status2),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Kanit',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 15),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        print(
                                                            'telephone Number: $telephoneNumber');
                                                        final call = Uri.parse(
                                                            'tel: $telephoneNumber');
                                                        if (await canLaunchUrl(
                                                            call)) {
                                                          launchUrl(call);
                                                        } else {
                                                          throw 'Could not launch $call';
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 50,
                                                        height: 34,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color:
                                                              Color(0xFFECF4FF),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                        child: Icon(
                                                          Icons.phone,
                                                          size: 20,
                                                          color:
                                                              Color(0xFF135DB9),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        Get.dialog(
                                                            Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color: Color(
                                                                  0xFF3954A4),
                                                            )),
                                                            barrierDismissible:
                                                                false);
                                                        await showMapBottomSheet2(
                                                            context,
                                                            latitude1,
                                                            longitude1,
                                                            latitude2,
                                                            longitude2);
                                                      },
                                                      child: Container(
                                                          width: 50,
                                                          height: 34,
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Color(
                                                                0xFFECF4FF),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                          ),
                                                          child: Image.asset(
                                                              'assets/images/maps.png')),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // width: 120,
                                                    height: 34,
                                                    decoration: ShapeDecoration(
                                                      color: Color(0xFFECF4FF),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                              'assets/images/watch.png'),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '$time minutes',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF6E6868),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Kanit',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        );
                                      })),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.12,
                            // height: MediaQuery.of(context).size.height / 4.5,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 5,
                                  // offset: Offset(0, 0),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Get.dialog(
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF3954A4),
                                          ),
                                        ),
                                        barrierDismissible: false);
                                    await showMapDialog1(context, address1);
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              'assets/images/location2.png'),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Image.asset('assets/images/car.png'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          address1,
                                          style: TextStyle(
                                            color: Color(0xFF524D4D),
                                            fontSize: 14,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Get.dialog(
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF3954A4),
                                          ),
                                        ),
                                        barrierDismissible: false);
                                    await showMapDialog2(context, address2);
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/car4.png'),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Image.asset(
                                              'assets/images/location5.png'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          address2,
                                          style: TextStyle(
                                            color: Color(0xFF524D4D),
                                            fontSize: 14,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                          textAlign: TextAlign.center,
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.12,
                            // height: 450,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ListTile(
                                  leading: Text(
                                    'Trajet',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  trailing: Text(
                                    distance,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF3954A4),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Text(
                                    'Type de paiement',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  trailing: Text(
                                    payment,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF3954A4),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Commentaire',
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                comment,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  color: Color(0xFF3954A4),
                                                  fontSize: 14,
                                                  fontFamily: 'Kanit',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                    leading: Text(
                                      'Fichier 1:',
                                      style: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                    trailing: (file1 != "")
                                        ? IconButton(
                                            onPressed: () {
                                              // setState(() {
                                              //   BaseUrl = BaseUrl + "$file1";
                                              // });

                                              print(
                                                  'Final Base Url is: $BaseUrl1');

                                              Get.to(() => WebViewScreen(),
                                                  arguments: [BaseUrl1]);
                                            },
                                            icon: Icon(
                                              Icons.visibility,
                                              color: Color(0xFF3954A4),
                                            ))
                                        : Text(
                                            "N/A",
                                            style: TextStyle(
                                              color: Color(0xFF3954A4),
                                              fontSize: 14,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          )),
                                ListTile(
                                    leading: Text(
                                      'Fichier 2:',
                                      style: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                    trailing: (file2 != "")
                                        ? IconButton(
                                            onPressed: () {
                                              print(
                                                  'Final Base Url is: $BaseUrl2');

                                              Get.to(() => WebViewScreen(),
                                                  arguments: [BaseUrl2]);
                                            },
                                            icon: Icon(
                                              Icons.visibility,
                                              color: Color(0xFF3954A4),
                                            ),
                                          )
                                        : Text(
                                            "N/A",
                                            style: TextStyle(
                                              color: Color(0xFF3954A4),
                                              fontSize: 14,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          )),
                                ListTile(
                                  leading: Text(
                                    'Chauffeur',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  trailing: (widget.Screen == "panier" ||
                                          widget.Screen == "admin")
                                      ? Text(
                                          '${chauffeur}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF3954A4),
                                            fontSize: 14,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        )
                                      : Text(
                                          '${name}  ${surname}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF3954A4),
                                            fontSize: 14,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                ),
                                ListTile(
                                  leading: Text(
                                    'Référence',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  trailing: Text(
                                    referenceNumber,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF3954A4),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
