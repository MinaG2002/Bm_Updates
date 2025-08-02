import 'dart:math';

import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/leader/Quiez/noexxam.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ExamDetailsPage2 extends StatefulWidget {
  final String leaderName;
  final String quizName;

  const ExamDetailsPage2({
    super.key,
    required this.leaderName,
    required this.quizName,
  });

  @override
  State<ExamDetailsPage2> createState() => _ExamDetailsPage2State();
}

class _ExamDetailsPage2State extends State<ExamDetailsPage2> {
  int issucees = 3;
  int countcont = 0;
  // bool isloadingcountcount = true;

  Color _getScoreColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.5) return Colors.orange;
    return Colors.red;
  }

  //start fail
  bool isLoading = true;
  List<Map<String, dynamic>> unexaminedData = [];
  // List<QueryDocumentSnapshot<Object?>> dataaa = [];

  @override
  void initState() {
    super.initState();
    fetchUnexaminedStudents();
    _scoresFuture = fetchScores();
    _wrongQuestionsMapFuture = fetchWrongAnswersSummary();
  }

  Future<void> fetchUnexaminedStudents() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final String? leader = userProvider.userleader;
    try {
      // ✅ 1. جلب جميع الامتحانات المرتبطة بالليدر
      final allQuizNames = [widget.quizName];

      // ✅ 2. جلب كل الطلاب المرتبطين بالليدر
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('Leader', isEqualTo: leader)
          .get();

      final users = usersSnapshot.docs.map((doc) => doc.data()).toList();

      // ✅ 3. جلب نتائج الطلاب
      final scoresSnapshot = await FirebaseFirestore.instance
          .collection('scores')
          .where('Leader', isEqualTo: leader)
          .where('Quiz', isEqualTo: widget.quizName)
          .get();

      // إعداد خريطة: {cisco: [quiz1, quiz2]}
      final Map<String, List<String>> userScores = {};
      for (var doc in scoresSnapshot.docs) {
        final data = doc.data();
        final cisco = data['cisco']?.toString();
        final quiz = data['Quiz']?.toString();
        if (cisco != null && quiz != null) {
          userScores.putIfAbsent(cisco, () => []).add(quiz);
        }
      }

      // ✅ 4. لكل طالب: نحسب الامتحانات التي لم يمتحنها
      final result = users
          .map((user) {
            final cisco = user['cisco']?.toString();
            final name = user['username'] ?? 'بدون اسم';
            final doneQuizzes = userScores[cisco] ?? [];
            final missingQuizzes = allQuizNames
                .where((quizName) => !doneQuizzes.contains(quizName))
                .toList();

            return {
              'name': name,
              'cisco': cisco,
              'missingQuizzes': missingQuizzes,
            };
          })
          .where((e) => e['missingQuizzes'].isNotEmpty)
          .toList();

      setState(() {
        unexaminedData = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  //end fail

  //start Success
  late Future<List<DocumentSnapshot>> _scoresFuture;
  List<bool> _showErrorss = [];

  Future<List<DocumentSnapshot>> fetchScores() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('scores')
        .where('Leader', isEqualTo: widget.leaderName)
        .where('Quiz', isEqualTo: widget.quizName)
        .get();
    setState(() {
      countcont = querySnapshot.docs.length;
      // isloadingcountcount = false;
    });
    return querySnapshot.docs;
  }

  //end Success
  //start details
  late Future<Map<String, List<String>>> _wrongQuestionsMapFuture;

  Future<Map<String, List<String>>> fetchWrongAnswersSummary() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('scores')
        .where('Leader', isEqualTo: widget.leaderName)
        .where('Quiz', isEqualTo: widget.quizName)
        .get();

    Map<String, List<String>> questionToNames = {};

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final name = data['name'] ?? '';
      final wrongAnswers = List<Map<String, dynamic>>.from(
        data['wrongAnswers'] ?? [],
      );

      for (var entry in wrongAnswers) {
        final question = entry['question'] ?? '';
        if (question.trim().isEmpty) continue;

        if (!questionToNames.containsKey(question)) {
          questionToNames[question] = [];
        }
        questionToNames[question]!.add(name);
      }
    }

    // ✅ ترتيب حسب عدد الأشخاص الذين أخطأوا بالسؤال (تنازلياً)
    final sortedEntries = questionToNames.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return Map.fromEntries(sortedEntries);
  }

  //end datails
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Center(
          child: Text(
            " ${widget.quizName}           ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    issucees = 3;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    issucees == 3 ? AppTheme.primaryColor : Colors.grey,
                  ),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
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
                      "Details",
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
                    issucees = 1;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    issucees == 1 ? AppTheme.primaryColor : Colors.grey,
                  ),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
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
                      "Success  ${(countcont)}",
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
                    issucees = 2;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    issucees == 2 ? AppTheme.primaryColor : Colors.grey,
                  ),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
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
                      "Fail  ${(unexaminedData.length)}",
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

          if (issucees == 1)
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: _scoresFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("حدث خطأ أثناء تحميل البيانات"));
                  }

                  final docs = snapshot.data ?? [];

                  if (_showErrorss.length != docs.length) {
                    _showErrorss = List.generate(docs.length, (_) => false);
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final name = data['name'] ?? '';
                      final cisco = data['cisco'] ?? '';
                      final correct = data['correctAnswers'] ?? 0;
                      final total = data['totalQuestions'] ?? 0;
                      final wrongAnswers = List<Map<String, dynamic>>.from(
                        data['wrongAnswers'] ?? [],
                      );
                      final wrong = wrongAnswers.length;
                      double percent = total == 0 ? 0 : correct / total;
                      double percent100 = percent * 100;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // البيانات
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.quizName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: Colors.blue),
                                        SizedBox(width: 6),
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.badge, color: Colors.purple),
                                        SizedBox(width: 6),
                                        Text("Cisco: $cisco"),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text("correctAnswers: $correct"),
                                    Text("wrongAnswers: $wrong"),
                                    Text("total: $total"),
                                    Center(
                                      child: IconButton(
                                        icon: Icon(
                                          _showErrorss[index]
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _showErrorss[index] =
                                                !_showErrorss[index];
                                          });
                                        },
                                      ),
                                    ),
                                    if (_showErrorss[index] &&
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
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "• السؤال: ${wrong['question'] ?? ''}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "إجابتك: ${wrong['selectedAnswer'] ?? ''}",
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
                              // الدائرة
                              CircularPercentIndicator(
                                radius: 50.0,
                                lineWidth: 8.0,
                                percent: percent.clamp(0.0, 1.0),
                                center: Text(
                                  "${percent100.toStringAsFixed(1)}%",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                progressColor: _getScoreColor(percent),
                                backgroundColor: Colors.grey.shade200,
                                circularStrokeCap: CircularStrokeCap.round,
                                animation: true,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          else if (issucees == 2)
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : unexaminedData.isEmpty
                  ? Center(child: Text("🎉 كل الطلاب أكملوا الامتحانات"))
                  : ListView.builder(
                      itemCount: unexaminedData.length,
                      itemBuilder: (context, index) {
                        final user = unexaminedData[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            title: Text("👤 ${user['name']}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("🆔 Cisco: ${user['cisco']}"),
                                SizedBox(height: 5),
                                Text(
                                  "🚫 لم يمتحن: ${user['missingQuizzes'].join(', ')}",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          // Noexxam(quiez: widget.quizName),
          else if (issucees == 3)
            Expanded(
              child: FutureBuilder<Map<String, List<String>>>(
                future: _wrongQuestionsMapFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());
                  final data = snapshot.data!;

                  if (data.isEmpty) {
                    return const Center(
                      child: Text("لا توجد أخطاء في هذا الامتحان."),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final question = data.keys.elementAt(index);
                      final names = data[question]!;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "❌ السؤال:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(question),
                              const SizedBox(height: 12),
                              Text(
                                "عدد من أخطأ: ${names.length}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: names
                                    .map((name) => Chip(label: Text(name)))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
