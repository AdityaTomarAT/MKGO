// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/Success_page/Registration_Success_page/errorregistration.dart';
import 'package:fr.innoyadev.mkgodev/Success_page/Registration_Success_page/succesregistration.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:fr.innoyadev.mkgodev/registrationsScreens/error.dart';
// import 'package:fr.innoyadev.mkgodev/registrationsScreens/success.dart';

class RegistrationData {
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final String telephone;

  RegistrationData({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.telephone,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'telephone': telephone,
    };
  }
}

class SignupController extends GetxController {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cnfpasswordController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  Future<void> signUp() async {
    final registerModel = RegistrationData(
      nom: nomController.text,
      prenom: prenomController.text,
      email: emailController.text,
      password: passwordController.text,
      telephone: telephoneController.text,
    );

    final response = await ApiService.signUp(registerModel);

    if (response.statusCode == 200) {
      print(response.bodyBytes);
      print('User signed up successfully');
      await Get.to(()=> SuccessregistrationScreen(notes: 'User signed up successfully',));
    } 
    else {
      await Get.to(()=>Failedregistrationscreen());
      print('Failed to sign up. Error: ${response.body}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    passwordController.dispose();
    telephoneController.dispose();
    super.onClose();
  }
}

class ApiService {

  static Future<http.Response> signUp(RegistrationData registrationData) async {

     final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['gestion_baseUrl'];
    final gestionApiKey = configJson['gestion_apiKey'];

    final gestionRegisterUrl = gestionBaseUrl + "mob/register";
    


    final url = Uri.parse(gestionRegisterUrl);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'x-api-key': '$gestionApiKey',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(registrationData.toJson()),
    );

    return response;
  }

}