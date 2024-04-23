// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_const_declarations, prefer_collection_literals

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/CONDITION%20GENERALES/condition.dart';
import 'package:fr.innoyadev.mkgodev/conditions/conditions.dart';
import 'package:get/get.dart';
import 'package:fr.innoyadev.mkgodev/signup/registerModel.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../login/login.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _formKey.currentState?.reset();
    signupController.nomController.text = "";
    signupController.prenomController.text = "";
    signupController.emailController.text = "";
    signupController.telephoneController.text = "";
    signupController.passwordController.text = "";
    signupController.cnfpasswordController.text = "";
    super.initState();
    urlData();
    print('RGPD Url: $RgpdUrl');
    print('ConditionS URl : $Terms');
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final SignupController signupController = Get.find();

  bool isChecked = false;
  bool isVisible = false;
  bool isSubmitButtonTapped = false;

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please Enter Valid Email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please Enter Valid Email';
    }
    return null;
  }

  String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un numéro de téléphone';
    }
    if (value.length < 8) {
      return 'Veuillez saisir un numéro de \ntéléphone comportant au between 8-15 chiffres';
    }
    if (value.length > 15) {
      return 'Veuillez saisir un numéro de \ntéléphone comportant au maximum 15 chiffres';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Veuillez saisir un numéro de \ntéléphone valide (chiffres uniquement)';
    }
    return null;
  }

  String? confirmPasswords(String password, String confirmPassword) {
    if (password.isEmpty) {
      return 'Please Enter a Password';
    }
    if (confirmPassword.isEmpty) {
      return 'Please Confirm Your Password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateCheckbox(bool? value) {
    if (value == null || !value) {
      return 'You must agree to the terms and conditions';
    }
    return null;
  }

  Future<void> submitForm() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showNoInternetError();
    } else if (_formKey.currentState!.validate() && isChecked == true) {
      await signupController.signUp();
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
                    backgroundColor: Color(0xFF3954A4),
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

  bool isLoading = false;

  String RgpdUrl = "";
  String Terms = "";

  void urlData() async {
    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final RGPD = configJson['rgpd_url'];
    final ConditionTerms = configJson['terms_url'];

    print('RGPD url: $RGPD');
    print('Terms url: $ConditionTerms');

    setState(() {
      RgpdUrl = RGPD;
      Terms = ConditionTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                Image.asset(
                  "assets/images/MKGOLogo.png",
                  width: 108,
                  height: 58,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Inscrivez-vous à votre compte",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          height: 59,
                          child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: signupController.nomController,
                              decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1.2),
                                  ),
                                  labelText: "Nom",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFA4A4A4),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Veuillez entrer votre nom.';
                                }
                                return null;
                              }),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          height: 59,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: signupController.prenomController,
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1.2),
                                ),
                                labelText: "Prenom",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFA4A4A4),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Veuillez entrer votre Prenom.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: signupController.emailController,
                      decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1.2),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFA4A4A4),
                          )),
                      validator: validateEmail),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 15,
                      keyboardType: TextInputType.number,
                      controller: signupController.telephoneController,
                      decoration: InputDecoration(
                          counterText: "",
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1.2),
                          ),
                          labelText: 'Téléphone',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFA4A4A4),
                          )),
                      validator: phoneNumber),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !isVisible,
                      controller: signupController.passwordController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible =
                                    !isVisible; // Toggle password visibility
                              });
                            },
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1.2),
                          ),
                          labelText: "Mot de passe",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFA4A4A4),
                          )),
                      validator: (password) {
                        return confirmPasswords(password!,
                            signupController.passwordController.text);
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                      controller: signupController.cnfpasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible =
                                    !isVisible; // Toggle password visibility
                              });
                            },
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1.2),
                          ),
                          labelText: 'Confirmez le mot de passe',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFA4A4A4),
                          )),
                      validator: (confirmPassword) {
                        return confirmPasswords(
                            signupController.passwordController.text,
                            confirmPassword!);
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: 370,
                  height: 59,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: Color(0xFF3954A4),
                        value: isChecked,
                        onChanged: (newValue) {
                          setState(() {
                            isChecked = newValue!;
                          });
                        },
                      ),
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.12,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'En vous inscrivant, vous acceptez le ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Termes du contrat de service',
                                  style: TextStyle(
                                    color: Color(0xFFF57F20),
                                    fontSize: 14,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('RGPD Url: $RgpdUrl');
                                      Get.to(() => CONDITIONscreen(),
                                          arguments: [Terms]);
                                    },
                                ),
                                TextSpan(
                                  text: ' et ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: 'politique de confidentialité',
                                  style: TextStyle(
                                    color: Color(0xFFF57F20),
                                    fontSize: 14,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('RGPD Url: $RgpdUrl');
                                      Get.to(() => RGPDScreen(),
                                          arguments: [RgpdUrl]);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (isSubmitButtonTapped && isChecked == false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Container(
                          child: Text(
                            'Please Accept Terms & Conditions.',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Kanit',
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Container(
                    width: 300,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Color(0xFF3954A4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3954A4)),
                        onPressed: () async {
                          if (isLoading) return;
                          setState(() {
                            isLoading = true;
                            isSubmitButtonTapped = true;
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
                            : Text(
                                "S'inscrire",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous n'avez pas de compte ?",
                      style: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontSize: 14,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          Get.offAll(() => loginScreen())?.then((value) {
                            signupController.nomController.text = "";
                            signupController.prenomController.text = "";
                            signupController.emailController.text = "";
                            signupController.telephoneController.text = "";
                            signupController.passwordController.text = "";
                            signupController.cnfpasswordController.text = "";
                          });
                        },
                        child: Text(" " + "Se connecter",
                            style: TextStyle(
                              color: Color(0xFFF57F20),
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            )))
                  ],
                ),
                SizedBox(
                  height: 90,
                )
              ],
            ),
          ),
        ));
  }
}
