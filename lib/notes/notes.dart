// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/registrationsScreens/success.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:http/http.dart' as http;

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController notes = TextEditingController();
  int maxWords = 60;

  @override
  void initState() {
    super.initState();
    setState(() {
      notes.clear();
      notes.text == "";
    });
  }

  String? validateNotes(String? value) {
    if (value == null || !value.isEmpty) {
      return 'You must Enter some remarks..!!';
    }
    return null;
  }

  Future<void> postNotes() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    print("token called: $_token");

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "api/add/remarque";

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token
    };

    var request = http.Request('POST', Uri.parse(gestionMainUrl));
    request.body =
        json.encode({"message": notes.text, "createdBy": UserID.toString()});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Notes are added');
      print(await " Response of Notes Api: ${response.statusCode}");
      String notesText = "Your remarques are added successfuly!!";
      Get.to(() => SuccessRegistrationScreen(notes: notesText));
    } else {
      print(response.reasonPhrase);
    }
  }

  bool notesError = false;
  bool isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> submitForm() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showNoInternetError();
    } else if (notes.text.isEmpty) {
      Get.snackbar(
        colorText: Colors.white,
        'Remarques cannot be Empty',
        'Please fill some remarques.',
        backgroundColor: Color.fromARGB(255, 224, 8, 8),
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
          'Please fill some remarques.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );
    } else {
      postNotes().whenComplete(() {
        setState(() {
          remainingCharacters = 60;
          notes.text = "";
          FocusScope.of(context).unfocus();
        });
      });
    }
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
                    Navigator.of(context).pop();
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

  int remainingCharacters = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 130,
                decoration: BoxDecoration(color: Color(0xFF3954A4)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 35, top: 15, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Remarques',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w600,
                              height: 0,
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
                  ],
                ),
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/notes.png',
                    height: 210,
                    width: 210,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 194,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: remainingCharacters == 0
                                    ? Colors.red
                                    : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 12,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            cursorHeight: 20,
                            maxLines: null,
                            maxLength: 60,
                            controller: notes,
                            onChanged: (value) {
                              setState(() {
                                remainingCharacters = 60 - value.length;
                              });
                            },
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(),
                                counterText: "",
                                border: InputBorder.none),
                            // validator: validateNotes
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '* $remainingCharacters caractères restants',
                          style: TextStyle(
                            color: remainingCharacters == 0
                                ? Colors.red
                                : Color(0xFF524D4D),
                            fontSize: 14,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    width: 334,
                    height: 59,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff39544)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3954A4)),
                      onPressed: () async {
                        if (isLoading) return;
                        setState(() {
                          isLoading = true;
                        });
                        await submitForm();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 45,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      )),
                                  SizedBox(
                                    width: 24,
                                  ),
                                  Text('Please Wait...')
                                ],
                              ),
                            )
                          : Text("Envoyer",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
