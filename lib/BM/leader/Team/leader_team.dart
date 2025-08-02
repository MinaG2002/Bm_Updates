import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LeaderTeam extends StatefulWidget {
  final String leaderName;

  const LeaderTeam({super.key, required this.leaderName});

  @override
  State<LeaderTeam> createState() => _LeaderTeamState();
}

class _LeaderTeamState extends State<LeaderTeam> {
  int count = 0;
  bool iscount = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        title: Center(
          child: Text(
            " ${widget.leaderName}             ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      // AppBar(title: Text('Team: $leaderName')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            // height: MediaQuery.of(context).size.height * 1 / 5,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: AppTheme.primaryColor, // أو AppTheme.cardColor إذا عندك
              boxShadow: [], // إزالة الظلال نهائيًا
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome, Leader!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  "Here's a list of agents working under your leadership.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Number of users: ${count}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('Leader', isEqualTo: widget.leaderName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد مستخدمين لهذا الليدر.'),
                  );
                }

                final users = snapshot.data!.docs;
                int counttt = users.length;
                count = counttt;

                return Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'Number of users: ${users.length}',
                    //     style: const TextStyle(fontSize: 18),
                    //   ),
                    // ),
                    Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final name = user['username'];
                              final cisco = user['cisco'];

                              return ListTile(
                                title: Text(name),
                                subtitle: Text('Cisco: $cisco'),
                                leading: Icon(
                                  Icons.person,
                                  color: AppTheme.primaryColor,
                                ),
                              );
                            },
                          ),
                        )
                        .animate(delay: Duration(milliseconds: 1000))
                        .slideX(
                          begin: 0.5,
                          end: 0,
                          duration: const Duration(milliseconds: 350),
                        )
                        .fadeIn(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
