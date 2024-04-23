// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fr.innoyadev.mkgodev/cart/cart.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:map_launcher/map_launcher.dart';
// import 'package:pie_menu/pie_menu.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:url_launcher/url_launcher.dart';

// import '../../tripDetails/tripDetails.dart';

// GetStorage box = GetStorage();

// class FutureAdminList extends StatefulWidget {
//   const FutureAdminList({super.key});

//   @override
//   State<FutureAdminList> createState() => _FutureAdminListState();
// }

// class _FutureAdminListState extends State<FutureAdminList> {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     TripListFutureAdmin();
//   }

//   Future<List<Map<String, dynamic>>> DriverList2() async {
//     final box = GetStorage();
//     final _token = box.read('token') ?? '';
//     String regionId2 = box.read('regionId3').toString();

//     final configData = await rootBundle.loadString('assets/config/config.json');
//     final configJson = json.decode(configData);

//     final gestionBaseUrl = configJson['gestion_baseUrl'];
//     final gestionApiKey = configJson['gestion_apiKey'];

//     final gestionMainUrl =
//         gestionBaseUrl + "api/liste/chauffeur/active/" + regionId2.toString();

//     var headers = {
//       'x-api-key': '$gestionApiKey',
//       'Authorization': 'Bearer ' + _token
//     };

//     var request = http.Request('GET', Uri.parse(gestionMainUrl));

//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final apiData = jsonDecode(responseBody);

//       List<Map<String, dynamic>> driverList = [];
//       for (var driver in apiData['collections']) {
//         int id = driver['id'];
//         String nom = driver['nom'];
//         String prenom = driver['prenom'];
//         driverList.add({'id': id, 'nom': nom, 'prenom': prenom});
//       }
//       box.write('driver2', driverList);
//       // List<dynamic> driver3 = box.read('driver2');
//       // print('List for the bottomSheet : $driver3');

//       // setState(() {
//       //   driverList3 = driverList;
//       // });

//       // print('Driver list for dropdown: $driverList3');

//       return driverList;
//     } else {
//       print(response.reasonPhrase);
//     }
//     return [];
//   }

//   Future<dynamic> clientAbsentBottomSheet(
//       BuildContext context, Map<String, dynamic> item) {
//     return showModalBottomSheet(
//         backgroundColor: Color(0xFFE6F7FD),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(38),
//           ),
//         ),
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           // final TextEditingController
//           //     _controller =
//           //     TextEditingController();
//           // String?
//           //     _selectedValue;
//           // List<dynamic>
//           //     driverList2 =
//           //     box.read('driver2');
//           DateTime parsedDate = DateTime.parse(item['dateCourse']);
//           DateTime utcDate = parsedDate.toUtc();
//           return Padding(
//             padding: MediaQuery.of(context).viewInsets,
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height / 3,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 45,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Client Absent',
//                             style: TextStyle(
//                               color: Color(0xFF524D4D),
//                               fontSize: 18,
//                               fontFamily: 'Kanit',
//                               fontWeight: FontWeight.w500,
//                               height: 0.05,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 95,
//                     ),
//                     Divider(
//                       thickness: 0.5,
//                       color: Colors.grey,
//                     ),
//                     SizedBox(
//                       height: 9,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0x07000000),
//                             blurRadius: 10,
//                             offset: Offset(0, 0),
//                             spreadRadius: 8,
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: TextFormField(
//                           controller: reassign,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: InputBorder.none,
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                     color: Colors.red, width: 1.2),
//                               ),
//                               labelText: "Commentaire",
//                               labelStyle: TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 color: Color(0xFFA4A4A4),
//                               ) // Placeholder text
//                               ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please Enter Comment';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 250,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   primary: Color(0xFF3954A4)),
//                               child: Text('Confirmer'),
//                               onPressed: () {
//                                 // returnRide();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   TextEditingController reassign = TextEditingController();

//   Future<List<Map<String, dynamic>>> returnRide2() async {
//     final box = GetStorage();
//     final _token = box.read('token') ?? '';
//     final courseId = box.read('courseId2');

//     print("courseId conditionally called in function : $courseId");

//     final storage = GetStorage();
//     final userId = storage.read('user_id');

//     final configData = await rootBundle.loadString('assets/config/config.json');
//     final configJson = json.decode(configData);

//     final gestionBaseUrl = configJson['planning_baseUrl'];
//     final gestionApiKey = configJson['planning_apiKey'];

//     final gestionMainUrl =
//         gestionBaseUrl + "api/affectation/course/" + courseId.toString();

//     var headers = {
//       'x-api-key': '$gestionApiKey',
//       'Authorization': 'Bearer ' + _token
//     };

//     var request = http.Request('POST', Uri.parse(gestionMainUrl));
//     request.body = json.encode(
//         {"chauffeur": userId.toString(), "motifAnnulation": reassign.text});
//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       print(await response.stream.bytesToString());

//       Get.snackbar(
//         colorText: Colors.white,
//         'Success',
//         'Ride is Returned',
//         backgroundColor: Color.fromARGB(255, 8, 213, 59),
//         snackStyle: SnackStyle.FLOATING,
//         margin: const EdgeInsets.all(10),
//         borderRadius: 10,
//         isDismissible: true,
//         dismissDirection: DismissDirection.up,
//         forwardAnimationCurve: Curves.easeOutBack,
//         reverseAnimationCurve: Curves.easeInCirc,
//         duration: const Duration(seconds: 3),
//         barBlur: 0,
//         messageText: const Text(
//           'Ride is Returned',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16.0,
//           ),
//         ),
//       );

//       Navigator.of(context).pop();
//     } else {
//       print(response.reasonPhrase);
//     }
//     return [];
//   }

