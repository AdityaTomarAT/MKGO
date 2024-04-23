// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fr.innoyadev.mkgodev/add/add.dart';
// import 'package:fr.innoyadev.mkgodev/homeScreen/landingScreen.dart';
import 'package:fr.innoyadev.mkgodev/notes/notes.dart';
import 'package:fr.innoyadev.mkgodev/cart/cart.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int myIndex = 0;
  List<Widget> widgetList = [
    // LandingScreen(),
    Notes(),
    Cart(),
    Add(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: myIndex,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 14,
          selectedLabelStyle: TextStyle(fontFamily: 'kanit'),
          unselectedLabelStyle: TextStyle(fontFamily: 'kanit'),
          backgroundColor: Colors.white,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF3954A4),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              label: 'Planning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger_outline_rounded),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Planning',
            ),
            // BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined),
            // label: 'Ajouter',
            // )
          ]),
    );
  }
}
