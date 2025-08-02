// ignore_for_file: must_be_immutable

import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class SearshLeader extends StatefulWidget {
  String cisco;
  SearshLeader({super.key, required this.cisco});

  @override
  State<SearshLeader> createState() => _SearshLeaderState();
}

class _SearshLeaderState extends State<SearshLeader> {
  bool _updated = false;

  List<bool> _showErrors = [];
  bool issucees = true;

  //start no exam
  bool isLoading = true;
  List<Map<String, dynamic>> unexaminedData = [];

  @override
  void initState() {
    super.initState();
    fetchUnexaminedStudents();
  }

  Future<void> fetchUnexaminedStudents() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? leader = userProvider.userleader;

    try {
      // ✅ 1. جميع الامتحانات
      final allQuizSnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .get();

      final allQuizNames = allQuizSnapshot.docs
          .map((doc) => doc['title']?.toString())
          .whereType<String>()
          .toList();

      // ✅ 2. جميع الطلاب تحت نفس الليدر (مع تصفية cisco إن وجد)
      Query usersQuery = FirebaseFirestore.instance
          .collection('users')
          .where('Leader', isEqualTo: leader);

      if (widget.cisco.isNotEmpty) {
        usersQuery = usersQuery.where('cisco', isEqualTo: widget.cisco);
      }

      final usersSnapshot = await usersQuery.get();
      final users = usersSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // ✅ 3. نتائج الامتحانات
      Query scoresQuery = FirebaseFirestore.instance
          .collection('scores')
          .where('Leader', isEqualTo: leader);

      if (widget.cisco.isNotEmpty) {
        scoresQuery = scoresQuery.where('cisco', isEqualTo: widget.cisco);
      }

      final scoresSnapshot = await scoresQuery.get();
      final scores = scoresSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // ✅ 4. تجميع البيانات
      Map<String, List<String>> userScores = {};

      for (var score in scores) {
        final cisco = score['cisco']?.toString();
        final quiz = score['Quiz']?.toString();
        if (cisco != null && quiz != null) {
          userScores.putIfAbsent(cisco, () => []).add(quiz);
        }
      }

      // ✅ 5. تحديد من لم يمتحن
      final result = users
          .map((user) {
            final cisco = user['cisco']?.toString();
            final name = user['username'] ?? 'بدون اسم';
            final doneQuizzes = userScores[cisco] ?? [];
            final missingQuizzes = allQuizNames
                .where((q) => !doneQuizzes.contains(q))
                .toList();

            return {
              'name': name,
              'cisco': cisco,
              'missingQuizzes': missingQuizzes,
            };
          })
          .where((e) => e['missingQuizzes'].isNotEmpty)
          .toList();

      // ✅ 6. تحديث الحالة
      setState(() {
        unexaminedData = result;
        isLoading = false;
      });
    } catch (e) {
      print("🔥 Error fetching students: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final leaderName = userProvider.userleader;
    Color _getScoreColor(double score) {
      if (score >= 0.8) return Colors.green;

      if (score >= 0.5) return Colors.orange;
      return Colors.red;
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('scores')
          .where('Leader', isEqualTo: leaderName)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final allDocs = snapshot.data!.docs;

        final docs = allDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data['cisco'] ?? '').toString().toLowerCase();
          return name.contains(widget.cisco);
        }).toList();

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

        //end no exam

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "   ${(totalCorrect / totalQuestions * 100).toStringAsFixed(2)}%",
                ),
                SizedBox(height: 4),
                Text(
                  "الأسئلة: $totalQuestions | الصح: $totalCorrect | الخطأ: $totalWrong ",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        issucees = true;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        issucees ? AppTheme.primaryColor : Colors.grey,
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.all(10),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: 70,
                      child: Center(
                        child: Text(
                          "Success",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        issucees = false;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        issucees ? Colors.grey : AppTheme.primaryColor,
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.all(10),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: 70,
                      child: Center(
                        child: Text(
                          "Fail",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              issucees
                  ? Expanded(
                      child: docs.isEmpty
                          ? Center(child: Text("لا يوجد طلاب بعد."))
                          : ListView.builder(
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final data =
                                    docs[index].data() as Map<String, dynamic>;
                                final quiz = data['Quiz'] ?? '';
                                final name = data['name'] ?? 'بدون اسم';

                                final cisco = data['cisco'] ?? '';
                                final score = data['score'] ?? 0;
                                final correctAnswers =
                                    data['correctAnswers'] ?? 0;
                                final total = data['totalQuestions'] ?? 0;
                                final wrongAnswers =
                                    List<Map<String, dynamic>>.from(
                                      data['wrongAnswers'] ?? [],
                                    );

                                return Card(
                                  margin: EdgeInsets.all(8),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "$quiz",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "👤 $name",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text("🆔 Cisco: $cisco"),
                                              Text(
                                                "correctAnswers: $correctAnswers",
                                              ),
                                              Text(
                                                "wrongAnswers: ${wrongAnswers.length}",
                                              ),
                                              Text("total: $total"),
                                              // Text(
                                              //   "📊 Final Score: ${score.toStringAsFixed(2)}%",
                                              //   style: TextStyle(color: Colors.blue),
                                              // ),
                                              Center(
                                                child: IconButton(
                                                  icon: Icon(
                                                    _showErrors[index]
                                                        ? Icons.expand_less
                                                        : Icons.expand_more,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _showErrors[index] =
                                                          !_showErrors[index];
                                                    });
                                                  },
                                                ),
                                              ),
                                              if (_showErrors[index] &&
                                                  wrongAnswers.isNotEmpty) ...[
                                                SizedBox(height: 8),
                                                Text(
                                                  "❌ الأخطاء:",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                ...wrongAnswers.map((wrong) {
                                                  final question =
                                                      wrong['question'] ?? '';
                                                  final selected =
                                                      wrong['selectedAnswer'] ??
                                                      '';
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "• السؤال: $question",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          "إجابتك: $selected",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ],
                                            ],
                                          ),
                                        ),
                                        CircularPercentIndicator(
                                          radius: 60.0,
                                          lineWidth: 8.0,
                                          percent: (score / 100).clamp(
                                            0.0,
                                            1.0,
                                          ),
                                          center: Text(
                                            "${score.toStringAsFixed(1)}%",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          progressColor: _getScoreColor(
                                            score / 100,
                                          ),
                                          backgroundColor: Colors.grey.shade200,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          animation: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
                  : Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : unexaminedData.isEmpty
                          ? const Center(
                              child: Text("🎉 كل الطلاب أكملوا الامتحانات"),
                            )
                          : ListView.builder(
                              itemCount: unexaminedData.length,
                              itemBuilder: (context, index) {
                                final user = unexaminedData[index];
                                return Card(
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text("👤 ${user['name']}"),

                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("🆔 Cisco: ${user['cisco']}"),
                                        const SizedBox(height: 5),
                                        Text(
                                          "🚫 لم يمتحن: ${user['missingQuizzes'].join(', ')}",
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
