import 'dart:async';

import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/leader/Quiez/exam_details.dart';
import 'package:bmproject/BM/leader/Quiez/filter/searsh_leader.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class Subertest1 extends StatefulWidget {
  final String leaderName;

  const Subertest1({super.key, required this.leaderName});

  @override
  State<Subertest1> createState() => _Subertest1State();
}

class _Subertest1State extends State<Subertest1> {
  String searchName = "";
  List<QueryDocumentSnapshot> filteredDocs = [];
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  TextEditingController _controller = TextEditingController();
  String cisco = "";

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        cisco = value.trim();
      });

      if (cisco.isNotEmpty) {
        // انتقل للصفحة الأخرى بعد انتهاء الكتابة
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SearshLeader(cisco: cisco)),
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  //%leader
  Future<void> updateLeaderData({
    required int totalCorrect,
    required int totalQuestions,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String? cisco = userProvider.userCisco;
      double percentage = (totalQuestions == 0)
          ? 0
          : (totalCorrect / totalQuestions) * 100;
      final query = await FirebaseFirestore.instance
          .collection('leaders')
          .where('cisco', isEqualTo: cisco)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          'totalCorrect': totalCorrect,
          'totalQuestions': totalQuestions,
          'percentage': percentage.toStringAsFixed(2) + "%",
        });
        print("✅ تم التحديث للقائد الذي رقمه: $cisco");
      } else {
        print("❌ لم يتم العثور على القائد برقم cisco: $cisco");
      }
    } catch (e) {
      print("⚠️ خطأ في التحديث: $e");
    }
  }

  bool _updated = false;

  List<bool> _showErrors = [];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final leaderName = userProvider.userleader;
    final cisco = userProvider.userCisco;
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
      //  appBar: AppBar(title: Text("امتحانات $leaderName")),
      body: SingleChildScrollView(
        child: Column(
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('scores')
                        .where('Leader', isEqualTo: widget.leaderName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Column(
                            children: [
                              //  CircularProgressIndicator(),
                              Text("....جاري التحميل"),
                            ],
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      // ضبط حالة عرض الأخطاء لكل عنصر
                      if (_showErrors.length != docs.length) {
                        _showErrors = List.generate(docs.length, (_) => false);
                      }

                      int totalQuestions = 0;
                      int totalCorrect = 0;
                      String? firstCisco;

                      for (var doc in docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        totalQuestions += (data['totalQuestions'] ?? 0) as int;
                        totalCorrect += (data['correctAnswers'] ?? 0) as int;
                        firstCisco ??= data['cisco'];
                      }

                      int totalWrong = totalQuestions - totalCorrect;

                      if (!_updated && firstCisco != null) {
                        _updated = true;
                        updateLeaderData(
                          totalCorrect: totalCorrect,
                          totalQuestions: totalQuestions,
                        );
                      }
                      return Text(
                        "الأسئلة: $totalQuestions | الصح: $totalCorrect | الخطأ: $totalWrong | النسيه:  %${(totalCorrect / totalQuestions * 100).toStringAsFixed(2)} ",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Let's find out what the agent's score is.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "ابحث باسم الطالب...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: _onChanged,
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('scores')
                  .where('Leader', isEqualTo: widget.leaderName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final allDocs = snapshot.data!.docs;

                final docs = allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['cisco'] ?? '').toString().toLowerCase();
                  return name.contains(searchName);
                }).toList();
                final quizNames = <String>{};

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (data.containsKey('Quiz')) {
                    quizNames.add(data['Quiz']);
                  }
                }

                if (quizNames.isEmpty) {
                  return Center(child: Text("لا يوجد امتحانات بعد."));
                }

                return GridView.count(
                  crossAxisCount: 2, // عدد العناصر في كل صف
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  //  physics: const NeverScrollableScrollPhysics(),
                  children: quizNames.map((quiz) {
                    return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExamDetailsPage2(
                                  leaderName: widget.leaderName,
                                  quizName: quiz,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors
                                  .white, // أو AppTheme.cardColor إذا عندك
                              boxShadow: [], // إزالة الظلال نهائيًا
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ), // إطار بسيط إن أردت
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.quiz,
                                    size: 40,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  quiz,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate(delay: Duration(milliseconds: 100))
                        .fadeIn(duration: const Duration(milliseconds: 300))
                        .slideY(
                          begin: 0.5,
                          end: 0,
                          duration: const Duration(milliseconds: 300),
                        );
                  }).toList(),
                );
              },
            ),

            //ssssssssssssssssssssssssssssss
          ],
        ),
      ),
    );
  }
}