//   Future<dynamic> AnnularAffectationBottomSheet(
//       BuildContext context, GetStorage box, Map<String, dynamic> item) {
//     return showModalBottomSheet(
//         backgroundColor: Color(0xFFE6F7FD),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(38),
//           ),
//         ),
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           final TextEditingController _controller = TextEditingController();
//           String? _selectedValue;
//           List<dynamic> driverList3 = box.read('driver2');
//           DateTime parsedDate = DateTime.parse(item['dateCourse']);
//           DateTime utcDate = parsedDate.toUtc();
//           return Padding(
//             padding: MediaQuery.of(context).viewInsets,
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height / 1.5,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 45,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Annuler Affectation',
//                             style: TextStyle(
//                               color: Color(0xFF524D4D),
//                               fontSize: 18,
//                               fontFamily: 'Kanit',
//                               fontWeight: FontWeight.w500,
//                               height: 0.05,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 95,
//                     ),
//                     Divider(
//                       thickness: 0.5,
//                       color: Colors.grey,
//                     ),
//                     SizedBox(
//                       height: 9,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: 50,
//                         decoration: ShapeDecoration(
//                           color: Colors.grey.shade200,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             if (item['reference'] == "") Text("No Reference"),
//                             Text(item['reference']),
//                             Text('-'),
//                             Text(DateFormat(
//                                     'dd-MM-yyyy         -         hh:mm a')
//                                 .format(utcDate)),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0x07000000),
//                             blurRadius: 10,
//                             offset: Offset(0, 0),
//                             spreadRadius: 8,
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: TextFormField(
//                           controller: reassign,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: InputBorder.none,
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                     color: Colors.red, width: 1.2),
//                               ),
//                               labelText: "Motif d'annulation",
//                               labelStyle: TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 color: Color(0xFFA4A4A4),
//                               ) // Placeholder text
//                               ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please Enter Motif';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0x07000000),
//                             blurRadius: 10,
//                             offset: Offset(0, 0),
//                             spreadRadius: 8,
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: DropdownButtonFormField<String>(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             border: InputBorder.none,
//                             errorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                   color: Colors.red, width: 1.2),
//                             ),
//                             labelText: "Choisir Chauffeur",
//                             labelStyle: TextStyle(
//                               fontWeight: FontWeight.w900,
//                               color: Color(0xFFA4A4A4),
//                             ),
//                           ),
//                           value: _selectedValue,
//                           items: driverList3.map((dynamic item) {
//                             return DropdownMenuItem<String>(
//                               value: item['nom'].toString() +
//                                   item['prenom'].toString(),
//                               child: Row(
//                                 children: [
//                                   Text(item['nom'].toString()),
//                                   Text(item['prenom'].toString()),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) {
//                             setState(() {
//                               _selectedValue = value;
//                               _controller.text = value ?? '';
//                             });
//                           },
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please Choose an Option';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 250,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   primary: Color(0xFF3954A4)),
//                               child: Text('Confirmer'),
//                               onPressed: () {
//                                 returnRide2();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   List<Map<String, dynamic>> AdminFuture = [];

//   List<bool> handOpenToday = [];

//   Future<List<Map<String, dynamic>>> TripListFutureAdmin() async {
//     setState(() {
//       isRefreshed = true;
//     });
//     final box = GetStorage();
//     final _token = box.read('token') ?? '';
//     final storage = GetStorage();
//     final UserID = storage.read('user_id');

//     final configData = await rootBundle.loadString('assets/config/config.json');
//     final configJson = json.decode(configData);

//     final gestionBaseUrl = configJson['planning_baseUrl'];
//     final gestionApiKey = configJson['planning_apiKey'];

//     final gestionMainUrl = gestionBaseUrl + "mob/course-all-avenir";

//     var headers = {
//       'x-api-key': '$gestionApiKey',
//       'Authorization': 'Bearer ' + _token
//     };

//     var request = http.Request('GET', Uri.parse(gestionMainUrl));

//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final apiData = jsonDecode(responseBody);

//       print(apiData);

//       List<Map<String, dynamic>> AdminAvenir = [];
//       for (var courses in apiData['courses']) {
//         int id = courses['id'];
//         // String start = courses['start'];
//         int nombrePassager = courses['nombrePassager'];
//         String commentaire = courses['commentaire'];
//         String paiement = courses['paiement'];
//         String chauffeur = courses['chauffeur'];
//         int client = courses['client'];
//         var affectationCourses = courses['affectationCourses'];
//         String reference = courses['reference'];
//         String backgroundColor = courses['backgroundColor'];
//         String dateCourse = courses['dateCourse'];
//         // String distanceTrajet = courses['distanceTrajet'];
//         // String dureeTrajet = courses['dureeTrajet'];
//         String status1 = courses['affectationCourses'][0]['status1'];
//         String status2 = courses['affectationCourses'][0]['status2'];
//         String nom = courses['clientDetails']['nom'];
//         String prenom = courses['clientDetails']['prenom'];
//         String telephone = courses['clientDetails']['tel1'];
//         String driverNom = courses['chauffeurDetails']['nom'];
//         String driverPrenom = courses['chauffeurDetails']['prenom'];
//         int region = courses['region'];
//         String depart = courses['depart'];
//         String arrive = courses['arrive'];
//         int tarif = courses['tarif'];

//         int imgType = courses['clientDetails']['typeClient']['id'] ?? "";

//         // print('Depart in admin list: $tarif');
//         AdminAvenir.add({
//           'id': id,
//           // 'start': start,
//           'nombrePassager': nombrePassager,
//           'commentaire': commentaire,
//           'paiement': paiement,
//           'reference': reference,
//           'dateCourse': dateCourse,
//           'chauffeur': chauffeur,
//           // 'distanceTrajet': distanceTrajet,
//           // 'dureeTrajet': dureeTrajet,
//           'client': client,
//           'region': region,
//           'status1': status1,
//           'status2': status2,
//           'backgroundColor': backgroundColor,
//           'nom': nom,
//           'prenom': prenom,
//           'telephone': telephone,
//           'imgType': imgType,
//           'depart': depart,
//           'arrive': arrive,
//           'tarif': tarif,
//           'driverNom': driverNom,
//           "driverPrenom": driverPrenom
//         });
//       }

//       setState(() {
//         AdminFuture = AdminAvenir;
//         handOpenToday = List.generate(AdminFuture.length, (index) => false, growable: true);
//       });
//       setState(() {
//         isRefreshed = false;
//       });

//       print('Admin AVenir with reference: ${AdminAvenir}');
//       box.write('AdminAvenir5', AdminAvenir);

//       return AdminAvenir;
//     } else {
//       print(response.reasonPhrase);
//     }

//     return [];
//   }

//   bool isRefreshed = false;

//   ScrollController controller = ScrollController();

//   int currentPage = 1;
//   int itemsPerPage = 10;

//   int calculateItemCount() {
//     int itemCount = 0;

//     itemCount += (currentPage * itemsPerPage);

//     if (itemCount > AdminFuture.length) {
//       // Adjust itemCount without using setState
//       print('PresentList length: ${AdminFuture.length}');
//       itemCount = AdminFuture.length;
//       print('Item Count adjusted: $itemCount');
//       return itemCount;
//     }

//     return itemCount;
//   }

//   Widget _buildTextButton(String text, bool hovered) {
//     return Container(
//       height: 90,
//       width: 190,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         // color: Colors.white,
//       ),
//       child: Center(
//           child: Text(
//         overflow: TextOverflow.ellipsis,
//         text,
//         style: TextStyle(color: Colors.white, fontSize: 14.5),
//       )),
//     );
//   }

//   String M = " ";

//   Future<bool> canLaunchGoogleMap() async {
//     final url = 'https://www.google.com/maps/';
//     return await canLaunch(url);
//   }

//   Future<bool> canLaunchWazeMap() async {
//     final url = 'https://www.waze.com/';
//     return await canLaunch(url);
//   }

//   Future<void> currentLocaionlaunchMap(String destination) async {
//     final url =
//         'https://www.google.com/maps/dir/?api=1&destination=$destination';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//     void showMapDialog(
//       BuildContext context, double latitude, double longitude) async {
//     final availableMaps = await MapLauncher.installedMaps;

//     Coords currentLocation = await getCurrentLocation();

//     print('Latitude1: $latitude');
//     print('longitude1: $longitude');

//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         elevation: 0.0,
//         backgroundColor: Colors.transparent,
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Color(0xFFE6F7FD),
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           height: MediaQuery.of(context).size.height / 2,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Available Map Options',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 22,
//                       fontFamily: 'Kanit',
//                       fontWeight: FontWeight.w500,
//                       height: 0,
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Divider(
//                 color: Colors.black,
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: availableMaps.length,
//                   itemBuilder: (context, index) {
//                     final map = availableMaps[index];
//                     return Column(
//                       children: [
//                         SizedBox(height: 10),
//                         ListTile(
//                           leading: SvgPicture.asset(
//                             map.icon,
//                             height: 50,
//                             width: 50,
//                           ),
//                           title: Text(
//                             map.mapName,
//                             style: TextStyle(
//                               color: Color(0xFF6E6868),
//                               fontSize: 22,
//                               fontFamily: 'Kanit',
//                               fontWeight: FontWeight.w500,
//                               height: 0,
//                             ),
//                           ),
//                           onTap: () async {
//                             await map.showDirections(
//                               directionsMode: DirectionsMode.driving,
//                               origin: currentLocation,
//                               destination: Coords(latitude, longitude),
//                             );

//                             Navigator.of(context).pop(); // Close the dialog
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Container(
//                   width: 333,
//                   height: 42,
//                   decoration: ShapeDecoration(
//                     color: Color(0xFF3556A7),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                     shadows: [
//                       BoxShadow(
//                         color: Color(0x07000000),
//                         blurRadius: 10,
//                         offset: Offset(0, 0),
//                         spreadRadius: 8,
//                       )
//                     ],
//                   ),
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 15),
//                       child: Text(
//                         'Annuler',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontFamily: 'Kanit',
//                           fontWeight: FontWeight.w500,
//                           height: 0.04,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showMapChooserDialog2(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width / 1.15,
//             padding: EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Color(0xFFE6F7FD),
//               borderRadius: BorderRadius.circular(16.0),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Choisissez l'application pour lancer la carte",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20.0,
//                     fontFamily: 'Kanit',
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20.0),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListTile(
//                     onTap: () async {
//                       if (await canLaunchGoogleMap()) {
//                         currentLocaionlaunchMap(M);
//                       } else {
//                         _showAppNotInstalledSnackBar(context, 'Google Maps');
//                       }
//                     },
//                     leading: Image.asset('assets/images/gmaps.png'),
//                     title: Text(
//                       'Google Maps',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20.0,
//                         fontFamily: 'Kanit',
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListTile(
//                     onTap: () async {
//                       if (await canLaunchWazeMap()) {
//                         currentLocaionlaunchMap(M);
//                       } else {
//                         _showAppNotInstalledSnackBar(context, 'Waze');
//                       }
//                     },
//                     leading: Image.asset('assets/images/waze.png'),
//                     title: Text(
//                       'Waze',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20.0,
//                         fontFamily: 'Kanit',
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 Container(
//                   width: 250,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       primary: Color(0xFF3954A4),
//                     ),
//                     child: Text('Annuler'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showAppNotInstalledSnackBar(BuildContext context, String appName) {
//     Get.snackbar(
//         backgroundColor: Colors.white,
//         '$appName is not installed on your device',
//         "Please Select other Option..!! ");
//   }

//   @override
//   void initState() {
//     super.initState();
//     TripListFutureAdmin();
//   }

//   Future<Coords> getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     return Coords(position.latitude, position.longitude);
//   }

//   void showmapBottomSheet(
//       BuildContext context, double Latitude, double Longitude) async {
//     final availableMaps = await MapLauncher.installedMaps;

//     Coords currentLocation = await getCurrentLocation();

//     print('Latitude1: $Latitude');
//     print('longitude1: $Longitude');

//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         // Adjust the height of the bottom sheet as needed
//         height: 200,
//         child: ListView.builder(
//           itemCount: availableMaps.length,
//           itemBuilder: (context, index) {
//             final map = availableMaps[index];
//             return Column(
//               children: [
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Available Map Options',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 22,
//                         fontFamily: 'Kanit',
//                         fontWeight: FontWeight.w500,
//                         height: 0,
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 ListTile(
//                   leading: SvgPicture.asset(
//                     map.icon,
//                     height: 24,
//                     width: 24,
//                   ),
//                   title: Text(
//                     map.mapName,
//                     style: TextStyle(
//                       color: Color(0xFF6E6868),
//                       fontSize: 20,
//                       fontFamily: 'Kanit',
//                       fontWeight: FontWeight.w500,
//                       height: 0,
//                     ),
//                   ),
//                   onTap: () async {
//                     await map.showDirections(
//                       directionsMode: DirectionsMode.driving,
//                       origin: currentLocation,
//                       destination: Coords(Latitude, Longitude),
//                       // coords: Coords(Latitude, Longitude),
//                       // title: "Destination",
//                     );

//                     Navigator.of(context).pop(); // Close the bottom sheet
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   double Latitude1 = 0.00;
//   double longitude1 = 0.00;
//   double Latitude2 = 0.00;
//   double longitude2 = 0.00;

//   Future<Map<String, double>> addressToCoordinates1(String address) async {
//     print('inside the function');
//     try {
//       List<Location> locations = await locationFromAddress(address);

//       if (locations.isNotEmpty) {
//         double latitude = locations.first.latitude;
//         double longitude = locations.first.longitude;

//         setState(() {
//           Latitude1 = latitude;
//           longitude1 = longitude;
//         });

//         print('Latitude1: $Latitude1');
//         print('longitude1: $longitude1');
//         return {'latitude': latitude, 'longitude': longitude};
//       } else {
//         throw Exception("No coordinates found for the given address");
//       }
//     } catch (e) {
//       print("Error converting address to coordinates: $e");
//       rethrow;
//     }
//   }

//   Future<Map<String, double>> addressToCoordinates2(String address) async {
//     print('inside the function');
//     try {
//       List<Location> locations = await locationFromAddress(address);

//       if (locations.isNotEmpty) {
//         double latitude = locations.first.latitude;
//         double longitude = locations.first.longitude;

//         setState(() {
//           Latitude2 = latitude;
//           longitude2 = longitude;
//         });

//         print('Latitude1: $Latitude1');
//         print('longitude1: $longitude1');
//         return {'latitude': latitude, 'longitude': longitude};
//       } else {
//         throw Exception("No coordinates found for the given address");
//       }
//     } catch (e) {
//       print("Error converting address to coordinates: $e");
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: isRefreshed
//               ? Center(
//                   child: CircularProgressIndicator(color: Color(0xFF3954A4)),
//                 )
//               : ((calculateItemCount() == 0) && (AdminFuture.length == 0))
//                   ? Center(
//                       child: ListView(
//                         shrinkWrap: true,
//                         children: [
//                           Column(
//                             children: [
//                               Container(
//                                   height: 150,
//                                   width: 200,
//                                   child:
//                                       Image.asset('assets/images/notrips.png')),
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       controller: controller,
//                       itemCount: calculateItemCount(),
//                       itemBuilder: (context, index) {
//                         Map<String, dynamic> item = AdminFuture[index];

//                         String status1 = item['status1'] ?? '';
//                         String status2 = item['status2'] ?? '';
//                         String date = item['dateCourse'] ?? '';
//                         String imgType = item['imgType'].toString();
//                         DateTime dateTime = DateTime.parse(date);
//                         tz.TZDateTime parisDateTime = tz.TZDateTime.from(
//                             dateTime, tz.getLocation('Europe/Paris'));
//                         String formattedDate =
//                             DateFormat("dd MMM HH:mm").format(parisDateTime);

//                         print(
//                             'Bool List after generating Today : $handOpenToday');

//                         print(
//                             'Image type for vehicle image in card trip: $imgType');
//                         Image? getImageBasedOnType(String imgType) {
//                           switch (imgType) {
//                             case "1":
//                               return Image.asset('assets/images/taxiCart.png');
//                             case "2":
//                               return Image.asset(
//                                   'assets/images/ambulanceCart.png');
//                             case "3":
//                               return Image.asset(
//                                   'assets/images/schoolbusCart.png');
//                             default:
//                               return null;
//                           }
//                         }

//                         String statusText;
//                         switch ("$status1-$status2") {
//                           case "0-0":
//                             statusText = "En Attente";
//                             break;
//                           case "1-0":
//                             statusText = "Accepter";
//                             break;
//                           case "1-1":
//                             statusText = "En Route";
//                             break;
//                           case "1-2":
//                             statusText = "Sur Place";
//                             break;
//                           case "1-3":
//                             statusText = "Absent ";
//                             break;
//                           case "1-4":
//                             statusText = "Terminé";
//                             break;
//                           case "1-5":
//                             statusText = "Abord";
//                             break;
//                           default:
//                             statusText = "No Status Available";
//                             break;
//                         }

//                         Color _getStatusColor(String status1, String status2) {
//                           switch ("$status1-$status2") {
//                             case '1-1':
//                               return HexColor('#bbacac');
//                             case '0-0':
//                               return HexColor('#f17407');
//                             case '1-2':
//                               return Colors.yellow.shade600;
//                             case '1-5':
//                               return HexColor('#0F056B');
//                             case '1-3':
//                               return HexColor('#fd6c9e');
//                             case '1-4':
//                               return HexColor('#811453');
//                             case '1-0':
//                               return HexColor('#0AAF20');
//                             default:
//                               return Color(0xFF135DB9);
//                           }
//                         }

//                         Future<void> currentLocaionlaunchMap(
//                             String destination) async {
//                           final url =
//                               'https://www.google.com/maps/dir/?api=1&destination=$destination';
//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           } else {
//                             throw 'Could not launch $url';
//                           }
//                         }

//                         return Padding(
//                           padding: const EdgeInsets.only(right: 12),
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 15),
//                             width: 411,
//                             height: (handOpenToday![index]) ? 320 : 215,
//                             decoration: ShapeDecoration(
//                               color: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               shadows: [
//                                 BoxShadow(
//                                   color: Color(0x3F000000),
//                                   blurRadius: 4,
//                                   offset: Offset(0, 0),
//                                   spreadRadius: 0,
//                                 )
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Text(
//                                         formattedDate,
//                                         style: TextStyle(
//                                           color: Color(0xFF3954A4),
//                                           fontSize: 16,
//                                           fontFamily: 'Kanit',
//                                           fontWeight: FontWeight.w500,
//                                           height: 0,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10),
//                                   child: ListTile(
//                                     visualDensity: VisualDensity(
//                                         vertical: -4, horizontal: -4),
//                                     minLeadingWidth: 0,
//                                     leading: getImageBasedOnType(imgType),
//                                     title: Text(
//                                       '${item['nom']} ${item['prenom']}',
//                                       style: TextStyle(
//                                         color: Color(0xFF524D4D),
//                                         fontSize: 16.5,
//                                         fontFamily: 'Kanit',
//                                         fontWeight: FontWeight.w500,
//                                         height: 0,
//                                       ),
//                                     ),
//                                     trailing: IconButton(
//                                         onPressed: () async {
//                                           final call = Uri.parse(
//                                               'tel:${item['telephone']}');
//                                           if (await canLaunchUrl(call)) {
//                                             launchUrl(call);
//                                           } else {
//                                             throw 'Could not launch $call';
//                                           }
//                                         },
//                                         icon: Icon(
//                                           Icons.phone,
//                                           color: Colors.black,
//                                           size: 30,
//                                         )),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 30,
//                                       height: 93,
//                                       decoration: ShapeDecoration(
//                                         color:
//                                             _getStatusColor(status1, status2),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(50),
//                                             bottomRight: Radius.circular(50),
//                                           ),
//                                         ),
//                                       ),
//                                       child: RotatedBox(
//                                         quarterTurns: 1,
//                                         child: Center(
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 10, top: 10),
//                                             child: Text(
//                                               statusText,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 14,
//                                                 fontFamily: 'Kanit',
//                                                 fontWeight: FontWeight.w300,
//                                                 height: 0.12,
//                                               ),
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               1.25,
//                                           child: Row(
//                                             children: [
//                                               Image.asset(
//                                                   'assets/images/location3.png'),
//                                               SizedBox(
//                                                 width: 15,
//                                               ),
//                                               Flexible(
//                                                 child: GestureDetector(
//                                                   onTap: () async {
//                                                     String address1 =
//                                                         item['depart'];
//                                                     await addressToCoordinates1(
//                                                         address1);
//                                                     showMapDialog(context,
//                                                         Latitude1, longitude1);
//                                                   },
//                                                   child: Text(
//                                                     item['depart'],
//                                                     style: TextStyle(
//                                                       color: Color(0xFF524D4D),
//                                                       fontSize: 14,
//                                                       fontFamily: 'Kanit',
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       height: 0,
//                                                     ),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 20),
//                                               IconButton(
//                                                   onPressed: () {
//                                                     Get.to(() => TripDetails(),
//                                                         arguments: [
//                                                           item['id'].toString(),
//                                                         ]);
//                                                   },
//                                                   icon: Icon(
//                                                     Icons.error_outline,
//                                                     color: Colors.black,
//                                                     size: 30,
//                                                   )),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Container(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               1.25,
//                                           child: Row(
//                                             children: [
//                                               Image.asset(
//                                                   'assets/images/location4.png'),
//                                               SizedBox(
//                                                 width: 15,
//                                               ),
//                                               Flexible(
//                                                 child: GestureDetector(
//                                                   onTap: () async {
//                                                     String address1 =
//                                                         item['arrive'];
//                                                     await addressToCoordinates1(
//                                                         address1);
//                                                     showMapDialog(context,
//                                                         Latitude1, longitude1);
//                                                   },
//                                                   child: Text(
//                                                     item['arrive'],
//                                                     style: TextStyle(
//                                                       color: Color(0xFF524D4D),
//                                                       fontSize: 14,
//                                                       fontFamily: 'Kanit',
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       height: 0,
//                                                     ),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 20),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 ListTile(
//                                   leading:
//                                       Image.asset('assets/images/arrow.png'),
//                                   title: Text(
//                                     'Options and Comment :',
//                                     style: TextStyle(
//                                       color: Color(0xFF524D4D),
//                                       fontSize: 14,
//                                       fontFamily: 'Kanit',
//                                       fontWeight: FontWeight.w400,
//                                       height: 0,
//                                     ),
//                                   ),
//                                   onTap: () {
//                                     setState(() {
//                                       handOpenToday![index] =
//                                           !handOpenToday![index];
//                                     });
//                                   },
//                                   trailing: PieMenu(
//                                     theme: PieTheme.of(context).copyWith(
//                                       buttonTheme: PieButtonTheme(
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         backgroundColor: Colors.deepOrange,
//                                         iconColor: Colors.white,
//                                       ),
//                                       buttonThemeHovered: const PieButtonTheme(
//                                         backgroundColor: Colors.orangeAccent,
//                                         iconColor: Colors.black,
//                                       ),
//                                       brightness: Brightness.dark,
//                                     ),
//                                     actions: [
//                                       PieAction.builder(
//                                         buttonTheme: PieButtonTheme(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Colors.white,
//                                                     blurRadius: 4,
//                                                     offset: Offset(0, 0),
//                                                     spreadRadius: 0,
//                                                   )
//                                                 ],
//                                                 color: Color(0xFF3954A4)),
//                                             backgroundColor: Colors.yellow[400],
//                                             iconColor: null),
//                                         tooltip: const Text('Return\nRide'),
//                                         onSelect: () async {
//                                           box.write('regionId3',
//                                               item['region'].toString());
//                                           final id = box.read('regionId3');
//                                           print('Id for the bottomsheet: $id');
//                                           DriverList2();
//                                           await AnnularAffectationBottomSheet(
//                                                   context, box, item)
//                                               .whenComplete(
//                                                   () => reassign.text = "")
//                                               .whenComplete(() => setState(() {
//                                                     isRefreshed = true;
//                                                     Future.delayed(
//                                                         Duration(
//                                                             milliseconds: 300),
//                                                         () {
//                                                       setState(() {
//                                                         isRefreshed = false;
//                                                       });
//                                                     });
//                                                   }));
//                                           // DriverList2();
//                                         },
//                                         builder: (hovered) {
//                                           return _buildTextButton(
//                                               'Return\nRide', hovered);
//                                         },
//                                       ),
//                                       PieAction.builder(
//                                         buttonTheme: PieButtonTheme(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Colors.white,
//                                                     blurRadius: 4,
//                                                     offset: Offset(0, 0),
//                                                     spreadRadius: 0,
//                                                   )
//                                                 ],
//                                                 color: Color(0xFF3954A4)),
//                                             backgroundColor: Colors.yellow[400],
//                                             iconColor: null),
//                                         tooltip: const Text('Client\nAbsent'),
//                                         onSelect: () {
//                                           clientAbsentBottomSheet(context, item)
//                                               .whenComplete(() => setState(() {
//                                                     isRefreshed = true;
//                                                     Future.delayed(
//                                                         Duration(
//                                                             milliseconds: 300),
//                                                         () {
//                                                       setState(() {
//                                                         isRefreshed = false;
//                                                       });
//                                                     });
//                                                   }));
//                                           DriverList2();
//                                         },
//                                         builder: (hovered) {
//                                           return _buildTextButton(
//                                               'Client\nAbsent', hovered);
//                                         },
//                                       ),
//                                     ],
//                                     child: Stack(
//                                       clipBehavior: Clip.none,
//                                       children: [
//                                         Image.asset('assets/images/cont.png'),
//                                         Positioned(
//                                             top: 5,
//                                             left: 5,
//                                             child: Text(
//                                               '${item['driverNom']} ${item['driverPrenom']}',
//                                               style: TextStyle(
//                                                 color: Color(0xFF3954A4),
//                                                 fontSize: 13,
//                                                 fontFamily: 'Kanit',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0,
//                                               ),
//                                             )),
//                                         Positioned(
//                                           bottom: 0.25,
//                                           left: 9,
//                                           child: Container(
//                                             width: 95,
//                                             height: 26,
//                                             decoration: ShapeDecoration(
//                                               color: Color(0xFFFCA263),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                             bottom: 0,
//                                             left: 40,
//                                             child: Image.asset(
//                                                 'assets/images/hand.png'))
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 (handOpenToday![index] == true)
//                                     ? Column(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 15),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   'Tarif: ',
//                                                   style: TextStyle(
//                                                     color: Colors.black87,
//                                                     fontSize: 15,
//                                                     fontFamily: 'Kanit',
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                                 SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 Container(
//                                                   height: 45,
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width /
//                                                       1.58,
//                                                   color: Colors.grey.shade200,
//                                                   child: Center(
//                                                     child: Text(
//                                                       "${item['tarif']} €"
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontFamily: 'Kanit',
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 15),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   'Commentaire: ',
//                                                   style: TextStyle(
//                                                     color: Colors.black87,
//                                                     fontSize: 15,
//                                                     fontFamily: 'Kanit',
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                                 SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 Container(
//                                                   height: 45,
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width /
//                                                       1.58,
//                                                   color: Colors.grey.shade200,
//                                                   child: Center(
//                                                     child: Text(
//                                                       item['commentaire'],
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontFamily: 'Kanit',
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : (handOpenToday![index] == true)
//                                         ? Column(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 15),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       'Tarif: ',
//                                                       style: TextStyle(
//                                                         color: Colors.black87,
//                                                         fontSize: 15,
//                                                         fontFamily: 'Kanit',
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                     SizedBox(
//                                                       width: 5,
//                                                     ),
//                                                     Container(
//                                                       height: 45,
//                                                       width:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width /
//                                                               1.58,
//                                                       color:
//                                                           Colors.grey.shade200,
//                                                       child: Center(
//                                                         child: Text(
//                                                           "${item['tarif']} €"
//                                                               .toString(),
//                                                           style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontSize: 16,
//                                                             fontFamily: 'Kanit',
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 15),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       'Commentaire: ',
//                                                       style: TextStyle(
//                                                         color: Colors.black87,
//                                                         fontSize: 15,
//                                                         fontFamily: 'Kanit',
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                     SizedBox(
//                                                       width: 5,
//                                                     ),
//                                                     Container(
//                                                       height: 45,
//                                                       width:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width /
//                                                               1.58,
//                                                       color:
//                                                           Colors.grey.shade200,
//                                                       child: Center(
//                                                         child: Text(
//                                                           item['commentaire'],
//                                                           style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontSize: 16,
//                                                             fontFamily: 'Kanit',
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           )
//                                         : SizedBox()
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//         ),
//         Container(
//           height: 30,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: (currentPage == 1)
//                     ? Icon(
//                         Icons.arrow_back,
//                         size: 15,
//                         color: Colors.grey.shade400,
//                       )
//                     : Icon(
//                         Icons.arrow_back,
//                         size: 15,
//                       ),
//                 onPressed: () {
//                   setState(() {
//                     isRefreshed = true;
//                   });
//                   // nextPage();
//                   if (currentPage > 1) {
//                     currentPage--;
//                   } else {
//                     null;
//                   }
//                   print('Current page: $currentPage');
//                   Future.delayed(Duration(milliseconds: 600), () {
//                     setState(() {
//                       isRefreshed = false;
//                     });
//                   });
//                 },
//               ),
//               Text('${currentPage}',
//                   style: TextStyle(fontSize: 18, fontFamily: 'Kanit')),
//               (calculateItemCount() == AdminFuture.length)
//                   ? IconButton(
//                       onPressed: () {},
//                       icon: Icon(
//                         Icons.arrow_forward,
//                         color: Colors.grey.shade400,
//                         size: 15,
//                       ))
//                   : IconButton(
//                       icon: Icon(
//                         Icons.arrow_forward,
//                         size: 15,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           isRefreshed = true;
//                         });
//                         // nextPage();
//                         currentPage++;
//                         // calculateItemCount();
//                         print('Current page: $currentPage');
//                         Future.delayed(Duration(milliseconds: 600), () {
//                           setState(() {
//                             isRefreshed = false;
//                           });
//                         });
//                       },
//                     ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

import '../../tripDetails/tripDetails.dart';

GetStorage box = GetStorage();
List<Map<String, dynamic>> AdminFuture = [];
List<List<Map<String, dynamic>>> subLists = [];

List<bool> handOpenFuture =
    List.generate(AdminFuture.length, (index) => false, growable: true);

class FutureAdminList extends StatefulWidget {
  const FutureAdminList({super.key});

  @override
  State<FutureAdminList> createState() => _FutureAdminListState();
}

class _FutureAdminListState extends State<FutureAdminList> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TripListFutureAdmin();
  }

  TextEditingController reassign2 = TextEditingController();

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
      // List<dynamic> driver3 = box.read('driver2');
      // print('List for the bottomSheet : $driver3');

      // setState(() {
      //   driverList3 = driverList;
      // });

      // print('Driver list for dropdown: $driverList3');

      return driverList;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<void> ClientAbsentApi() async {
    setState(() {
      isRefreshed = true;
    });
    print('Client absent wali api mee aagya');
    print('Course id in bottom sheet : $CourseidClient');
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final courseId = box.read('courseId2');

    print("courseId conditionally called in function : $CourseidClient");
    print('Course ke liye text:${reassign2.text}');

    final storage = GetStorage();
    final userId = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "api/course/clientabsent/" + CourseidClient.toString();

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode(
      {
        "commentaire": reassign2.text,
      },
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
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
      setState(() {
        isRefreshed = false;
        CourseidClient = 0;
        reassign2.text == "";
        reassign2.clear();
        print('Course iD after removing: $CourseidClient');
        subLists.clear();
        print('Sublist: $subLists');
      });
      // _fetchAdminData();
      // handleRefresh();

      print('Client returnho gya hai');
      Navigator.of(context).pop();
    } else {
      setState(() {
        isRefreshed = false;
      });
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> clientAbsentBottomSheet(
      BuildContext context, Map<String, dynamic> item) {
    GlobalKey<FormState> clientKey = GlobalKey<FormState>();
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
          // final TextEditingController
          //     _controller =
          //     TextEditingController();
          // String?
          //     _selectedValue;
          // List<dynamic>
          //     driverList2 =
          //     box.read('driver2');
          DateTime parsedDate = DateTime.parse(item['dateCourse']);
          DateTime utcDate = parsedDate.toUtc();
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Center(
                child: Form(
                  key: clientKey,
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
                            controller: reassign2,
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
                                  if (clientKey.currentState!.validate()) {
                                    ClientAbsentApi();
                                  }
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
            ),
          );
        });
  }

  TextEditingController reassign = TextEditingController();

  int DriverIdAnnular = 0;
  int CourseidAnnular = 0;
  int CourseidClient = 0;

  // String? _selectedValue;
  // TextEditingController _controller = TextEditingController();
  // String DriverIdAnnular = "";    LSMDKLLLMADPDAKKSSLLPORIRNFN FOIN

  Future<List<Map<String, dynamic>>> returnRide2() async {
    print('Return ride mee aagya');
    setState(() {
      isRefreshed = true;
    });
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    final courseId = box.read('courseIdAnnular');

    print("courseId conditionally called in function : $CourseidAnnular");
    print('Annular Api Text: ${reassign.text}');

    final storage = GetStorage();
    final userId = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['planning_baseUrl'];
    final gestionApiKey = configJson['planning_apiKey'];

    final gestionMainUrl =
        gestionBaseUrl + "api/affectation/course/" + CourseidAnnular.toString();

    print("Main Url with course id: $gestionMainUrl");
    print('Driver id for return ride function: $DriverIdAnnular');

    final DriverId = box.read('driverIdAdmin');
    print('Driver id through get storage: $DriverId');

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body = json.encode({
      "chauffeur": DriverIdAnnular.toString(),
      "motifAnnulation": reassign.text
    });
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
      setState(() {
        isRefreshed = false;
        box.remove('courseIdAnnular');
        CourseidAnnular = 0;
        reassign.text == "";
        reassign.clear();
        driverNameBox =="REGION";
        print('Course iD after removing: $CourseidAnnular');
      });
      // TripListToday();
      // handleRefresh();
      print('Ride return ho gyi..');

      Navigator.of(context).pop();
      // _fetchAdminData();
    } else {
      setState(() {
        isRefreshed = false;
      });
      print(response.reasonPhrase);
    }
    return [];
  }

  String driverNameBox = box.read('driverName') ?? 'DRIVER';
  final ValueNotifier<String> selectedDriverNotifier =
      ValueNotifier<String>("DRIVER");

  final TextEditingController searchController3 = TextEditingController();

  Future<dynamic> AnnularAffectationBottomSheet(
      BuildContext context, GetStorage box, Map<String, dynamic> item) {
    GlobalKey<FormState> annularKey = GlobalKey<FormState>();

    final height = MediaQuery.of(context).size.height;

    List<Map<String, dynamic>> driverList3 = box.read('driver2');

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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: height < 360
                    ? MediaQuery.of(context).size.height / 1.75
                    : MediaQuery.of(context).size.height / 2,
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
                                if (item['reference'] == "")
                                  Text("No Reference"),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            index) {
                                      final box = GetStorage();
                                      List<dynamic> allDrivers =
                                          (box.read('driver2') ?? []);

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
                                                                Image.asset(
                                                                    'assets/images/no-drivers.png'),
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
                                                                              box.write('driverNameAdmin', driverName);
                                                                              setState(() {
                                                                                driverNameBox = box.read('driverNameAdmin');
                                                                                DriverIdAnnular = item['id'];
                                                                                print('Dirver Id in anullar main driver sheet: $DriverIdAnnular');
                                                                              });
                                                                              // final box = GetStorage();
                                                                              String driverid = item['id'].toString();
                                                                              print('Driver Id for filter:  $driverid');
                                                                              box.write('driverIdAdmin', driverid);
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
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
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
                                              DriverIdAnnular = 0;
                                              print(
                                                  'Driver Id: $DriverIdAnnular');
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
        });
  }

  Future<List<Map<String, dynamic>>> TripListFutureAdmin() async {
    setState(() {
      isRefreshed = true;
    });
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
        // String chauffeur = courses['chauffeur'];
        int client = courses['client'];
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

        String chauffeur = courses['chauffeur'];
    
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

      setState(() {
        AdminFuture = AdminAvenir;
      });

      // print('Admin AVenir with reference: ${AdminAvenir}');
      box.write('AdminAvenir5', AdminAvenir);
      List<dynamic> adminToday2 = box.read('AdminAvenir5');
      print('Admin Today in storage with refernce and date : $adminToday2');

      setState(() {
        isRefreshed = false;
      });

      return AdminAvenir;
    } else {
      setState(() {
        isRefreshed = false;
      });
      throw Exception('Failed to fetch admin data: ${response.reasonPhrase}');
    }
  }

  bool isRefreshed = false;

  ScrollController controller = ScrollController();

  int currentPage = 1;
  int itemsPerPage = 10;
  int currentIndex = 0;

  int calculateItemCount() {
    int itemCount = 0;

    itemCount += (currentPage * itemsPerPage);

    if (itemCount > AdminFuture.length) {
      // Adjust itemCount without using setState
      print('PresentList length: ${AdminFuture.length}');
      itemCount = AdminFuture.length;
      print('Item Count adjusted: $itemCount');
      return itemCount;
    }

    return itemCount;
  }

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
  void initState() {
    super.initState();
    setState(() {
      isRefreshed = true;
    });
    TripListFutureAdmin();

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        isRefreshed = false;
      });
    });
    setState(() {
      subLists.clear();
    });
    _fetchAdminData();
  }

  Future<void> _fetchAdminData() async {
    setState(() {
      isRefreshed = true;
    });
    try {
      // subLists.clear();
      final List<Map<String, dynamic>> adminData = await TripListFutureAdmin();
      setState(() {
        AdminFuture = adminData;
      });
      // Splitting 'admin' list into sublists of 10 items each
      for (int i = 0; i < AdminFuture.length; i += 10) {
        final endIndex =
            (i + 10 < AdminFuture.length) ? i + 10 : AdminFuture.length;
        subLists.add(AdminFuture.sublist(i, endIndex));
      }

      setState(() {
        isRefreshed = false;
      });

      print('Admin data fetched successfully');
    } catch (error) {
      setState(() {
        isRefreshed = false;
      });
      print('Error fetching admin data: $error');
    }
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
                : (AdminFuture.isEmpty)
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
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: controller,
                        itemCount: subLists.isEmpty
                            ? 0
                            : subLists[currentIndex].length,
                        itemBuilder: (BuildContext context, int index) {
                          // Display each item in the sublist as a ListTile
                          final item = subLists[currentIndex][index];

                          String status1 = item['status1'] ?? '';
                          String status2 = item['status2'] ?? '';
                          String date = item['dateCourse'] ?? '';
                          String imgType = item['imgType'].toString();
                          DateTime dateTime = DateTime.parse(date);
                          tz.TZDateTime parisDateTime = tz.TZDateTime.from(
                              dateTime, tz.getLocation('Europe/Paris'));
                          String formattedDate = DateFormat("dd.MMM.yyyy HH:mm")
                              .format(parisDateTime);

                          print(
                              'Bool List after generating Today : $handOpenFuture');

                          print(
                              'Image type for vehicle image in card trip: $imgType');
                          Image? getImageBasedOnType(String imgType) {
                            switch (imgType) {
                              case "1":
                                return Image.asset(
                                    'assets/images/taxiCart.png');
                              case "2":
                                return Image.asset(
                                    'assets/images/ambulanceCart.png');
                              case "3":
                                return Image.asset(
                                    'assets/images/schoolbusCart.png');
                              default:
                                return null;
                            }
                          }

                            String statusText;
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
                              statusText = "Client Absent";
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
                                return HexColor('#E21313');
                              case '1-4':
                                return HexColor('#811453');
                              case '1-6':
                                return HexColor('#E21313');
                              case '1-0':
                                return HexColor('#0AAF20');
                              case '3-6':
                                return HexColor("#000000");
                              default:
                                return Color(0xFF135DB9);
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

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              width: 411,
                              height:
                                  handOpenFuture[index] == true ? 320 : 215,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
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
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          formattedDate,
                                          style: TextStyle(
                                            color: Color(0xFF3954A4),
                                            fontSize: 16,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ListTile(
                                      visualDensity: VisualDensity(
                                          vertical: -4, horizontal: -4),
                                      minLeadingWidth: 0,
                                      leading: getImageBasedOnType(imgType),
                                      title: Text(
                                        overflow: TextOverflow.ellipsis,
                                        '${item['nom']} ${item['prenom']}',
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 16.5,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () async {
                                            final call = Uri.parse(
                                                'tel:${item['telephone']}');
                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          },
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 93,
                                        decoration: ShapeDecoration(
                                          color:
                                              _getStatusColor(status1, status2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                          ),
                                        ),
                                        child: RotatedBox(
                                          quarterTurns: 1,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, top: 10),
                                              child: Text(
                                                statusText,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Kanit',
                                                  fontWeight: FontWeight.w300,
                                                  height: 0.12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.25,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/images/location3.png'),
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
                                                              color: Color(
                                                                  0xFF3954A4),
                                                            ),
                                                          ),
                                                          barrierDismissible:
                                                              false);
                                                      await showMapDialog1(
                                                          context,
                                                          item["depart"]);
                                                    },
                                                    child: Text(
                                                      item['depart'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF524D4D),
                                                        fontSize: 14,
                                                        fontFamily: 'Kanit',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                IconButton(
                                                    onPressed: () {
                                                      Get.to(() => TripDetails(
                                                            Screen: 'admin',
                                                            id: item['id']
                                                                .toString(),
                                                          ));
                                                    },
                                                    icon: Icon(
                                                      Icons.error_outline,
                                                      color: Colors.black,
                                                      size: 30,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.25,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/images/location4.png'),
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
                                                              color: Color(
                                                                  0xFF3954A4),
                                                            ),
                                                          ),
                                                          barrierDismissible:
                                                              false);
                                                      await showMapDialog2(
                                                          context,
                                                          item["arrive"]);
                                                    },
                                                    child: Text(
                                                      item['arrive'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF524D4D),
                                                        fontSize: 14,
                                                        fontFamily: 'Kanit',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    leading:
                                        Image.asset('assets/images/arrow.png'),
                                    title: Text(
                                      'Options and Comment :',
                                      style: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                    onTap: () {
                                      print('Tap ho rha hia');
                                      print(
                                          'Index bool: ${handOpenFuture[index]}');
                                      setState(() {
                                        handOpenFuture[index] =
                                            !handOpenFuture[index];
                                        // print('Index bool: ${handOpenToday[index]}');
                                      });
                                    },
                                    trailing: PieMenu(
                                      theme: PieTheme.of(context).copyWith(
                                        buttonTheme: PieButtonTheme(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor: Colors.deepOrange,
                                          iconColor: Colors.white,
                                        ),
                                        buttonThemeHovered:
                                            const PieButtonTheme(
                                          backgroundColor: Colors.orangeAccent,
                                          iconColor: Colors.black,
                                        ),
                                        brightness: Brightness.dark,
                                      ),
                                      actions: [
                                        PieAction.builder(
                                          buttonTheme: PieButtonTheme(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 0),
                                                      spreadRadius: 0,
                                                    )
                                                  ],
                                                  color: Color(0xFF3954A4)),
                                              backgroundColor:
                                                  Colors.yellow[400],
                                              iconColor: null),
                                          tooltip: const Text('Return\nRide'),
                                          onSelect: () async {
                                            setState(() {
                                              CourseidAnnular = item['id'];
                                            });
                                            final courseId = box.write(
                                                'courseIdAnnular', item['id']);
                                            box.write('regionId3',
                                                item['region'].toString());
                                            final id = box.read('regionId3');
                                            print(
                                                'Id for the bottomsheet: $id');
                                            Get.dialog(
                                              Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xFF3954A4),
                                                ),
                                              ),
                                              barrierDismissible: false,
                                            );
                                            await DriverList2();
                                            Get.back();
                                            AnnularAffectationBottomSheet(
                                                    context, box, item)
                                                .whenComplete(() {
                                              setState(() {
                                                isRefreshed = true;
                                                reassign.text == "";
                                              });
                                              handleRefresh();
                                              Future.delayed(
                                                  Duration(milliseconds: 300),
                                                  () {
                                                setState(() {
                                                  isRefreshed = false;
                                                });
                                              });
                                            }).whenComplete(() {
                                              setState(() {
                                                reassign.text = "";
                                                reassign.clear();
                                              });
                                            });
                                          },
                                          builder: (hovered) {
                                            return _buildTextButton(
                                                'Return\nRide', hovered);
                                          },
                                        ),
                                        PieAction.builder(
                                          buttonTheme: PieButtonTheme(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 0),
                                                      spreadRadius: 0,
                                                    )
                                                  ],
                                                  color: Color(0xFF3954A4)),
                                              backgroundColor:
                                                  Colors.yellow[400],
                                              iconColor: null),
                                          tooltip: const Text('Client\nAbsent'),
                                          onSelect: () {
                                            setState(() {
                                              CourseidClient = item["id"];
                                              print(
                                                  'Course Before bottomsheet: $CourseidClient');
                                            });
                                            clientAbsentBottomSheet(
                                                    context, item)
                                                .whenComplete(() {
                                              setState(() {
                                                isRefreshed = true;
                                                reassign.text == "";
                                              });
                                              // _fetchAdminData();
                                              handleRefresh();

                                              setState(() {
                                                isRefreshed = false;
                                              });
                                            }).whenComplete(() {
                                              setState(() {
                                                reassign2.text = "";
                                                reassign2.clear();
                                              });
                                            });

                                            DriverList2();
                                          },
                                          builder: (hovered) {
                                            return _buildTextButton(
                                                'Client\nAbsent', hovered);
                                          },
                                        ),
                                      ],
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Image.asset('assets/images/cont.png'),
                                          Positioned(
                                              top: 5,
                                              left: 5,
                                              child: Text(
                                                '${item['driverNom']} ${item['driverPrenom']}',
                                                style: TextStyle(
                                                  color: Color(0xFF3954A4),
                                                  fontSize: 13,
                                                  fontFamily: 'Kanit',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              )),
                                          Positioned(
                                            bottom: 0.25,
                                            left: 9,
                                            child: Container(
                                              width: 95,
                                              height: 26,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFFCA263),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              left: 40,
                                              child: Image.asset(
                                                  'assets/images/hand.png'))
                                        ],
                                      ),
                                    ),
                                  ),
                                  handOpenFuture[index] == true
                                      ? Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Tarif: ',
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    height: 45,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.58,
                                                    color: Colors.grey.shade200,
                                                    child: Center(
                                                      child: Text(
                                                        "${item['tarif']} €"
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Kanit',
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Commentaire: ',
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontFamily: 'Kanit',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      height: 45,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.58,
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: Center(
                                                        child: Text(
                                                          item['commentaire'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily: 'Kanit',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          );
                        }),
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
