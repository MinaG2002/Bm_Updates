import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderConfirm extends StatefulWidget {
  const LeaderConfirm({super.key});

  @override
  State<LeaderConfirm> createState() => _LeaderConfirmState();
}

class _LeaderConfirmState extends State<LeaderConfirm> {
  Set<String> _expandesposts = {};
  late Future<Map<String, dynamic>> likedPostsData;
  @override
  void initState() {
    super.initState();
    likedPostsData = getLikedPostsByLeader();
  }

  int totalConfirmed = 0;
  int totalRemaining = 0;
  String leaderName = "";
  Future<Map<String, dynamic>> getLikedPostsByLeader() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? cisco = userProvider.userCisco;

    final String? leader = userProvider.userleader;

    if (leader == null || cisco == null) return {};
    leaderName = leader;

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Leader', isEqualTo: leader)
        .get();

    List<Map<String, dynamic>> teamMembers = usersSnapshot.docs.map((doc) {
      return {
        'username': doc['username'] ?? 'بدون اسم',
        'cisco': doc['cisco'].toString(),
      };
    }).toList();

    QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
        .collection('updates')
        .get();

    Map<String, dynamic> result = {};

    totalConfirmed = 0;
    totalRemaining = 0;

    for (var post in postsSnapshot.docs) {
      List likes = post['likes'] ?? [];
      List<Map<String, dynamic>> memberStatus = teamMembers.map((member) {
        bool liked = likes.contains(member['cisco']);
        return {'username': member['username'], 'liked': liked};
      }).toList();

      totalConfirmed += memberStatus.where((m) => m['liked']).length;
      totalRemaining += memberStatus.where((m) => !m['liked']).length;

      result[post.id] = {
        'title': post['title'] ?? '',
        'description': post['description'] ?? '',
        'members': memberStatus,
      };
    }

    // ✅ البحث عن الوثيقة التي تحتوي على cisco في كولكشن leaders
    QuerySnapshot leaderDocSnapshot = await FirebaseFirestore.instance
        .collection('leaders')
        .where('cisco', isEqualTo: cisco)
        .limit(1)
        .get();

    if (leaderDocSnapshot.docs.isNotEmpty) {
      String docId = leaderDocSnapshot.docs.first.id;

      await FirebaseFirestore.instance.collection('leaders').doc(docId).set({
        'confirmed': totalConfirmed,
        'remaining': totalRemaining,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        title: Center(
          child: Text(
            " ${leaderName}             ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
                  "These are the agents who have confirmed the posts.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Confirm: $totalConfirmed",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.cancel, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Unconfirmed: $totalRemaining",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: likedPostsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("error:${snapshot.error}"));
                }
                final postData = snapshot.data ?? {};
                if (postData.isEmpty) {
                  return Center(child: Text("empty"));
                }
                return ListView(
                  children: postData.entries.map((entry) {
                    final postId = entry.key;
                    final post = entry.value;
                    bool isExpanded = _expandesposts.contains(postId);

                    return Card(
                      color: AppTheme.backgroundColor,
                      margin: EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(post['description'], maxLines: 2),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (isExpanded) {
                                    _expandesposts.remove(postId);
                                  } else {
                                    _expandesposts.add(postId);
                                  }
                                });
                              },
                              child: Center(
                                child: Icon(
                                  color: AppTheme.primaryColor,
                                  isExpanded
                                      ? Icons.arrow_upward_outlined
                                      : Icons.arrow_downward_sharp,
                                ),
                              ),
                            ),
                            if (isExpanded) ...[
                              Divider(),
                              Text(
                                " Confirm:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...post['members'].map<Widget>((member) {
                                return ListTile(
                                  leading: Icon(
                                    member['liked']
                                        ? Icons.thumb_up
                                        : Icons.thumb_down,

                                    color: member['liked']
                                        ? Colors.green
                                        : AppTheme.primaryColor,
                                  ),
                                  title: Text(member['username']),
                                );
                              }).toList(),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
