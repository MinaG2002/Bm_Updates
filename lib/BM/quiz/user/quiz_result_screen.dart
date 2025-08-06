import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/nav_bar/view/nav_bar.dart';
import 'package:bmproject/BM/quiz/model/quiz.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class QuizResultScreen extends StatefulWidget {
  final Quiz quiz;
  final int totalQuestions;
  final int correctAnswers;
  final Map<int, int?> selectedAnswers;
  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.selectedAnswers,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    ).animate().scale(
      duration: const Duration(milliseconds: 400),
      delay: const Duration(milliseconds: 300),
      // curve: Curves.easeInOut,
    );
  }

  Widget _buildAnsuwerRow(String label, String answer, Color answerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: answerColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 16,
              color: answerColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 400),
      delay: const Duration(milliseconds: 300),
    );
  }

  IconData _getPerformanceIcon(double score) {
    if (score >= 0.9) return Icons.emoji_events;
    if (score >= 0.8) return Icons.star;
    if (score >= 0.6) return Icons.thumb_up;
    if (score >= 0.4) return Icons.trending_up;
    return Icons.refresh;
  }

  Color _getScoreColor(double score) {
    if (score >= 0.8) return Colors.green;

    if (score >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _getPerformancMessage(double score) {
    if (score >= 0.9) return "Excellent!";
    if (score >= 0.8) return " Great Job!";
    if (score >= 0.6) return "Good Effort!";
    if (score >= 0.4) return "Keep Trying!";
    return "try Again!";
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final name = userProvider.userName ?? 'Unknown';
    final cisco = userProvider.userCisco ?? '0000';
    final leader = userProvider.userleader ?? 'Unknown';
    final superr = userProvider.usersuper ?? 'Unknown';
    final manger = userProvider.usermanager ?? 'Unknown';
    final location = userProvider.userlocation ?? 'Unknown';
    final score = widget.correctAnswers / widget.totalQuestions;
    final int scorepercentage = (score * 100).round();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  //  color: AppTheme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text("     "),
                          // IconButton(
                          //   onPressed: () async {
                          //     Navigator.pop(context);
                          //     final userProvider = Provider.of<UserProvider>(
                          //       context,
                          //       listen: false,
                          //     );
                          //     final name = userProvider.userName ?? 'Unknown';
                          //     final cisco = userProvider.userCisco ?? '0000';
                          //     // استخدم المتغير الخارجي score مباشرة

                          //     await FirebaseFirestore.instance
                          //         .collection('scores')
                          //         .add({
                          //           "Quiz": widget.quiz.title,
                          //           "correctAnswers": widget.correctAnswers,
                          //           "totalQuestions": widget.totalQuestions,
                          //           'name': name,
                          //           'cisco': cisco,
                          //           'score': score * 100,
                          //           'timestamp': DateTime.now(),
                          //         });

                          //   },
                          //   icon: const Icon(
                          //     Icons.arrow_back_ios,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          const Text(
                            "Quiz Result",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ), // Placeholder for alignment
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: CircularPercentIndicator(
                            radius: 100,
                            lineWidth: 15,
                            animation: true,
                            animationDuration: 1500,
                            percent: score,
                            center: Column(
                              mainAxisSize: MainAxisSize.min,
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$scorepercentage%",
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    //  _getScoreColor(score),
                                  ),
                                ),
                                Text(
                                  (widget.correctAnswers /
                                          widget.totalQuestions)
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    // _getScoreColor(score),
                                  ),
                                ),
                              ],
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.white,
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ).animate().scale(
                      curve: Curves.easeInOut,
                      delay: const Duration(milliseconds: 100),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 55,
                      margin: const EdgeInsets.only(bottom: 30),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getPerformanceIcon(score),
                            color: _getScoreColor(score),
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getPerformancMessage(score),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(score),
                            ),
                          ),
                        ],
                      ),
                    ).animate().slideY(
                      begin: 0.3,
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "correct",
                        widget.correctAnswers.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        "incorrect",
                        (widget.totalQuestions - widget.correctAnswers)
                            .toString(),
                        Icons.cancel,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics, color: AppTheme.primaryColor),
                        SizedBox(width: 8),
                        Text(
                          "Detailed Results",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...widget.quiz.questions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final question = entry.value;
                      final selectedAnswer = widget.selectedAnswers[index];
                      final isCorrect =
                          selectedAnswer != null &&
                          selectedAnswer == question.correctOptionsIndex;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCorrect
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                              ),
                              child: Icon(
                                isCorrect
                                    ? Icons.check_circle_outline
                                    : Icons.cancel,
                                color: isCorrect
                                    ? Colors.green
                                    : Colors.redAccent,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              "Question ${index + 1}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            subtitle: Text(
                              question.text,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            children: [
                              Text(
                                question.text,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryColor,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 9),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildAnsuwerRow(
                                    "Your Answer",
                                    question.options[selectedAnswer ?? -1],
                                    isCorrect ? Colors.green : Colors.red,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildAnsuwerRow(
                                    "Correct Answer",
                                    question.options[question
                                        .correctOptionsIndex],
                                    Colors.blue,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().slideX(
                        begin: 0.3,
                        duration: const Duration(milliseconds: 400),
                        delay: Duration(milliseconds: 100 * index),
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // final userProvider = Provider.of<UserProvider>(
                          //   context,
                          //   listen: false,
                          // );
                          // final name = userProvider.userName ?? 'Unknown';
                          // final cisco = userProvider.userCisco ?? '0000';
                          // final leader = userProvider.userleader ?? 'Unknown';
                          // final superr = userProvider.usersuper ?? 'Unknown';
                          // final manger = userProvider.usermanager ?? 'Unknown';
                          // final location =
                          //     userProvider.userlocation ?? 'Unknown';

                          // استخدم المتغير الخارجي score مباشرة

                          // إنشاء قائمة للإجابات الخاطئة
                          List<Map<String, dynamic>> wrongAnswers = [];

                          // التكرار عبر الأسئلة وتحديد الإجابات الخاطئة
                          for (var entry
                              in widget.quiz.questions.asMap().entries) {
                            final index = entry.key;
                            final question = entry.value;
                            final selectedAnswer =
                                widget.selectedAnswers[index];

                            final isCorrect =
                                selectedAnswer != null &&
                                selectedAnswer == question.correctOptionsIndex;

                            if (!isCorrect &&
                                selectedAnswer != null &&
                                selectedAnswer >= 0 &&
                                selectedAnswer < question.options.length) {
                              wrongAnswers.add({
                                'question': question.text,
                                'selectedAnswer':
                                    question.options[selectedAnswer],
                              });
                            }
                          }

                          await FirebaseFirestore.instance
                              .collection('scores')
                              .add({
                                "Quiz": widget.quiz.title,
                                "correctAnswers": widget.correctAnswers,
                                "totalQuestions": widget.totalQuestions,
                                'name': name,
                                'cisco': cisco,
                                'score': score * 100,
                                'timestamp': DateTime.now(),
                                'wrongAnswers': wrongAnswers,
                                // إضافة الإجابات الخاطئة هنا
                                "Location": location,
                                "Leader": leader,
                                "Manger": manger,
                                "Suber": superr,
                              });
                          //  Navigator.pop(context);

                          // ترجع للخلف أو تروح لصفحة الرانك:
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomNavBarBM(),
                            ),
                          );
                        },
                        label: const Text(
                          "Finsh",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // icon: const Icon(
                        //   Icons.refresh,
                        //   size: 24,
                        //   color: Colors.white,
                        // ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          //  primary: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
