import 'package:bmproject/BM/nav_bar/controller/nav_control.dart';
import 'package:bmproject/BM/admin/Home/admin_home_screen2.dart';
import 'package:bmproject/BM/admin/admin_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NavAdmin extends StatefulWidget {
  const NavAdmin({super.key});

  @override
  State<NavAdmin> createState() => _NavAdminState();
}

class _NavAdminState extends State<NavAdmin> {
  static List<Widget> screens = <Widget>[
    const AdminHomeScreen(),
    const AdminHomeScreen2(),
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
            ],
            currentIndex: modell.selectedIndex2,
            onTap: (int index) {
              setState(() {
                modell.selectedIndex2 = index;
              });
            },
          ),
          body: screens.elementAt(modell.selectedIndex2),
        );
      },
    );
  }
}
