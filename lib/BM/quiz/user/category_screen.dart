import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/quiz/model/category.dart';
import 'package:bmproject/BM/quiz/model/quiz.dart';
import 'package:bmproject/BM/quiz/user/quiz_play_screen.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Quiz> _quizzes = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('categoryId', isEqualTo: widget.category.id)
          .get();

      setState(() {
        _quizzes = snapshot.docs
            .map((doc) => Quiz.fromMap(doc.id, doc.data()))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Filed to load quizzes'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            )
          : _quizzes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.quiz_outlined,
                    size: 64,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No quizzes available in this category',
                    style: TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text(
                      'Back to Categories',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  foregroundColor: Colors.white,
                  backgroundColor: AppTheme.primaryColor,
                  expandedHeight: 230,
                  floating: false,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.category.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    background: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.category_rounded,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.category.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = _quizzes[index];
                        return _buildQuizCard(quiz, index);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<bool> _checkIfQuizAttempted(
    String title,
    String currentCiscoNumber,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('scores')
          .where('Quiz', isEqualTo: title)
          .where('cisco', isEqualTo: currentCiscoNumber)
          .get();

      return snapshot.docs.isNotEmpty; // لو في نتيجة إذًا أجرى الامتحان من قبل
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error checking quiz attempt.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false; // في حالة الخطأ اسمح له بالدخول بشكل مؤقت
    }
  }

  Widget _buildQuizCard(Quiz quiz, int index) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentCiscoNumber = userProvider.userCisco;
    return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              bool hasAttempted = await _checkIfQuizAttempted(
                quiz.title,
                currentCiscoNumber!,
              );
              if (hasAttempted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have already attempted this quiz.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPlayScreen(quiz: quiz),
                  ),
                );
              }
            },

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => QuizPlayScreen(quiz: quiz),
            //   ),
            // );
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.quiz_rounded,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 9),
                            Row(
                              children: [
                                const Icon(
                                  Icons.question_answer_outlined,
                                  //  color: AppTheme.textSecondaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${quiz.questions.length} Questions',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.timer_outlined,
                                  //  color: AppTheme.textSecondaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${quiz.timeLimit} mins',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.primaryColor,
                    size: 35,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: index * 100))
        .slideX(begin: 0.5, end: 0, duration: const Duration(milliseconds: 350))
        .fadeIn();
  }
}
