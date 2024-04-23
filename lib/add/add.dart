// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings, non_constant_identifier_names, deprecated_member_use, avoid_print

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fr.innoyadev.mkgodev/Utility/bottomSheet.dart';
import 'package:fr.innoyadev.mkgodev/profile/profile.dart';
import 'package:permission_handler/permission_handler.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController comment = TextEditingController();
  TextEditingController tarif = TextEditingController();
  TextEditingController client = TextEditingController();
  TextEditingController chooseEnterprise = TextEditingController();
  TextEditingController Kilometrage1 = TextEditingController();

        bool isItemSelected = false;


  int selectedValue = -1;
  String? race;
  int currentIndex = 0;

  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime.now();
  TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        String formattedDateTime =
            DateFormat('dd-MM-yyyy  HH:mm:ss').format(picked);
        dateController.text = formattedDateTime;
      });
    }
  }

  String selectedValue2 = 'Belongs To';
  List<String> values1 = [
    "'INNOYA SERVICES // L'UNION 2",
    "INNOYA SERVICES /@/ AUZIELLE",
    "TAXI ATM"
  ];

  void showValueSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        String selectedValueForDialog = selectedValue2;
        String originalSelectedValue = 'Belongs To';
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.85,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Appartient A',
                            style: TextStyle(
                              color: Color(0xFF3954A4),
                              fontSize: 16,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      height: 170,
                      child: ListView(
                        children: values1.map((value) {
                          return ListTile(
                            title: Text(value),
                            leading: Icon(
                              selectedValueForDialog == value
                                  ? Icons.check
                                  : null,
                              color: selectedValueForDialog == value
                                  ? Colors.blue
                                  : null,
                            ),
                            onTap: () {
                              setState(() {
                                selectedValueForDialog = value;
                              });
                              Navigator.of(context).pop(selectedValueForDialog);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: Text('Reset'),
                            onPressed: () {
                              setState(() {
                                selectedValueForDialog = originalSelectedValue;
                                isItemSelected =
                                    false; // Reset to the default value
                              });
                              Navigator.of(context).pop(originalSelectedValue);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          selectedValue2 = result;
        });
      }
    });
  }


  String selectedValue3 = 'En Compte';
  List<String> values2 = ["CB", "EB", "En compte"];
  String selectedValueForDialog2 = 'Belongs To';


  void showValueSelectionBottomSheet2(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        String selectedValueForDialog = selectedValue3;
        String originalSelectedValue = 'Choisir un mode de paiement*';
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.85,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mode Paiment',
                            style: TextStyle(
                              color: Color(0xFF3954A4),
                              fontSize: 16,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: values2.map((value) {
                        return ListTile(
                          title: Text(value),
                          leading: Icon(
                            selectedValueForDialog == value
                                ? Icons.check
                                : null,
                            color: selectedValueForDialog == value
                                ? Colors.blue
                                : null,
                          ),
                          onTap: () {
                            setState(() {
                              selectedValueForDialog = value;
                              Navigator.of(context).pop(selectedValueForDialog);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: Text('Reset'),
                            onPressed: () {
                              setState(() {
                                selectedValueForDialog = originalSelectedValue;
                                isItemSelected =
                                    false; // Reset to the default value
                              });
                              Navigator.of(context).pop(originalSelectedValue);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          selectedValue3 = result;
        });
      }
    });
  }

  String selectedValue4 = 'Choisir Enterprise';
  List<String> values3 = ["Consultation", 'Connect To Transfer', 'ATM TAXI'];

  void showValueSelectionBottomSheet3(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFE6F7FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(38),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        String selectedValueForDialog = selectedValue4;
        String originalSelectedValue = 'Choisir une entreprise*';
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: values3.map((value) {
                        return ListTile(
                          title: Text(value),
                          leading: Icon(
                            selectedValueForDialog == value
                                ? Icons.check
                                : null,
                            color: selectedValueForDialog == value
                                ? Colors.blue
                                : null,
                          ),
                          onTap: () {
                            setState(() {
                              selectedValueForDialog = value;
                            });
                            Navigator.of(context).pop(selectedValueForDialog);
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: Text('Reset'),
                            onPressed: () {
                              setState(() {
                                selectedValueForDialog = originalSelectedValue;
                                isItemSelected =
                                    false; // Reset to the default value
                              });
                              Navigator.of(context).pop(originalSelectedValue);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          selectedValue4 = result;
        });
      }
    });
  }

  List<Widget> addedContainers = [];
  int containerCount = 0;

  String CameraFile = "";
  String GalleryFile = "";
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
          height: MediaQuery.of(context).size.height / 2.5,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () async {
                  await checkPermission(Permission.storage, context);
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file2 =
                      await imagePicker.pickImage(source: ImageSource.camera);
                  if (file2 != null) {
                    String path = file2.path;
                    RegExp datePattern = RegExp(r'(\d{4}-\d{2}-\d{2})');
                    Match? dateMatch = datePattern.firstMatch(path);
                    if (dateMatch != null) {
                      String datePart = dateMatch.group(1)!;

                      setState(() {
                        GalleryFile = datePart;
                        print('Gallery file date: $GalleryFile');
                      });
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.25,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'Take a Photo',
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
                  await checkPermission(Permission.location, context);
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file2 =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    GalleryFile = file2!.path;
                    print('Camera file path: $CameraFile');
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.25,
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
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.25,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: Text(
                      'Cancel',
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
            ],
          ),
        );
      },
    );
  }

  Future<void> checkPermission(
      Permission permission, BuildContext context) async {
    final status = await permission.request();
    if (status.isGranted) {
      print("Permission is Granted");
    } else {
      print("Permission is not Granted");
    }
  }

  TextEditingController _dateTimeController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd  HH:mm");

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    comment.dispose();
    tarif.dispose();
    _dateTimeController.dispose();
    client.dispose();
    chooseEnterprise.dispose();
    Kilometrage1.dispose();
  }

  List<int> personCounts = [1];
  List<int> personCounts2 = [1];
  List<int> personCounts3 = [1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 130,
            decoration: BoxDecoration(color: Color(0xFF3954A4)),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, top: 15, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ajouter',
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFF2F6F9),
                                border:
                                Border(
                                  top: BorderSide(
                                      width: 1, color: Colors.grey.shade300),
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey.shade300),
                                ),),
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                  child: Text(
                                    'Space course',
                                    style: TextStyle(
                                      color: Color(0xFF3954A4),
                                      fontSize: 16,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F6F9),
                            ),
                            height: 30,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                  child: Text(
                                    'Choose your race',
                                    style: TextStyle(
                                      color: Color(0xFF3954A4),
                                      fontSize: 16,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: RadioListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              title: Text(
                                'Taxi',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 12.5,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                              value: "Taxi",
                              tileColor: Colors.white,
                              groupValue: race,
                              onChanged: (value) {
                                setState(() {
                                  race = value.toString();
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: RadioListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              title: Text(
                                'Medical',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 12.5,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                              value: "Medical",
                              tileColor: Colors.white,
                              groupValue: race,
                              onChanged: (value) {
                                setState(() {
                                  race = value.toString();
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: RadioListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              title: Text(
                                'Elves',
                                style: TextStyle(
                                  color: Color(0xFF524D4D),
                                  fontSize: 12.5,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                              value: "Elves",
                              tileColor: Colors.white,
                              groupValue: race,
                              onChanged: (value) {
                                setState(() {
                                  race = value.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.108,
                        height: 30,
                        decoration: BoxDecoration(color: Color(0xFFF2F6F9)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Choice License',
                            style: TextStyle(
                              color: Color(0xFF3954A4),
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w300,
                              height: 0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    GestureDetector(
                      onTap: () {
                        showValueSelectionBottomSheet(context);
                      },
                      child: Container(
                        width: 391,
                        height: 46,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            selectedValue2,
                            style: TextStyle(
                              color: Color(0xFF524D4D),
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w300,
                              height: 0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.108,
                        height: 54,
                        decoration: BoxDecoration(color: Color(0xFFF2F6F9)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: DateTimeField(
                            format: format,
                            controller: _dateTimeController,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Colors.black,
                                size: 30,
                              ),
                              labelText: 'Select Date and Time',
                              border: OutlineInputBorder(),
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2101),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  return showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now()),
                                  ).then((selectedTime) {
                                    if (selectedTime != null) {
                                      return DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        selectedTime.hour,
                                        selectedTime.minute,
                                      );
                                    }
                                    return currentValue;
                                  });
                                }
                                return currentValue;
                              });
                            },
                          ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.108,
                        height: 63,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: comment,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Comment',
                                hintStyle: TextStyle(
                                  color: Color(0xFF3954A4),
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ))),
                    if (race == "Taxi" )
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 37,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Color(0xFFF5F5F5)),
                                top: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                                right: BorderSide(color: Color(0xFFF5F5F5)),
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Client Area',
                                    style: TextStyle(
                                      color: Color(0xFF3954A4),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  ),
                                  if (personCounts.length < 5)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          personCounts.add(personCounts.length + 1);
                                        });
                                      },
                                      child: Image.asset('assets/images/addPerson.png'),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            itemCount: personCounts.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(color: Color(0xFFECECEC)),
                                    top: BorderSide(color: Color(0xFFECECEC)),
                                    right: BorderSide(color: Color(0xFFECECEC)),
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xFFECECEC)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        editSheet2(context);
                                      },
                                      child: Image.asset(
                                          'assets/images/person1.png'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFF3954A4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${personCounts[index]}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 255,
                                          height: 37,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F6F9),
                                          ),
                                          child: TextField(
                                            controller: client,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                  Icons.arrow_drop_down_sharp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (personCounts.length > 0) {
                                          setState(() {
                                            personCounts.removeAt(index);
                                            for (int i = 0; i < personCounts.length; i++) {
                                              personCounts[i] = i + 1;
                                            }
                                          });
                                        }
                                      },
                                      child: Image.asset('assets/images/delete2.png'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    if (race == "Medical")
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 37,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Color(0xFFF5F5F5)),
                                top: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                                right: BorderSide(color: Color(0xFFF5F5F5)),
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Client Area',
                                    style: TextStyle(
                                      color: Color(0xFF3954A4),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  ),
                                  if (personCounts2.length < 5)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          personCounts2.add(personCounts2.length + 1);
                                        });
                                      },
                                      child: Image.asset('assets/images/addPerson.png'),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            itemCount: personCounts2.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(color: Color(0xFFECECEC)),
                                    top: BorderSide(color: Color(0xFFECECEC)),
                                    right: BorderSide(color: Color(0xFFECECEC)),
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xFFECECEC)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        editSheet2(context);
                                      },
                                      child: Image.asset(
                                          'assets/images/person1.png'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFF3954A4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${personCounts2[index]}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 255,
                                          height: 37,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F6F9),
                                          ),
                                          child: TextField(
                                            controller: client,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                  Icons.arrow_drop_down_sharp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (personCounts2.length > 0) {
                                          setState(() {
                                            personCounts2.removeAt(index);
                                            for (int i = 0; i < personCounts2.length; i++) {
                                              personCounts2[i] = i + 1;
                                            }
                                          });
                                        }
                                      },
                                      child: Image.asset('assets/images/delete2.png'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    if (race == "Elves")
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 37,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Color(0xFFF5F5F5)),
                                top: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                                right: BorderSide(color: Color(0xFFF5F5F5)),
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Client Area',
                                    style: TextStyle(
                                      color: Color(0xFF3954A4),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  ),
                                  if (personCounts3.length < 5)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          personCounts3.add(personCounts3.length + 1);
                                        });
                                      },
                                      child: Image.asset('assets/images/addPerson.png'),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            itemCount: personCounts3.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(color: Color(0xFFECECEC)),
                                    top: BorderSide(color: Color(0xFFECECEC)),
                                    right: BorderSide(color: Color(0xFFECECEC)),
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xFFECECEC)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        editSheet2(context);
                                      },
                                      child: Image.asset(
                                          'assets/images/person1.png'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFF3954A4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${personCounts3[index]}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 255,
                                          height: 37,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F6F9),
                                          ),
                                          child: TextField(
                                            controller: client,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                  Icons.arrow_drop_down_sharp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (personCounts3.length > 0) {
                                          setState(() {
                                            personCounts3.removeAt(index);
                                            for (int i = 0; i < personCounts3.length; i++) {
                                              personCounts3[i] = i + 1;
                                            }
                                          });
                                        }
                                      },
                                      child: Image.asset('assets/images/delete2.png'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.108,
                      height: 54,
                      decoration: BoxDecoration(color: Color(0xFFF2F6F9)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Payment Area',
                          style: TextStyle(
                            color: Color(0xFF3954A4),
                            fontSize: 14,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                            height: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (race == "Taxi")
                      Column(
                        children: [
                          Container(
                            height: 50,
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Choisir Un Tarif*',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 245,
                                    child: TextField(
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffixStyle: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                          height: 0,
                                        ),
                                        suffixText: '   €',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showValueSelectionBottomSheet2(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.108,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Color(0xFFECECEC)),
                                  bottom: BorderSide(color: Color(0xFFECECEC)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      child: Text(
                                        'Mode de Paiement: ',
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            selectedValue3,
                                            style: TextStyle(
                                              color: Color(0xFF524D4D),
                                              fontSize: 14,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w300,
                                              height: 0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showValueSelectionBottomSheet3(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.108,
                              decoration: BoxDecoration(
                                border: Border(
                                  // top: BorderSide(
                                  //     color: Color(0xFFECECEC)),
                                  bottom: BorderSide(color: Color(0xFFECECEC)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      child: Text(
                                        'Entreprise: ',
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            selectedValue4,
                                            style: TextStyle(
                                              color: Color(0xFF524D4D),
                                              fontSize: 14,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w300,
                                              height: 0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (race == "Medical")
                      Column(
                        children: [
                          Container(
                            height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Choisir Un Tarif*',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 245,
                                    child: TextField(
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffixStyle: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                          height: 0,
                                        ),
                                        suffixText: '   €',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.108,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFFECECEC)),
                                bottom: BorderSide(color: Color(0xFFECECEC)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: Text(
                                      'Mode de Paiement: ',
                                      style: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Text(
                                          'En Compte',
                                          style: TextStyle(
                                            color: Color(0xFF524D4D),
                                            fontSize: 14,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w300,
                                            height: 0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showValueSelectionBottomSheet3(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.108,
                              decoration: BoxDecoration(
                                border: Border(
                                  // top: BorderSide(
                                  //     color: Color(0xFFECECEC)),
                                  bottom: BorderSide(color: Color(0xFFECECEC)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      child: Text(
                                        'Entreprise: ',
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            selectedValue4,
                                            style: TextStyle(
                                              color: Color(0xFF524D4D),
                                              fontSize: 14,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w300,
                                              height: 0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 37,
                            decoration: BoxDecoration(color: Color(0xFFF2F6F9)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 15),
                              child: Text(
                                'Medical area',
                                style: TextStyle(
                                  color: Color(0xFF3954A4),
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Color(0xFFECECEC)),
                                top: BorderSide(color: Color(0xFFECECEC)),
                                right: BorderSide(color: Color(0xFFECECEC)),
                                // bottom: BorderSide(
                                //     width: 1, color: Color(0xFFECECEC)),
                              ),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 23, left: 18, bottom: 20),
                                child: TextField(
                                  controller: Kilometrage1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Kilometrage',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFA3A3A3),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              _openBottomSheet(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 57,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  left: BorderSide(color: Color(0xFFECECEC)),
                                  top: BorderSide(color: Color(0xFFECECEC)),
                                  right: BorderSide(color: Color(0xFFECECEC)),
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xFFECECEC)),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child:
                                          Image.asset('assets/images/file.png'),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'File 1 :',
                                      style: TextStyle(
                                        color: Color(0xFFA3A3A3),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w300,
                                        height: 0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Flexible(
                                        child: Text(
                                      CameraFile,
                                      maxLines: 2,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 57,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Color(0xFFECECEC)),
                                // top: BorderSide(color: Color(0xFFECECEC)),
                                right: BorderSide(color: Color(0xFFECECEC)),
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFECECEC)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _openBottomSheet(context);
                                    },
                                    child:
                                        Image.asset('assets/images/file.png'),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'File 2 :',
                                    style: TextStyle(
                                      color: Color(0xFFA3A3A3),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(GalleryFile)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    if (race == "Elves")
                      Column(children: [
                        Container(
                          height: 50,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Choisir Un Tarif*',
                                  style: TextStyle(
                                    color: Color(0xFF524D4D),
                                    fontSize: 14,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 245,
                                  child: TextField(
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixStyle: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w300,
                                        height: 0,
                                      ),
                                      suffixText: '   €',
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.108,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFECECEC)),
                              bottom: BorderSide(color: Color(0xFFECECEC)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Text(
                                    'Mode de Paiement: ',
                                    style: TextStyle(
                                      color: Color(0xFF524D4D),
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Text(
                                        'En Compte',
                                        style: TextStyle(
                                          color: Color(0xFF524D4D),
                                          fontSize: 14,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                          height: 0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showValueSelectionBottomSheet3(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.108,
                            decoration: BoxDecoration(
                              border: Border(
                                // top: BorderSide(
                                //     color: Color(0xFFECECEC)),
                                bottom: BorderSide(color: Color(0xFFECECEC)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: Text(
                                      'Entreprise: ',
                                      style: TextStyle(
                                        color: Color(0xFF524D4D),
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Text(
                                          selectedValue4,
                                          style: TextStyle(
                                            color: Color(0xFF524D4D),
                                            fontSize: 14,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w300,
                                            height: 0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 37,
                          decoration: BoxDecoration(color: Color(0xFFF2F6F9)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: Text(
                              'Medical area',
                              style: TextStyle(
                                color: Color(0xFF3954A4),
                                fontSize: 14,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 57,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              left: BorderSide(color: Color(0xFFECECEC)),
                              top: BorderSide(color: Color(0xFFECECEC)),
                              right: BorderSide(color: Color(0xFFECECEC)),
                              bottom: BorderSide(
                                  width: 1, color: Color(0xFFECECEC)),
                            ),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextField(
                                controller: Kilometrage1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Kilometrage',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFA3A3A3),
                                    fontSize: 14,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w300,
                                    height: 0,
                                  ),
                                ),
                              )),
                        ),
                      ]),
                    if (race == "")
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFECECEC)),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Payment Method',
                              style: TextStyle(
                                color: Color(0xFF524D4D),
                                fontSize: 14,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                                height: 0,
                              ),
                            ),
                          )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: 301,
                          height: 39,
                          decoration: ShapeDecoration(
                            color: Color(0xFF3954A4),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFF3954A4)),
                              borderRadius: BorderRadius.circular(25),
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
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                                height: 0.11,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (race == "Taxi")
                      SizedBox(
                        height: 35,
                      ),
                    if (race == "Medical")
                      SizedBox(
                        height: 35,
                      ),
                    if (race == "Elves")
                      SizedBox(
                        height: 35,
                      ),
                    SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
