// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:fr.innoyadev.mkgodev/homeScreen/homeScreen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import '../../tripDetails/tripDetails.dart';

GetStorage box = GetStorage();
bool isPasser = false;
bool isAujoudHui = false;
bool isAvenir = false;
bool isRefreshed = false;
// bool handOpen = false;

class FutureList extends StatefulWidget {
  const FutureList({super.key});

  @override
  State<FutureList> createState() => _FutureListState();
}

class _FutureListState extends State<FutureList> {
  @override
  void initState() {
    super.initState();
    print('present list ki length: ${tripsFuture.length}');
    tripListFuture();
    setState(() {
      subLists.clear();
    });
    currentIndex = 0;
    _fetchAdminData();
  }

  List<Map<String, dynamic>> tripsFuture = [];
  List<List<Map<String, dynamic>>> subLists = [];
  int currentIndex = 0;

  Future<void> _fetchAdminData() async {
    setState(() {
      isRefreshed = true;
    });
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData = await tripListFuture();
      setState(() {
        tripsFuture = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < tripsFuture.length; i += 10) {
        final endIndex =
            (i + 10 < tripsFuture.length) ? i + 10 : tripsFuture.length;
        subLists.add(tripsFuture.sublist(i, endIndex));
      }

      print('Admin data fetched successfully');
      setState(() {
        isRefreshed = false;
      });
    } catch (error) {
      setState(() {
        isRefreshed = false;
      });
      print('Error fetching admin data: $error');
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
        // String status1 = courses['affectationCourses'][0]['status1'];
        // String status2 = courses['affectationCourses'][0]['status2'];
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

        // addressToCoordinates1(depart);
        // addressToCoordinates2(arrive);

        String status1 = "";
        String status2 = "";

        // Initialize maxId to the smallest possible integer value
        int maxId = 0;

        // Iterate over 'affectationCourses' to find the entry with the highest ID
        for (var affectation in courses['affectationCourses']) {
          int affectationId = affectation['id'];
          if (affectationId > maxId) {
            maxId = affectationId;
            status1 = affectation['status1'];
            status2 = affectation['status2'];
            print('Affectation course highest id: $maxId');
          }
        }
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

      setState(() {
        tripsFuture = tripFutureAPI;
      });

      // print(tripPresent);
      box.write('future', tripFutureAPI);
      List<dynamic> adminToday2 = box.read('future');
      print('Admin Today in storage with refernce and date : $adminToday2');

      return tripFutureAPI;
    } else {
      throw Exception('Failed to fetch admin data: ${response.reasonPhrase}');
    }
  }

  ScrollController controller = ScrollController();

  bool isRefreshed = false;
  // bool isAujoudHui = false;

  int currentPage = 1;
  int itemsPerPage = 10;
  int calculateItemCount() {
    int itemCount = 0;
    print('Item Count: $itemCount');

    itemCount += (currentPage * itemsPerPage);
    print('Item Count: $itemCount');
    print('FutureList length: ${tripsFuture.length}');

    // // itemCount += isAtEndOfList ? 0 : 0;

    print('Item Count: $itemCount');
    if (itemCount > tripsFuture.length) {
      // Adjust itemCount without using setState
      print('FutureList length: ${tripsFuture.length}');
      itemCount = tripsFuture.length;
      print('Item Count adjusted: $itemCount');
      return itemCount;
    }

    return itemCount;
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

  Future<Coords> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return Coords(position.latitude, position.longitude);
  }

