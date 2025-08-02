import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Noexxam extends StatefulWidget {
  final String quiez;
  const Noexxam({super.key, required this.quiez});

  @override
  State<Noexxam> createState() => _NoexxamState();
}

class _NoexxamState extends State<Noexxam> {
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
      // ✅ 1. جلب جميع الامتحانات المرتبطة بالليدر
      final allQuizNames = [widget.quiez];

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
          .where('Quiz', isEqualTo: widget.quiez)
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
