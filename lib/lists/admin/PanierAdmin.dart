// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/lists/admin/PanierAdminList.dart';
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

List<Map<String, dynamic>> AdminListFilterPanier = [];
List<List<Map<String, dynamic>>> appAdminPanier = [];

class PanierAdmin extends StatefulWidget {
  const PanierAdmin({super.key});

  @override
  State<PanierAdmin> createState() => PanierAdminState();
}

class PanierAdminState extends State<PanierAdmin> {
  TextEditingController comment = TextEditingController();
  TextEditingController reassign = TextEditingController();
  TextEditingController returnController = TextEditingController();
  TextEditingController searchController1 = TextEditingController();
  TextEditingController searchController2 = TextEditingController();
  TextEditingController searchController4 = TextEditingController();

  bool isRefreshed = false;
  bool isFiltered = false;
  bool isRegionSelcted = false;

  String regionNameBox = box.read('regionNameAdminPanier') ?? 'REGION';
  String typeNameBox = box.read('typeNameAdminPanier') ?? 'TYPE';
  String clientNameBox = box.read('clientNameAdminPanier') ?? 'CLIENT';
  // String driverNameBox = box.read('driverNameAdminPanier') ?? 'DRIVER';

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

  Future<void> _fetchAdminData() async {
    setState(() {
      isRefreshed = true;
    });
    print('AdminFilter list ki length: ${AdminListFilterPanier.length}');
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData = await filteredListAdmin();
      setState(() {
        AdminListFilterPanier = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < AdminListFilterPanier.length; i += 10) {
        final endIndex = (i + 10 < AdminListFilterPanier.length)
            ? i + 10
            : AdminListFilterPanier.length;
        appAdminPanier.add(AdminListFilterPanier.sublist(i, endIndex));
      }

      print('Admin data fetched successfully');
      print('App admin list ki length: ${appAdminPanier.length}');
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

  int TotalCount = 0;

  Future<List<Map<String, dynamic>>> filteredListAdmin() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final regionId = box.read('regionIdPanier');
    final typeId = box.read('typeIdPanier');
    // final driverId = box.read('driverId');
    final clientId = box.read('clientIdPanier');

    print('Ids in filter APi function: $regionId, $typeId, $clientId, ');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "mob/admin/panier";

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('GET', Uri.parse(gestionMainUrl));
    request.body = json.encode({
      "region": regionId,
      "typeCourse": typeId,
      "client": clientId,
      // "chauffeur": driverId,
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
        // String chauffeur = courses['chauffeur'];
        int client = courses['client'];
        String reference = courses['reference'];
        int tarif = courses['tarif'];
        String backgroundColor = courses['backgroundColor'];
        String dateCourse = courses['dateCourse'];
        String nom = courses['clientDetails']['nom'];
        String prenom = courses['clientDetails']['prenom'];
        String telephone = courses['clientDetails']['tel1'];
        String chauffeur = courses['modifiePar'];
        // String driverNom = courses['chauffeurDetails']['nom'];
        // String driverPrenom = courses['chauffeurDetails']['prenom'];
        int region = courses['region'];
        int statusCourse = courses['statusCourse'];
        String depart = courses['depart'];
        String arrive = courses['arrive'];

        int imgType = courses['clientDetails']['typeClient']['id'] ?? "";

        // String chauffeur = courses['chauffeur'];

        String distanceTrajet = courses['distanceTrajet'];
        String dureeTrajet = courses['dureeTrajet'];

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
          // 'driverNom': driverNom,
          // "driverPrenom": driverPrenom
        });
      }
      print('Filtered List in API: $Filteredlist');
      box.write('finalfilteredListPanier', Filteredlist);
      List<dynamic> adminToday2 = box.read('finalfilteredListPanier');
      print('Filtered list in Storage: $adminToday2');
      // Navigator.of(context).pop();
      return Filteredlist;
    } else {
      throw Exception('Failed to fetch admin data: ${response.reasonPhrase}');
    }
  }

  Future<dynamic> adminFilterBottomSheet(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      AdminListFilterPanier.clear();
      selectedRegionNotifier.value = "REGION";
      selectedTypeNotifier.value = "TYPE";
      // selectedDriverNotifier.value = "DRIVER";
      selectedClientNotifier.value = "CLIENT";
      AdminListFilterPanier.clear();
    }

    bool isRegionSelected = false;
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
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.25,
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
                                                                  child:
                                                                      ListTile(
                                                                    onTap: () {
                                                                      selectedRegionNotifier
                                                                              .value =
                                                                          regionName;
                                                                      isRegionSelected =
                                                                          true;
                                                                      box.write(
                                                                          'regionNameAdminPanier',
                                                                          regionName);
                                                                      setState(
                                                                          () {
                                                                        regionNameBox =
                                                                            box.read('regionNameAdminPanier');
                                                                      });
                                                                      print(
                                                                          'Region Name using RegionNameBox: $regionNameBox');
                                                                      int Id = int
                                                                          .parse(
                                                                              item["id"]);
                                                                      box.write(
                                                                          'regionIdPanier',
                                                                          Id);
                                                                      final idregion =
                                                                          box.read(
                                                                              'regionIdPanier');
                                                                      print(
                                                                          'id in storage for api: $idregion');
                                                                      DriverList();
                                                                      ClientList();
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
                                                selectedRegionNotifier.value ==
                                                    "REGION";

                                                final region =
                                                    box.read('regionName') ??
                                                        "Null hai value";
                                                appAdminPanier.clear();

                                                print('Region: $region');

                                                box.remove('regionNameAdmin');
                                                box.remove('regionIdPanier');
                                                regionNameBox = "REGION";
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
                                                              selectedTypeNotifier
                                                                      .value ==
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
                                                                  child:
                                                                      ListTile(
                                                                          onTap:
                                                                              () {
                                                                            box.write('typeNameAdminPanier',
                                                                                typeName);
                                                                            setState(() {
                                                                              typeNameBox = box.read('typeNameAdminPanier');
                                                                            });

                                                                            selectedTypeNotifier.value =
                                                                                typeName;
                                                                            int Id =
                                                                                int.parse(item["id"]);
                                                                            box.write('typeIdPanier',
                                                                                Id);
                                                                            final idType =
                                                                                box.read('typeIdPanier');
                                                                            print(' Type id in storage for api: $idType');
                                                                            DriverList();
                                                                            ClientList();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          title: Text(
                                                                              typeName),
                                                                          trailing: isSelected
                                                                              ? Icon(Icons.check)
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
                                                  box.read('typeNamePanier') ??
                                                      "Null hai value";

                                              print('Type: $type');

                                              box.remove('typeNameAdminPanier');
                                              box.remove('typeIdPanier');
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
                                                                Image.asset(
                                                                    'assets/images/no-clients.png'),
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
                                                                    selectedClientNotifier
                                                                            .value ==
                                                                        "${item["nom"]} ${item["prenom"]}";
                                                                final bool
                                                                    shouldDisplay =
                                                                    clientName
                                                                        .contains(
                                                                  searchController4
                                                                      .text
                                                                      .toLowerCase(),
                                                                );

                                                                return shouldDisplay
                                                                    ? Center(
                                                                        child:
                                                                            ListTile(
                                                                          onTap:
                                                                              () {
                                                                            box.write('clientNameAdminPanier',
                                                                                clientName);
                                                                            setState(() {
                                                                              clientNameBox = box.read('clientNameAdminPanier');
                                                                            });
                                                                            String
                                                                                clientid =
                                                                                item['id'].toString();
                                                                            box.write('clientIdPanier',
                                                                                clientid);
                                                                            final IdClient =
                                                                                box.read('clientIdPanier');
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
                                                                          trailing: isSelected
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
                                        appAdminPanier.clear();
                                        isRegionSelcted = true;
                                      });
                                      filteredListAdmin();
                                      _fetchAdminData().whenComplete(() {
                                        Navigator.of(context).pop();
                                        isRegionSelcted = false;
                                        isRefreshed = false;
                                      });
                                      filteredListAdmin();
                                      // calculateItemCount();
                                      Future.delayed(
                                          Duration(milliseconds: 600), () {
                                        setState(() {
                                          isRefreshed = false;
                                          isRegionSelcted = false;
                                        });
                                      });
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
                                        box.remove('finalfilteredListPanier');
                                        box.remove('regionNameAdminPanier');
                                        // box.remove('driverNameAdmin');
                                        box.remove('clientNameAdminPanier');
                                        box.remove('typeNameAdminPanier');
                                        box.remove('typeIdPanier');
                                        box.remove('regionIdPanier');
                                        // box.remove('driverId');
                                        box.remove('clientIdPanier');
                                        print('Region: $regionNameBox');
                                        // print('Driver: $driverNameBox');
                                        print('Client: $clientNameBox');
                                        print('Type: $typeNameBox');
                                        AdminListFilterPanier.clear();
                                        appAdminPanier.clear();
                                        regionNameBox = "REGION";
                                        typeNameBox = "TYPE";
                                        clientNameBox = "CLIENT";
                                        // driverNameBox = "DRIVER";
                                        AdminListFilterPanier.clear();
                                        print('Region: $regionNameBox');
                                        // print('Driver: $driverNameBox');
                                        print('Client: $clientNameBox');
                                        print('Type: $typeNameBox');
                                        box.remove('finalfilteredListPanier');
                                        print(
                                            'Filtered List: $AdminListFilterPanier');
                                      });
                                      AdminListFilterPanier.clear();
                                      AdminListFilterPanier.clear();

                                      Navigator.of(context).pop();
                                      AdminListFilterPanier.clear();
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
      // print('Driver: $driverNameBox');
      print('Client: $clientNameBox');
      print('Type: $typeNameBox');
      AdminListFilterPanier.clear();
      regionNameBox = "REGION";
      typeNameBox = "TYPE";
      clientNameBox = "CLIENT";
      // driverNameBox = "DRIVER";
      AdminListFilterPanier.clear();
      print('Region: $regionNameBox');
      // print('Driver: $driverNameBox');
      print('Client: $clientNameBox');
      print('Type: $typeNameBox');
      box.remove('finalfilteredList');
      print('Filtered List: $AdminListFilterPanier');
    });
    AdminListFilterPanier.clear();
    AdminListFilterPanier.clear();
  }

  @override
  void initState() {
    super.initState();
    clear();
  }

  @override
  Widget build(BuildContext context) {
    // final storage = GetStorage();
    // // final imagePath = storage.read('imagePath2');
    // List<dynamic> userRoles = storage.read('user_roles') ?? [];
    // bool isAdmin = userRoles.contains('ROLE_ADMIN');
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
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  'Panier',
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
                                      (appAdminPanier.isNotEmpty ||
                                              regionNameBox != "REGION")
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isRefreshed = true;
                                                  appAdminPanier.clear();
                                                });
                                                AdminListFilterPanier.clear();
                                                setState(() {});
                                                AdminListFilterPanier.clear();
                                                AdminListFilterPanier = [];
                                                AdminListFilterPanier.clear();
                                                setState(() {
                                                  appAdminPanier.clear();
                                                  box.remove(
                                                      'finalfilteredListPanier');
                                                  box.remove(
                                                      'regionNameAdminPanier');
                                                  // box.remove('driverNameAdminPanier');
                                                  box.remove(
                                                      'clientNameAdminPanier');
                                                  box.remove(
                                                      'typeNameAdminPanier');
                                                  box.remove('typeIdPanier');
                                                  box.remove('regionIdPanier');
                                                  // box.remove('driverIdPanier');
                                                  box.remove('clientIdPanier');
                                                  print(
                                                      'Region: $regionNameBox');
                                                  // print(
                                                  //     'Driver: $driverNameBox');
                                                  print(
                                                      'Client: $clientNameBox');
                                                  print('Type: $typeNameBox');
                                                  AdminListFilterPanier.clear();
                                                  regionNameBox = "REGION";
                                                  typeNameBox = "TYPE";
                                                  clientNameBox = "CLIENT";
                                                  // driverNameBox = "DRIVER";
                                                  AdminListFilterPanier.clear();
                                                  print(
                                                      'Region: $regionNameBox');
                                                  // print(
                                                  //     'Driver: $driverNameBox');
                                                  print(
                                                      'Client: $clientNameBox');
                                                  print('Type: $typeNameBox');
                                                  box.remove(
                                                      'finalfilteredListPanier');
                                                  print(
                                                      'Filtered List: $AdminListFilterPanier');
                                                });
                                                AdminListFilterPanier.clear();
                                                setState(() {
                                                  isRefreshed = false;
                                                  appAdminPanier.clear();
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                  height: 650,
                  child: isRefreshed
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF3954A4),
                          ),
                        )
                      : (regionNameBox == "REGION")
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
                                      'PLease Select Region From Above Filters..!!',
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
                          : PanierAdminList()),
            )
          ],
        ),
      ),
    );
  }
}