  void showmapBottomSheet(
      BuildContext context, double Latitude, double Longitude) async {
    final availableMaps = await MapLauncher.installedMaps;

    Coords currentLocation = await getCurrentLocation();

    print('Latitude1: $Latitude');
    print('longitude1: $Longitude');

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        // Adjust the height of the bottom sheet as needed
        height: 200,
        child: ListView.builder(
          itemCount: availableMaps.length,
          itemBuilder: (context, index) {
            final map = availableMaps[index];
            return Column(
              children: [
                SizedBox(
                  height: 5,
                ),
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
                ListTile(
                  leading: SvgPicture.asset(
                    map.icon,
                    height: 24,
                    width: 24,
                  ),
                  title: Text(
                    map.mapName,
                    style: TextStyle(
                      color: Color(0xFF6E6868),
                      fontSize: 20,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  onTap: () async {
                    await map.showDirections(
                      directionsMode: DirectionsMode.driving,
                      origin: currentLocation,
                      destination: Coords(Latitude, Longitude),
                      // coords: Coords(Latitude, Longitude),
                      // title: "Destination",
                    );

                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double Latitude1 = 0.00;
  double longitude1 = 0.00;
  double Latitude2 = 0.00;
  double longitude2 = 0.00;

  Future<Map<String, double>> addressToCoordinates1(String address) async {
    print('inside the function');
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;

        setState(() {
          Latitude1 = latitude;
          longitude1 = longitude;
        });

        print('Latitude1: $Latitude1');
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
          Latitude2 = latitude;
          longitude2 = longitude;
        });

        print('Latitude1: $Latitude1');
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

  Future<void> handleRefresh() async {
    setState(() {
      subLists.clear();
    });
    _fetchAdminData();
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
                                  destination: Coords(Latitude1, longitude1),
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
                                  destination: Coords(Latitude2, longitude2),
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
    List<bool>? handOpen =
        List.generate(tripsFuture.length, (index) => false, growable: true);
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
                : (tripsFuture.isEmpty)
                    ? ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 150,
                                  width: 200,
                                  child: Image.asset(
                                      'assets/images/no-icons/no-trips.png')),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No Trips Are Available..!!',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 18,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  height: 0.05,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    : ListView.builder(
                        // shrinkWrap: true,
                        controller: controller,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: subLists.isEmpty
                            ? 0
                            : subLists[currentIndex].length,
                        itemBuilder: (BuildContext context, int index) {
                          // Display each item in the sublist as a ListTile
                          final item = subLists[currentIndex][index];

                          String Status1 = item['status1'] ?? "";
                          String Status2 = item['status2'] ?? "";
                          String imgType = item['imgType'].toString();
                          String date = item['dateCourse'] ?? "";
                          String borderColor = item['backgroundColor'] ?? "";
                          print('Background color from the list: $borderColor');
                          DateTime dateTime = DateTime.parse(date);
                          tz.TZDateTime parisDateTime = tz.TZDateTime.from(
                              dateTime, tz.getLocation('Europe/Paris'));

                          String formattedDate = DateFormat("dd.MMM.yyyy HH:mm")
                              .format(parisDateTime);

                          String statusText;
                          switch ("$Status1-$Status2") {
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
                              statusText = "Absent ";
                              break;
                            case "1-4":
                              statusText = "Terminé";
                              break;
                            case "1-5":
                              statusText = "Abord";
                              break;
                            case "3-6":
                              statusText = "Cancelled";
                              break;
                            default:
                              statusText = "No Status Available";
                              break;
                          }

                          Color _getStatusColor(
                              String status1, String status2) {
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
                              case '1-0':
                                return HexColor('#0AAF20');
                              case '3-6':
                                return HexColor("#000000");
                              default:
                                return Color(0xFF135DB9);
                            }
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

                          String accpeted = "";

                          Future<void> updateTripStatus() async {
                            print('Accpedt status for API: $accpeted');

                            final box = GetStorage();
                            final _token = box.read('token') ?? '';

                            final configData = await rootBundle
                                .loadString('assets/config/config.json');
                            final configJson = json.decode(configData);

                            final gestionBaseUrl =
                                configJson['planning_baseUrl'];
                            final gestionApiKey = configJson['planning_apiKey'];

                            final gestionMainUrl = gestionBaseUrl +
                                "mob/course-accepte-refuse/" +
                                item['id'].toString();

                            var headers = {
                              'x-api-key': '$gestionApiKey',
                              'Authorization': 'Bearer ' + _token
                            };

                            var request =
                                http.Request('POST', Uri.parse(gestionMainUrl));
                            request.body = json.encode({
                              "etat": accpeted,
                            });
                            request.headers.addAll(headers);

                            http.StreamedResponse response =
                                await request.send();

                            if (response.statusCode == 200) {
                              print(await response.stream.bytesToString());

                              Get.snackbar(
                                colorText: Colors.white,
                                'Success',
                                'Trip is Accepted',
                                backgroundColor:
                                    Color.fromARGB(255, 8, 213, 59),
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
                              // tripDetails();
                              print(
                                  "==================After API for trip management");
                              // tripListFuture();
                              _fetchAdminData();
                              handleRefresh();
                              print(
                                  "==================After API for trip management");
                              // Get.to(() => TripDetails());

                              setState(() {
                                isRefreshed = false;
                              });
                            } else {
                              print(response.reasonPhrase);
                            }
                          }

                          String trip2Status = "";

                          Future<void> updateTripStatus2() async {
                            print(
                                'Trip Status for phase 2 trip status management: $trip2Status');

                            final box = GetStorage();
                            final _token = box.read('token') ?? '';

                            final configData = await rootBundle
                                .loadString('assets/config/config.json');
                            final configJson = json.decode(configData);

                            final gestionBaseUrl =
                                configJson['planning_baseUrl'];
                            final gestionApiKey = configJson['planning_apiKey'];

                            final gestionMainUrl = gestionBaseUrl +
                                "mob/course-etat/" +
                                item['id'].toString();

                            var headers = {
                              'x-api-key': '$gestionApiKey',
                              'Authorization': 'Bearer ' + _token
                            };

                            var request =
                                http.Request('POST', Uri.parse(gestionMainUrl));
                            request.body = json.encode({
                              "etat2": trip2Status,
                            });
                            request.headers.addAll(headers);

                            http.StreamedResponse response =
                                await request.send();

                            if (response.statusCode == 200) {
                              print(await response.stream.bytesToString());
                              // tripListFuture();
                              _fetchAdminData();

                              Get.snackbar(
                                colorText: Colors.white,
                                'Success',
                                'Trip is Updated',
                                backgroundColor:
                                    Color.fromARGB(255, 8, 213, 59),
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
                              // tripDetails();
                              // Get.to(() => TripDetails());

                              setState(() {
                                isRefreshed = false;
                              });

                              // Navigator.of(context).pop();
                            } else {
                              print(response.reasonPhrase);
                            }
                          }

                          Future<void> currentLocaionlaunchMap(
                              String destination) async {
                            final url =
                                'https://www.google.com/maps/dir/?api=1&destination=$destination';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }

                          TextEditingController reassgin =
                              TextEditingController();

                          Future<void> updateTripStatus3() async {
                            print('Accpedt status for API: $accpeted');

                            final box = GetStorage();
                            final _token = box.read('token') ?? '';

                            final configData = await rootBundle
                                .loadString('assets/config/config.json');
                            final configJson = json.decode(configData);

                            final gestionBaseUrl =
                                configJson['planning_baseUrl'];
                            final gestionApiKey = configJson['planning_apiKey'];

                            final gestionMainUrl = gestionBaseUrl +
                                "mob/course-accepte-refuse/" +
                                item['id'].toString();

                            var headers = {
                              'x-api-key': '$gestionApiKey',
                              'Authorization': 'Bearer ' + _token
                            };

                            var request =
                                http.Request('POST', Uri.parse(gestionMainUrl));
                            request.body = json.encode({
                              "etat": accpeted,
                              "motifRefus": reassgin.text
                            });
                            request.headers.addAll(headers);

                            http.StreamedResponse response =
                                await request.send();

                            if (response.statusCode == 200) {
                              print(await response.stream.bytesToString());

                              Get.snackbar(
                                colorText: Colors.white,
                                'Success',
                                'Trip is Rejected',
                                backgroundColor:
                                    Color.fromARGB(255, 8, 213, 59),
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
                              // tripDetails();
                              print(
                                  "==================After API for trip management");
                              // tripListFuture();
                              _fetchAdminData();
                              print(
                                  "==================After API for trip management");
                              // Get.to(() => TripDetails());

                              setState(() {
                                isRefreshed = false;
                              });
                            } else {
                              print(response.reasonPhrase);
                            }
                          }

                          String page = "avenir";

                          Future<dynamic> clientAbsentBottomSheet() {
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: Center(
                                        child: Form(
                                          key: key,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    45,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Refuser Une Course',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF524D4D),
                                                        fontSize: 18,
                                                        fontFamily: 'Kanit',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0.05,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    95,
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: TextFormField(
                                                    controller: reassgin,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.2),
                                                        ),
                                                        labelText:
                                                            "Commentaire",
                                                        labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              Color(0xFFA4A4A4),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 250,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Color(
                                                                    0xFF3954A4)),
                                                        child:
                                                            Text('Confirmer'),
                                                        onPressed: () {
                                                          // returnRide();
                                                          if (key.currentState!
                                                              .validate()) {
                                                            print(
                                                                'Comment not entered');
                                                            updateTripStatus3();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
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
                                isRefreshed = true;
                              });
                              Future.delayed(Duration(milliseconds: 500), () {
                                setState(() {
                                  isRefreshed = false;
                                });
                              });
                            });
                          }

                          return Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: 393,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(20),
                                // borderRadius: BorderRadius.circular(5),
                                border: Border(
                                  left: BorderSide(
                                      color: (Status1 == "3" && Status2 == "6")
                                          ? HexColor("#000000")
                                          : HexColor(borderColor)),
                                  top: BorderSide(
                                      color: (Status1 == "3" && Status2 == "6")
                                          ? HexColor("#000000")
                                          : HexColor(borderColor),
                                      width: 7),
                                  right: BorderSide(
                                      color: (Status1 == "3" && Status2 == "6")
                                          ? HexColor("#000000")
                                          : HexColor(borderColor)),
                                  bottom: BorderSide(
                                      color: (Status1 == "3" && Status2 == "6")
                                          ? HexColor("#000000")
                                          : HexColor(borderColor)),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                child: Column(
                                  children: [
                                    ListTile(
                                      minLeadingWidth: 0,
                                      leading: IconButton(
                                        onPressed: () async {
                                          final call =
                                              Uri.parse('tel:${item['tel1']}');
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
                                        '${item['nom']} ${item['prenom']}',
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14.5,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                      trailing: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => TripDetails(
                                                id: item['id'].toString(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: CircleBorder(),
                                                shadows: [
                                                  BoxShadow(
                                                    color: Color(0x3F000000),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 0),
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                              ),
                                              child: getImageBasedOnType(
                                                  imgType))),
                                    ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Image.asset(
                                            'assets/images/location.png'),
                                            SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () async {
                                              Get.dialog(
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color(0xFF3954A4),
                                                    ),
                                                  ),
                                                  barrierDismissible: false);
                                              await showMapDialog1(
                                                  context, item["depart"]);
                                            },
                                            child: Text(
                                              item['depart'],
                                              style: TextStyle(
                                                color: Color(0xFF524D4D),
                                                fontSize: 14.5,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                        ),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/images/location2.png'),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () async {
                                               Get.dialog(
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color(0xFF3954A4),
                                                    ),
                                                  ),
                                                  barrierDismissible: false);
                                              await showMapDialog2(
                                                  context, item["depart"]);
                                            },
                                            child: Text(
                                              item['arrive'],
                                              // item['status1'],
                                              style: TextStyle(
                                                color: Color(0xFF524D4D),
                                                fontSize: 14.5,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      color: Color(0xFFE6E6E6),
                                    ),
                                    ListTile(
                                      visualDensity:
                                          VisualDensity(vertical: -4),
                                      leading: Container(
                                        width: 65,
                                        child: Text(
                                          statusText,
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                Status1, Status2),
                                            fontSize: 14,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  () => TripDetails(
                                                    Screen: page,
                                                    id: item['id'].toString(),
                                                  ),
                                                );
                                              },
                                              child: Image.asset(
                                                  'assets/images/search.png')),
                                          SizedBox(width: 5),
                                          (Status1 == "1" && Status2 == "0")
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      HexColor(borderColor),
                                                  child: Image.asset(
                                                      'assets/images/hand.png'))
                                              : PieMenu(
                                                  theme: PieTheme.of(context)
                                                      .copyWith(
                                                    buttonTheme: PieButtonTheme(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      backgroundColor:
                                                          Colors.deepOrange,
                                                      iconColor: Colors.white,
                                                    ),
                                                    buttonThemeHovered:
                                                        const PieButtonTheme(
                                                      backgroundColor:
                                                          Colors.orangeAccent,
                                                      iconColor: Colors.black,
                                                    ),
                                                    brightness: Brightness.dark,
                                                  ),
                                                  actions: [
                                                    PieAction.builder(
                                                      tooltip: Container(),
                                                      onSelect: () {
                                                        setState(() {
                                                          accpeted = 'Refuse';
                                                        });
                                                        print(
                                                            'Trip Status for api: $accpeted');
                                                        clientAbsentBottomSheet();
                                                      },
                                                      builder: (hovered) {
                                                        return _buildIconButton(
                                                            (Icons
                                                                .visibility_off),
                                                            hovered);
                                                      },
                                                    ),
                                                    PieAction.builder(
                                                      tooltip:
                                                          const Text('Accepte'),
                                                      onSelect: () {
                                                        setState(() {
                                                          print(
                                                              'set ho gya value');
                                                          handOpen[index] =
                                                              true;
                                                          isRefreshed = true;
                                                        });
                                                        print(
                                                            'List of bool after tapping first time: $handOpen');
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    150), () {
                                                          setState(() {
                                                            accpeted =
                                                                'Accepte';
                                                          });
                                                          updateTripStatus()
                                                              .whenComplete(
                                                                  () => () {
                                                                        setState(
                                                                            () {
                                                                          isRefreshed =
                                                                              true;
                                                                        });
                                                                        tripListFuture();
                                                                        setState(
                                                                            () {
                                                                          isRefreshed =
                                                                              false;
                                                                        });
                                                                      });
                                                          // Get.to(()=> LandingScreen2())
                                                        });
                                                        setState(() {
                                                          handOpen[index] =
                                                              false;
                                                        });
                                                      },
                                                      builder: (hovered) {
                                                        return _buildIconButton(
                                                            Icons
                                                                .check_outlined,
                                                            hovered);
                                                      },
                                                    ),
                                                  ],
                                                  child: Image.asset(
                                                      'assets/images/hand.png'),
                                                )
                                        ],
                                      ),
                                      trailing: Container(
                                        child: Text(
                                          formattedDate,
                                          style: TextStyle(
                                            color: Color(0xFF524D4D),
                                            fontSize: 16,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
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
