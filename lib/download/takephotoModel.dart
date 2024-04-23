import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fr.innoyadev.mkgodev/download/expenseDetails.dart';
import 'package:path/path.dart' as path;

final storage = GetStorage();

class TakePhotoController extends GetxController {
  RxString imageFileExpense = ''.obs; // Define as a reactive variable
  RxBool isImageLoaded = false.obs;
  final int maxFileSizeInBytes = 8 * 1024 * 1024; // 8 MB

  void takePhoto(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file2Expense = await imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (file2Expense != null) {
      final List<String> allowedExtensions = ['jpg', 'png', 'jpeg'];
      final String extension = file2Expense.path.split('.').last;

      // Check file extension
      if (allowedExtensions.contains(extension.toLowerCase())) {
        // final File imageFile = File(file2Expense.path);
       final File imageFile = File(file2Expense.path);

      // Calculate file size in megabytes
      final bytes = imageFile.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final double mb = kb / 1024;

      print('Image file size: $mb MB');
        storage.write('imagePath', file2Expense.path);

        print('Image file path: ${file2Expense.path}');

        final String fileName = path.basename(file2Expense.path);
        print('Image file name: $fileName');

        imageFileExpense.value = file2Expense.path;

        print(imageFileExpense);

        isImageLoaded.value = true;

        storage.write('imagePath', imageFileExpense.value);

        Get.to(() => ExpenseDetails(), arguments: [imageFileExpense]);
      }
    }
  }
}
