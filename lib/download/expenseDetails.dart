// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, avoid_print, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr.innoyadev.mkgodev/Success_page/SandE_notepage/successnotespage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:fr.innoyadev.mkgodev/expenseReport/expenseReport.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({super.key});

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  final RxString imagePath = Get.arguments[0];

  void bitImage() async {}

  String PathThumbnail = "";
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isImageLoaded = false;

  Future<void> generateThumbnail(String imagePath) async {
    final File imageFile = File(imagePath);
    final List<int> imageBytes = await imageFile.readAsBytes();
    final img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

    if (image == null) {
      print('Failed to load the image.');
      return;
    }

    final int thumbnailWidth = 100;
    final int thumbnailHeight = 100;

    final img.Image thumbnail = img.copyResize(
      image,
      width: thumbnailWidth,
      height: thumbnailHeight,
    );

    final Directory tempDir = await getTemporaryDirectory();

    final File thumbnailFile = File('${tempDir.path}/thumbnail.jpg');

    await thumbnailFile.writeAsBytes(img.encodeJpg(thumbnail));

    print('Thumbnail generated successfully at ${thumbnailFile.path}');
    setState(() {
      print('Thumbnail File main Path : $thumbnailFile');
      PathThumbnail = thumbnailFile.path.toString();
      print('File Thumbnail: $PathThumbnail');
    });
  }

  bool isloading = false;

  @override
  void initState() {
    super.initState();
    print('Path: $imagePath');
    generateThumbnail(imagePath.value)
        .catchError((error) => print('Error: $error'))
        .whenComplete(() => print('Thumbnail generation completed.'));

    setState(() {
      isloading = true;
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        isloading = false;
      });
    });
  }

  DateTime? finalDate;

  final String thumbnailImagePath = "";
  final TextEditingController _dateTimeController = TextEditingController();
  DateTimeTextField() {
    // final now = DateTime.now();
    final formattedDateTime =
        "${finalDate!.year}-${finalDate!.month}-${finalDate!.day} ${_formatTime(finalDate!)}";
    _dateTimeController.text = formattedDateTime;
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  final format = DateFormat("yyyy-MM-dd  HH:mm");

  Future<void> postExpenseReport() async {
    final box = GetStorage();
    final _token = box.read('token') ?? '';
    print("token called: $_token");

    final storage = GetStorage();
    final UserID = storage.read('user_id');

    final configData = await rootBundle.loadString('assets/config/config.json');
    final configJson = json.decode(configData);

    final gestionBaseUrl = configJson['compta_baseUrl'];
    final gestionApiKey = configJson['compta_apiKey'];

    final gestionMainUrl = gestionBaseUrl + "note-frais/add";

    print(
        'data For post API in expense report: $UserID, $gestionMainUrl, ${imagePath.trim()}, ${amount.text}, ${_dateTimeController.text}');

    var headers = {
      'x-api-key': '$gestionApiKey',
      'Authorization': 'Bearer ' + _token,
    };

    var request = http.MultipartRequest('POST', Uri.parse(gestionMainUrl));
    request.fields.addAll({
      'titre': title.text,
      'montant': amount.text,
      'createdBy': UserID.toString(),
      'date': _dateTimeController.text
    });
    request.files.add(
        await http.MultipartFile.fromPath('image', imagePath.value.toString()));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Get.to(() => ExpenseReport());
      String notes = "Expenses are added Successfully";
      Get.to(() => SuccessNotesScreen(
            notes: notes,
          ));
      print(await response.stream.bytesToString());
    } else {
      print(response.statusCode);
    }
  }

  bool isLoading = false;

  String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un numéro de téléphone';
    }
    return null;
  }

  String? titlerror(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un de title  ';
    }
    return null;
  }

  String? dateerror(DateTime? value) {
    if (value == null) {
      return 'Veuillez select un Date';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                              Navigator.of(context).pop();
                            },
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
                        'Expense Details',
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
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Thumbnail:- ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.height / 4,
                  child: isloading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF3954A4),
                          ),
                        )
                      : Image.file(
                          File(imagePath.value),
                          fit: BoxFit.cover,
                        )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 125,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // maxLength: 15,
                    // keyboardType: TextInputType.number,
                    controller: title,
                    decoration: InputDecoration(
                        counterText: "",
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.2),
                        ),
                        labelText: 'Title',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFA4A4A4),
                        )),
                    validator: phoneNumber),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // maxLength: 15,
                    keyboardType: TextInputType.number,
                    controller: amount,
                    decoration: InputDecoration(
                        counterText: "",
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.2),
                        ),
                        labelText: 'Amount',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFA4A4A4),
                        )),
                    validator: phoneNumber),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: DateTimeField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  format: format,
                  controller: _dateTimeController,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.2),
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    labelText: 'Select Date and Time',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFA4A4A4),
                    ),
                  ),
                  validator: dateerror,
                  onShowPicker: (context, currentValue) async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now(),
                        ),
                      );
                      if (selectedTime != null) {
                        // Update the currentValue with the selected date and time
                        final updatedValue = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        // _dateTimeController.text = format.format(updatedValue);
                        setState(() {
                          finalDate = updatedValue;
                        });
                        DateTimeTextField();
                        return updatedValue;
                      }
                    }
                    setState(() {
                      finalDate = currentValue;
                    });
                    DateTimeTextField();
                    return currentValue;
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          // Get.back();
                          Navigator.of(context).pop();
                          Get.to(() => ExpenseReport());
                        },
                        child: Container(
                          width: 118,
                          height: 43,
                          decoration: ShapeDecoration(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await postExpenseReport();
                            setState(() {
                              isLoading = false;
                            });
                            // Get.to
                          }
                        },
                        child: Container(
                          width: 158,
                          height: 43,
                          decoration: ShapeDecoration(
                            color: Color(0xFF3954A4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
