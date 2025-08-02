// ignore_for_file: prefer_const_constructors

import 'package:bmproject/BM/Chat/chat_test.dart';
import 'package:bmproject/BM/Home/home_bm.dart';
import 'package:bmproject/BM/Swap/swap_screen.dart';
import 'package:bmproject/BM/nav_bar/controller/nav_control.dart';
import 'package:bmproject/BM/profile/profile_screen.dart';
import 'package:bmproject/BM/quiz/user/home_screen_quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomNavBarBM extends StatefulWidget {
  const CustomNavBarBM({super.key});

  @override
  State<CustomNavBarBM> createState() => _CustomNavBarBMState();
}

class _CustomNavBarBMState extends State<CustomNavBarBM> {
  static List<Widget> screens = <Widget>[
    const ChatTest(),
    const HomeScreenQuiz(),
    const HomeBm(),
    const SwapScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavControl>(
      builder: (context, modell, child) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            // selectedFontSize: 222,
            elevation: 7,

            selectedItemColor: const Color.fromRGBO(32, 51, 81, 1),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 11,
            ),
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.sms,
                  color: Color.fromARGB(255, 136, 30, 53),
                ),
                icon: Icon(Icons.my_library_books_rounded),
                label: " Question",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.my_library_books_rounded,
                  color: Color.fromARGB(255, 136, 30, 53),
                ),
                icon: Icon(Icons.my_library_books_rounded),
                label: "Exams",
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(height: 30, "assets/homeBM.svg"),
                icon: SvgPicture.asset(height: 30, "assets/homeInactive.svg"),
                label: "Home",
              ),
              BottomNavigationBarItem(
                activeIcon: const Icon(
                  Icons.event_note,
                  color: Color.fromARGB(255, 136, 30, 53),
                ),
                icon: const Icon(
                  Icons.event_note,
                  color: Color.fromARGB(255, 43, 38, 38),
                ),
                label: "Swap",
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  height: 30,
                  "assets/profileBM.svg",
                ),
                icon: SvgPicture.asset(height: 30, "assets/profile.svg"),
                label: "Profile",
              ),
            ],
            currentIndex: modell.selectedIndex,
            onTap: (int index) {
              setState(() {
                modell.selectedIndex = index;
              });
            },
          ),
          body: screens.elementAt(modell.selectedIndex),
        );
      },
    );
  }
}
