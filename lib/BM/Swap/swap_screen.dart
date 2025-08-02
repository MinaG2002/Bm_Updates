import 'dart:ui';

import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/Swap/view/add_request_swap.dart';
import 'package:bmproject/BM/Swap/view/all_requests.dart';
import 'package:bmproject/BM/Swap/view/edit_request_swqp.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    final name = userProvider.userName;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.primaryColor,
          body: Center(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    // Text("${name}"),
                    // Text("${cisco}"),
                    const Text(
                      "Smart Swap",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Welcome, Agent!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          "Let's Swap requests to exchang Work Shifts",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 60),
                    Container(
                      height: MediaQuery.of(context).size.height * 1 - 259,
                      width: MediaQuery.of(context).size.width * 1,
                      // color: Colors.black,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AllRequestsPage(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                AppTheme.primaryColor,
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.all(12),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 1 - 100,
                              child: Center(
                                child: Text(
                                  S.of(context).AllRequests,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Spacer(flex: 1),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MyRequestsPage(),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    AppTheme.primaryColor,
                                  ),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.all(12),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3 +
                                      10,
                                  child: Center(
                                    child: Text(
                                      S.of(context).EditSwap,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //
                              const Spacer(flex: 1),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddRequestPage(),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    AppTheme.primaryColor,
                                  ),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.all(12),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3 +
                                      10,
                                  child: Center(
                                    child: Text(
                                      S.of(context).AddSwap,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(flex: 1),
                            ],
                          ),
                          // TextButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const ScoreRankingPage()),
                          //       );
                          //     },
                          //     child: Text("data")),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.2),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock_clock, size: 60, color: Colors.black54),
                    SizedBox(height: 16),
                    Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
