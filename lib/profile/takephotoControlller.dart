// import 'dart:js';

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/Success_page/image/imageErr.dart';
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// import 'package:fr.innoyadev.mkgodev/profile/profile.dart';

final storage = GetStorage();

class TakePhotoController2 extends GetxController {
  RxString imageFileProfile = ''.obs;
  RxBool isImageLoaded = false.obs;

  void takephoto2(ImageSource source, BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file2Profile = await imagePicker.pickImage(source: source);
    if (file2Profile != null) {
      final storage = GetStorage();
      storage.write('imagePath2', file2Profile.path);
      print('Image file path: ${file2Profile.path}');
      imageFileProfile.value = file2Profile.path;
      print(imageFileProfile);

      isImageLoaded.value = true;
      postExpenseReport(imageFileProfile.value, context);

      // storage.write('imagePath2', imageFileProfile.value);
      // Navigator.of(context).popAndPushNamed('Profile');
    }
  }
}

Future<void> postExpenseReport(String file, BuildContext context) async {
  final box = GetStorage();
  final _token = box.read('token') ?? '';
  print("token called: $_token");

  final storage = GetStorage();
  final UserID = storage.read('user_id');

  final configData = await rootBundle.loadString('assets/config/config.json');
  final configJson = json.decode(configData);

  final gestionBaseUrl = configJson['gestion_baseUrl'];
  final gestionApiKey = configJson['gestion_apiKey'];

  final gestionMainUrl = gestionBaseUrl + "api/user-image/$UserID";

  print(
      'data For post API in expense report: $UserID, $gestionMainUrl, $file, ');
//

  var headers = {
    'x-api-key': '$gestionApiKey',
    'Authorization': 'Bearer ' + _token,
  };

  var request = http.MultipartRequest('POST', Uri.parse(gestionMainUrl));

  request.files.add(await http.MultipartFile.fromPath('file', file));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Navigator.of(context).pop();
    Get.snackbar(
        "Upload Successfull", "Your Profile Picture Uploaded Successfully..!!");
    // Get.to(()=> Profile());
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Profile()), (route) => false);

    print(await response.stream.bytesToString());
  } else {
    Get.back();
    String notes =
        "Sorry, We can't upload your Profile picture.\nPlease try again later";
    Get.to(() => ErrorImage(notes: notes));
    print(response.statusCode);
  }
}
