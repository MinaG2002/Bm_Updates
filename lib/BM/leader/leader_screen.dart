import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/leader/Team/leader_team.dart';
import 'package:bmproject/BM/leader/confirm/leader_confirm.dart';
import 'package:bmproject/BM/leader/Quiez/suber__test1.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderScreen extends StatelessWidget {
  const LeaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  final userProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );
                  final leader = userProvider.userleader;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaderTeam(leaderName: "${leader}"),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppTheme.primaryColor,
                  ),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1 - 100,
                  child: Center(
                    child: Text(
                      "Team",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderConfirm(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppTheme.primaryColor,
                  ),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1 - 100,
                  child: Center(
                    child: Text(
                      "Confirmed",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final userProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );
                  final leader = userProvider.userleader;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Subertest1(leaderName: "${leader}"),
                    ),
                  );

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) =>
                  //         ScoresByLeaderPage(leaderName: "${leader}"),
                  //   ),
                  // );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppTheme.primaryColor,
                  ),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1 - 100,
                  child: Center(
                    child: Text(
                      "Quiez",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
