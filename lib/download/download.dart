// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:fr.innoyadev.mkgodev/download/expenseDetails.dart';
import 'package:fr.innoyadev.mkgodev/download/takephotoModel.dart';
import 'package:permission_handler/permission_handler.dart';

import '../expenseReport/expenseReport.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  final TakePhotoController takePhotoController =
      Get.find<TakePhotoController>();

  Future<void> checkPermission(
      Permission permission, BuildContext context) async {
    final status = await permission.request();
    if (status.isGranted) {
      print("Permission is Granted");
    } else {
      print("Permission is not Granted");
    }
  }

  String CameraPath = "";
  bool isImageLoaded = false;

  String imageFileExpense = "";
  String CameraFile = "";
  String GalleryFile = "";
  String selectedImagePath = "";
  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () async {
                    var status = await Permission.camera.status;
                    if (status.isDenied) {
                      Permission.camera.request();
                    } else {
                      takePhotoController.takePhoto(ImageSource.camera);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'Choose From Camera',
                        style: TextStyle(
                          color: Color(0xFF3954A4),
                          fontSize: 16,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    takePhotoController.takePhoto(ImageSource.gallery);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'Choose From Gallery',
                        style: TextStyle(
                          color: Color(0xFF3954A4),
                          fontSize: 16,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
                
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ExpenseReport()), (route) => false, // Remove all routes from the stack
                            );                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color(0xFF3954A4),
                            size: 30,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      'Note des frais',
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
            ),
            Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.35,
            ),
            Center(
              child: GestureDetector(
                  onTap: () async {
                    _openBottomSheet(context);
                  },
                  child: Image.asset('assets/images/download.png')),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Teecharger un fuchier\nPNG, JPG OU JPEG - max 4mb',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA3A3A3),
                fontSize: 14,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
