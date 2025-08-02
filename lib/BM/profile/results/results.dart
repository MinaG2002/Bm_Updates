import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamDetailsPage extends StatefulWidget {
  final String userCisco;

  const ExamDetailsPage({super.key, required this.userCisco});

  @override
  State<ExamDetailsPage> createState() => _ExamDetailsPageState();
}

class _ExamDetailsPageState extends State<ExamDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final cisco = userProvider.userCisco;
    final name = userProvider.userName;
    return Scaffold(
      //  backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Result: ${name} ${widget.userCisco}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('scores')
            .where('cisco', isEqualTo: widget.userCisco)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final exams = snapshot.data!.docs;

          if (exams.isEmpty) {
            return Center(child: Text('لا توجد نتائج لهذا المستخدم.'));
          }

          return ListView.builder(
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index].data() as Map<String, dynamic>;
              final wrongAnswers = List<Map<String, dynamic>>.from(
                exam['wrongAnswers'] ?? [],
              );
              final timestamp = (exam['timestamp'] as Timestamp).toDate();

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "📊 النسبه: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${exam['score'].toStringAsFixed(2)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "📝 اسم الامتحان: ${exam['Quiz']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "📅 التاريخ: ${timestamp.day}/${timestamp.month}/${timestamp.year}",
                      ),
                      SizedBox(height: 4),
                      Text(
                        "✅ عدد الإجابات الصحيحة: ${exam['correctAnswers']} / ${exam['totalQuestions']}",
                      ),
                      if (wrongAnswers.isNotEmpty) ...[
                        SizedBox(height: 10),
                        Text(
                          "❌ الأخطاء:",
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...wrongAnswers.map(
                          (wrong) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "• السؤال: ${wrong['question']}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "إجابتك: ${wrong['selectedAnswer']}",
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
