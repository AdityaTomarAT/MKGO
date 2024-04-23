// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fr.innoyadev.mkgodev/Success_page/location/location_error.dart';
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:map_launcher/map_launcher.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:pie_menu/pie_menu.dart';
// import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

GetStorage box = GetStorage();

class Location extends StatefulWidget {
  Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Set<dynamic> selectedItems = {};
  String selectedType = '';
  TextEditingController searchController1 = TextEditingController();
  TextEditingController searchController2 = TextEditingController();
  TextEditingController searchController3 = TextEditingController();
  TextEditingController searchController4 = TextEditingController();

  bool isRegionSelected = false;
  bool isRefreshed = false;
  bool isDriverSelected = false;

  TextEditingController searchController5 = TextEditingController();

  Future<List<Map<String, dynamic>>> regionList() async {
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

        box.write('regionsLocation', regions);
        return regions;
      } else {
        print("API response does not contain 'collections'");
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> DriverList() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';

    final regionId = box.read('regionIdLocation');
    print('Region id in API function: $regionId');

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
      box.write('driverLocation', driverList);

      return driverList;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  double? Latitude1;
  double? longitude1;
  late String Access_Token;

  String errorData = "";
  @override
  void initState() {
    super.initState();
    String errorData = '';
    locationData();
    regionList();
    setState(() {
      regionNameBox = "REGION";
      driverNameBox = "DRIVER";
    });
  }

  String exist2 = "";
  String TimeStamp = "";
  Future<void> getLocation() async {
    setState(() {
      isRefreshed = true;
    });
    final box = GetStorage();
    final token = box.read('token');
    final driverId = box.read('driverIdLocation');
    print('driver id for location in API function: $driverId');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final LocationBaseUrl = configJson['planning_baseUrl'];
    final LocationApiKey = configJson['planning_apiKey'];

    final LocationMainUrl = LocationBaseUrl + "get/location";

    var headers = {
      'x-api-key': '$LocationApiKey',
      'Authorization': 'Bearer ' + token
    };

    var request = http.Request('POST', Uri.parse(LocationMainUrl));
    request.body = json.encode({
      "chauffeur-id": driverId.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = json.decode(await response.stream.bytesToString());

      double latitude = responseData['lat'] ?? 0.00;
      double longitude = responseData['long'] ?? 0.00;
      String dateTime = responseData['timestamp'] ?? "";

      String exist = responseData['exist'];

      setState(() {
        exist2 = exist;
        TimeStamp = dateTime;
      });
      print('Exist in APi: $exist2');

      setState(() {
        isRefreshed = false;
        Latitude1 = latitude;
        longitude1 = longitude;
      });
    } else {
      setState(() {
        isRefreshed = false;
      });
      Get.to(() => ErrorLocationScreen(
            notes: 'Unable to find the Location..!!',
          ));

      print(response.reasonPhrase);
    }
  }

  Future<void> ecurrentLocaionlaunchMap(
      double? latitude, double? longitude) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&latitude=$latitude&longitude=$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String regionNameBox = box.read('regionName') ?? 'REGION';
  String driverNameBox = box.read('driverName') ?? 'DRIVER';

  Future<dynamic> adminFilter(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final ValueNotifier<String> selectedRegionNotifier =
        ValueNotifier<String>("REGION");

    final ValueNotifier<String> selectedDriverNotifier =
        ValueNotifier<String>("DRIVER");

    void resetValues() {
      setState(() {
        selectedDriverNotifier.value = "DRIVER";
        selectedRegionNotifier.value = "REGION";
      });
    }

    bool _isRegionSelected = false;
    bool _isTypeSelected = false;
    bool _isDriverSelected = false;
    bool _isClientSelected = false;
    bool isREGION1 = false;
    bool isDRIVER1 = false;

    bool regionLocation = false;

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
        final currentWidth = MediaQuery.of(context).size.width;

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: currentWidth <= 360
                  ? MediaQuery.of(context).size.height / 1.6
                  : MediaQuery.of(context).size.height / 2,
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
                            ' Filter the Driver here ',
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
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 25),
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
                                        (box.read('regionsLocation') ?? []);
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
                                                      width:
                                                          MediaQuery.of(context)
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
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
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
                                                      itemCount: region.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final item =
                                                            region[index];
                                                        final String
                                                            regionName =
                                                            item["libelle"];
                                                        final bool isSelected =
                                                            selectedRegionNotifier
                                                                    .value ==
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
                                                                child: ListTile(
                                                                  onTap:
                                                                      () async {
                                                                    box.write(
                                                                        'regionName',
                                                                        regionName);
                                                                    setState(
                                                                        () {
                                                                      regionNameBox =
                                                                          box.read(
                                                                              'regionName');
                                                                      regionLocation =
                                                                          true;
                                                                    });
                                                                    selectedRegionNotifier
                                                                            .value =
                                                                        regionName;
                                                                    _isRegionSelected =
                                                                        true;
                                                                    int Id = int
                                                                        .parse(item[
                                                                            "id"]);
                                                                    box.write(
                                                                        'regionIdLocation',
                                                                        Id);
                                                                    final idregion =
                                                                        box.read(
                                                                            'regionIdLocation');
                                                                    print(
                                                                        'id in storage for api: $idregion');
                                                                    Get.dialog(
                                                                        Center(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                Color(0xFF3954A4),
                                                                          ),
                                                                        ),
                                                                        barrierDismissible:
                                                                            false);
                                                                    await DriverList();
                                                                    Get.back();
                                                                    // ClientList();
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  title: Text(
                                                                      regionName),
                                                                  trailing:
                                                                      isSelected
                                                                          ? Icon(
                                                                              Icons.check,
                                                                              color: Colors.blue,
                                                                            )
                                                                          : null,
                                                                ),
                                                              )
                                                            : SizedBox.shrink();
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
                                            box.remove('driverName');
                                            // box.remove('driverLocation');
                                            isDriverSelected = false;
                                            driverNameBox = "DRIVER";
                                            isDRIVER1 = true;
                                            selectedRegionNotifier.value ==
                                                "DRIVER";
                                            final region =
                                                box.read('driverName') ??
                                                    "Null hai value";
                                            print('tap ho rha hai');
                                            print('Region: $region');
                                            box.remove('driverName');
                                            driverNameBox = "DRIVER";
                                          });
                                          print(
                                              'Selected notifier ki value: ${selectedRegionNotifier.value}');
                                          setState(() {
                                            regionLocation = false;
                                            box.remove('regionName');
                                            box.remove('regionIdLocation');
                                            isDriverSelected = false;
                                            regionNameBox = "REGION";
                                            print('tap ho rha hai');
                                            selectedRegionNotifier.value ==
                                                "REGION";

                                            final region =
                                                box.read('regionName') ??
                                                    "Null hai value";

                                            print('Region: $region');

                                            box.remove('regionName');
                                            regionNameBox = "REGION";
                                            box.remove('regionName');
                                            box.remove('driverName');
                                            box.remove('driverLocation');
                                            box.remove('regionIdLocation');
                                            isDriverSelected = false;
                                            driverNameBox = "DRIVER";
                                            regionNameBox = "REGION";
                                            Latitude1 = 0.00;
                                            longitude1 = 0.00;
                                            resetValues();
                                          });
                                        },
                                        child: Image.asset(
                                          'assets/images/cross2.png',
                                          color: Colors.red,
                                          scale: 1.5,
                                        ),
                                      ),
                                    SizedBox(
                                      width: 30,
                                    ),
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
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: GestureDetector(
                          onTap: () async {
                            if (regionNameBox.isNotEmpty) {
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
                                      List<dynamic> allDrivers =
                                          (box.read('driverLocation') ?? []);

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
                                                      width:
                                                          MediaQuery.of(context)
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
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
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
                                                                        item["nom"]
                                                                            .toLowerCase()
                                                                            .contains(text
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
                                                      child: allDrivers.isEmpty
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
                                                                          'assets/images/no-icons/no-drivers.png'),
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                  'No Drivers available for this region..!!',
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
                                                                  filteredDrivers
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                if (filteredDrivers
                                                                    .isEmpty) {
                                                                  return Center(
                                                                    child: Text(
                                                                      'No Drivers available',
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
                                                                    filteredDrivers[
                                                                        index];
                                                                final String
                                                                    driverName =
                                                                    "${item["nom"]} ${item["prenom"]}"
                                                                        .toLowerCase();
                                                                final bool
                                                                    isSelected =
                                                                    selectedDriverNotifier
                                                                            .value ==
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
                                                                              String driverid = item['id'].toString();
                                                                              box.write('driverIdLocation', driverid);
                                                                              // selectedDriverNotifier.value = "${item["nom"]} ${item["prenom"]}";
                                                                              // box.write('driverName', selectedDriverNotifier.value);
                                                                              // setState(() {});
                                                                              box.write('driverName', driverName);
                                                                              setState(() {
                                                                                driverNameBox = box.read('driverName');
                                                                              });
                                                                              print('Driver Id for locattion:  $driverid');
                                                                              Navigator.pop(context);
                                                                              filteredDrivers.clear();
                                                                              print('Selected ki value: ${selectedRegionNotifier.value}');
                                                                              print('Region ki value: ${regionNameBox}');
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
                                            // driverLocation = false;
                                            box.remove('driverName');
                                            // box.remove('driverLocation');

                                            isDriverSelected = false;
                                            driverNameBox = "DRIVER";
                                            isDRIVER1 = true;
                                            selectedRegionNotifier.value ==
                                                "DRIVER";
                                            final region =
                                                box.read('driverName') ??
                                                    "Null hai value";
                                            print('tap ho rha hai');
                                            print('Region: $region');
                                            box.remove('driverName');
                                            driverNameBox = "DRIVER";
                                            resetValues();
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
                      SizedBox(
                        height: 40,
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF3954A4),
                                  ),
                                  child: Text('Valider'),
                                  onPressed: () async {
                                    if (driverNameBox != "DRIVER" &&
                                        regionNameBox != "REGION") {
                                      setState(() {
                                        isDriverSelected = true;
                                      });
                                      getLocation();
                                      Navigator.pop(context);
                                    } else if (regionNameBox == "REGION" &&
                                        driverNameBox == "DRIVER") {
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
                                          'Select REGION and DRIVER',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      );
                                    } else if (regionNameBox == "REGION") {
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
                                    } else if (driverNameBox == "DRIVER") {
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
                                          'Select Driver',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return null;
                                    }

                                    // if(regionNameBox.isNotEmpty &&  driverNameBox.isNotEmpty){

                                    // print(
                                    //     '==================================================');
                                    // // filteredListAdmin();

                                    // }else if(regionNameBox.isEmpty){
                                    // Get.snackbar("REGION", "REGION IS NOT SELECTED");
                                    // }else{
                                    //   Get.snackbar("DRIVER", "DRIVER IS NOT SELECTED");

                                    // }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 250,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text('Reset'),
                                    onPressed: () {
                                      GetStorage box = GetStorage();
                                      setState(() {
                                        Latitude1 = 0.00;
                                        longitude1 = 0.00;
                                        exist2 = "true";
                                        box.remove('regionName');
                                        box.remove('driverName');
                                        box.remove('driverLocation');
                                        box.remove('regionIdLocation');
                                        isDriverSelected = false;
                                        regionNameBox = "REGION";
                                        driverNameBox = "DRIVER";
                                        exist2 = " ";
                                        isDriverSelected = false;
                                      });
                                      resetValues();
                                      print('Driver Name: $driverNameBox');
                                      print('Region Name: $regionNameBox');
                                    },
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }

  void showsnackbarforexist() {
    Get.snackbar(
      colorText: Colors.white,
      'Sorry..!!',
      'No Location Available for selected Driver',
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
        'No Location Available for selected Driver',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  String MainUrl = "";
  String Token = "";

  Future<void> locationData() async {
    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final MapboxUrl = configJson['mapBox_styleUrl'];
    final AccessToken = configJson['mapBox_accessToken'];

    final MainMapUrl = MapboxUrl + AccessToken;

    setState(() {
      MainUrl = MainMapUrl;
      Token = AccessToken;
    });
    print('Main Url = $MainUrl');
    print('Token = $Token');
  }

  // late MapboxMapController controller;
  // late CameraPosition _initialCameraPosition;

  late MapboxMapController mapController;

  _onMapCreated(MapboxMapController controller) async {
    this.mapController = controller;
  }

  _onStyleLoadedCallback() async {
    await mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(Latitude1!, longitude1!),
        iconSize: 1,
        iconImage: "assets/images/user.png",
      ),
    );
    // _addSourceAndLineLayer(0, false);
  }

  String currentMapStyle = MapboxStyles.MAPBOX_STREETS;

  List<String> availableMapStyles = [
    MapboxStyles.SATELLITE,
    MapboxStyles.DARK,
    MapboxStyles.TRAFFIC_DAY,
    MapboxStyles.MAPBOX_STREETS,
    MapboxStyles.TRAFFIC_NIGHT,
    // Add the 'Streets' style
  ];

  void _changeMapStyle(MapStyle style) {
    setState(() {
      currentMapStyle = style.name;
    });
  }

  Future<Coords> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return Coords(position.latitude, position.longitude);
  }

  Future<void> showMapDialog2(BuildContext context) async {
    // Get.back();

    final availableMaps = await MapLauncher.installedMaps;

    Coords currentLocation = await getCurrentLocation();

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
          height: MediaQuery.of(context).size.height / 1.75,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date & Time",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    Text(
                      TimeStamp,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    )
                  ],
                ),
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
                            await map.showMarker(
                                coords: Coords(Latitude1!, longitude1!),
                                title: ""
                                // ,
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
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    late double? latitude = box.read('latitude') ?? 0.00;
    late double? longitude = box.read('longitude') ?? 0.00;

    final currentWidth = MediaQuery.of(context).size.width;

    return PieCanvas(
      theme: PieTheme(
          delayDuration: Duration.zero,
          tooltipTextStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          buttonSize: 65),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: isDriverSelected
            ? (exist2 == "false")
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          backgroundColor: Color(0xFF3954A4),
                          onPressed: () async {
                            Get.dialog(
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF3954A4),
                                  ),
                                ),
                                barrierDismissible: false);
                            await showMapDialog2(context);
                          },
                          child: Icon(Icons.location_on),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FloatingActionButton(
                          backgroundColor: Color(0xFF3954A4),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 100, // Adjust the height as needed
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: availableMapStyles.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String style =
                                          availableMapStyles[index];
                                      final IconData icon = (style ==
                                              MapboxStyles.SATELLITE_STREETS)
                                          ? Icons.satellite_alt
                                          : (style == MapboxStyles.DARK)
                                              ? Icons.dark_mode
                                              : (style ==
                                                      MapboxStyles.TRAFFIC_DAY)
                                                  ? Icons.light_mode
                                                  : (style ==
                                                          MapboxStyles
                                                              .MAPBOX_STREETS)
                                                      ? Icons.map
                                                      : Icons
                                                          .traffic_outlined; // Default icon
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            currentMapStyle = style;
                                          });
                                          Navigator.pop(
                                              context); // Close the modal bottom sheet
                                        },
                                        child: Container(
                                          width:
                                              100, // Adjust the width of each item as needed
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(icon,
                                                  color:
                                                      (style == currentMapStyle)
                                                          ? Color(0xFF3954A4)
                                                          : Colors.black),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            (currentMapStyle == MapboxStyles.SATELLITE_STREETS)
                                ? Icons.satellite_alt
                                : (currentMapStyle == MapboxStyles.DARK)
                                    ? Icons.dark_mode
                                    : (currentMapStyle ==
                                            MapboxStyles.TRAFFIC_DAY)
                                        ? Icons.light_mode
                                        : (currentMapStyle ==
                                                MapboxStyles.MAPBOX_STREETS)
                                            ? Icons.map
                                            : Icons.traffic_outlined,
                            color:
                                isDriverSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
            : null,
        body: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 25,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
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
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            'Location',
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
                      height: 15,
                    ),
                    ListTile(
                      title: GestureDetector(
                        onTap: () {
                          adminFilter(context);
                        },
                        child: Container(
                          width: 180,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF3954A4),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (driverNameBox != "DRIVER")
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        exist2 = "true";
                                        box.remove('regionName');
                                        box.remove('driverName');
                                        box.remove('driverLocation');
                                        box.remove('regionIdLocation');
                                        isDriverSelected = false;
                                        driverNameBox = "DRIVER";
                                        regionNameBox = "REGION";
                                        Latitude1 = 0.00;
                                        longitude1 = 0.00;
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/images/cross2.png',
                                      color: Colors.red,
                                      scale: 1.6,
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    driverNameBox != "DRIVER"
                                        ? driverNameBox
                                        : 'Select Driver',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                      height: 0.11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      trailing: Container(
                        height: 45,
                        width: 45,
                        child: GestureDetector(
                          onTap: () {
                            if (driverNameBox != "DRIVER" &&
                                regionNameBox != "REGION") {
                              setState(() {
                                isRefreshed = true;
                              });

                              getLocation();
                              Future.delayed(Duration(milliseconds: 800), () {
                                setState(() {
                                  isRefreshed = false;
                                });
                              });
                            } else if (exist2 == "false") {
                              Get.snackbar(
                                colorText: Colors.white,
                                'Sorry..!!',
                                'No Location Available for selected Driver',
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 114, 105),
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
                                  'No Location Available for selected Driver',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              );
                            } else if (regionNameBox == "REGION" &&
                                driverNameBox == "DRIVER") {
                              Get.snackbar(
                                colorText: Colors.white,
                                'Please',
                                '',
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 114, 105),
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
                                  'Select REGION and DRIVER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              );
                            } else if (regionNameBox == "REGION") {
                              Get.snackbar(
                                colorText: Colors.white,
                                'Please',
                                '',
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 114, 105),
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
                                  'Select REGION',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              );
                            } else if (driverNameBox == "DRIVER") {
                              Get.snackbar(
                                colorText: Colors.white,
                                'Please',
                                '',
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 114, 105),
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
                                  'Select Driver',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              );
                            } else {
                              null;
                            }
                          },
                          child: Image.asset(
                            'assets/images/reloading.png',
                            fit: BoxFit.cover,
                            color: Color(0xFF3954A4),
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
              Expanded(
                child: (exist2 == "false")
                    ? isRefreshed
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF3954A4),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 80,
                              ),
                              Container(
                                height: 200,
                                width: 200,
                                child: Image.asset(
                                  'assets/images/no-icons/no-location.png',
                                  // color: Color(0xFF3954A4),
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Text(
                                    'No Location Data is Available for selected Driver..!!',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 16,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                      height: 0.11,
                                    ),
                                    textAlign: TextAlign.justify,
                                  )),
                                ],
                              ),
                            ],
                          )
                    : (isDriverSelected)
                        ? isRefreshed
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF3954A4),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Container(
                                  width: double.infinity,
                                  // height: currentWidth <= 360 ? 450 : 700,
                                  child: MapboxMap(
                                    accessToken: Token,
                                    styleString: currentMapStyle,
                                    onMapCreated: _onMapCreated,
                                    onStyleLoadedCallback:
                                        _onStyleLoadedCallback,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(Latitude1!, longitude1!),
                                      zoom: 16.5,
                                    ),
                                    onMapClick: (point, coordinates) {
                                      print('On map clicked is tapped');
                                      // Get.to(()=> Profile());
                                    },
                                  ),
                                ),
                              )
                        : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapStyle {
  final String name;
  final IconData icon;

  MapStyle({required this.name, required this.icon});
}
