import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/Login/view/Login.dart';
import 'package:bmproject/BM/leader/leader_screen.dart';
import 'package:bmproject/BM/profile/results/results.dart';
import 'package:bmproject/BM/profile/top%20rank/score_ranking.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLeaderFound = false;
  bool issuberFound = false;
  bool isLoading = true;

  void checkLeader() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('leaders')
          .where('cisco', isEqualTo: cisco)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          isLeaderFound = true;
        });
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void checksuber() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('subers')
          .where('cisco', isEqualTo: cisco)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          issuberFound = true;
        });
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLeader();
    checksuber();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    final name = userProvider.userName;
    final leader = userProvider.userleader;
    final superr = userProvider.usersuper;
    final manger = userProvider.usermanager;
    final location = userProvider.userlocation;
    final phone = userProvider.userphone;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            S.of(context).PERSONALDETAILS,
            style: const TextStyle(
              color: Color(0xffA71313),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: SafeArea(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://banquemisr.com/Assets/Images/bmp-logo.png?v=14",
                    ),
                    backgroundColor: AppTheme.primaryColor,
                    radius: 100,
                  ),
                  Text(
                    "${S.of(context).Welcome}"
                    " $name",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff192C5E),
                    ),
                  ),
                  Text(
                    "Your Cisco:$cisco",
                    style: const TextStyle(color: AppTheme.textSecondaryColor),
                  ),

                  // Text("User Name: ${name}"),
                  // Text("User Name: ${phone}"),
                  // Text("User Name: ${location}"),
                  // Text("User Name: ${manger}"),
                  // Text("User Name: ${superr}"),
                  // Text("User Name: ${leader}"),
                  SizedBox(height: 40),
                  ListTile(
                    leading: const Icon(
                      Icons.military_tech_sharp,
                      size: 35,
                      color: Colors.amber,
                    ),
                    title: const Text("Top Rank"),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScoreRankingPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text("Results"),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExamDetailsPage(userCisco: "${cisco}"),
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: const Text("Notifications"),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    trailing: Switch(
                      value: true,
                      onChanged: (switc) {},
                      activeColor: AppTheme.primaryColor,
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, langProvider, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          // color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.language),
                            const Text(
                              "      Language",
                              style: TextStyle(fontSize: 17),
                            ),
                            const Spacer(flex: 1),
                            Text(
                              'English',
                              style: TextStyle(
                                color: langProvider.isArabic
                                    ? Colors.grey
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Switch(
                              value: langProvider.isArabic,
                              activeColor: Colors.blue,
                              inactiveThumbColor: AppTheme.primaryColor,
                              onChanged: (value) {
                                langProvider.toggleLanguage();
                              },
                            ),
                            Text(
                              'عربي',
                              style: TextStyle(
                                fontSize: 18,
                                color: langProvider.isArabic
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // ListTile(
                  //     leading: Icon(Icons.language),
                  //     title: Text("Language"),
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  //     trailing: Text("data")),
                  Row(
                    children: [
                      SvgPicture.asset("assets/logout.svg"),
                      const SizedBox(width: 11),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).logout();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).LogOut,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : isLeaderFound
                      ? ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeaderScreen(),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.person,
                            color: AppTheme.primaryColor,
                          ),
                          title: const Text("Leader"),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                          trailing: Icon(Icons.arrow_forward),
                        )
                      : SizedBox(),

                  // لا يظهر شيء إذا لم يكن موجود
                  isLoading
                      ? CircularProgressIndicator()
                      : issuberFound
                      ? ListTile(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         Subertest1(leaderName: "${leader}"),
                            //   ),
                            // );
                          },
                          leading: const Icon(
                            Icons.people_sharp,
                            color: AppTheme.primaryColor,
                          ),
                          title: const Text("Suber"),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                          trailing: Icon(Icons.arrow_forward),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
