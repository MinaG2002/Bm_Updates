// import 'dart:async';

// import 'package:bmproject/BM/quiz/model/questions.dart';
// import 'package:bmproject/BM/quiz/model/quiz.dart';
// import 'package:bmproject/BM/quiz/user/quiz_result_screen.dart';
// import 'package:bmproject/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class QuizPlayScreen extends StatefulWidget {
//   final Quiz quiz;
//   const QuizPlayScreen({super.key, required this.quiz});

//   @override
//   State<QuizPlayScreen> createState() => _QuizPlayScreenState();
// }

// class _QuizPlayScreenState extends State<QuizPlayScreen>
//     with SingleTickerProviderStateMixin {
//   late PageController _pageController;
//   int _currentQuestionIndex = 0;
//   final Map<int, int> _selectedAnswers = {};
//   int _totalMinutes = 0;
//   int _remainingMinuts = 0;
//   int _remainingSeconds = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _totalMinutes = widget.quiz.timeLimit;
//     _remainingMinuts = _totalMinutes;
//     _remainingSeconds = 0;
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_remainingSeconds > 0) {
//           _remainingSeconds--;
//         } else {
//           if (_remainingMinuts > 0) {
//             _remainingMinuts--;
//             _remainingSeconds = 59; // Reset seconds to 59
//           } else {
//             _timer?.cancel();
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text('Time is up!'),
//                 content: const Text(
//                   'You have reached the time limit for this quiz.',
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('OK'),
//                   ),
//                 ],
//               ),
//             );
//             _completeQuiz();
//           }
//         }
//       });
//     });
//   }

//   void _selectAnswer(int optionIndex) {
//     if (_selectedAnswers[_currentQuestionIndex] == null) {
//       setState(() {
//         _selectedAnswers[_currentQuestionIndex] = optionIndex;
//       });
//     }
//   }

//   void _nextQuestion() {
//     if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       // If it's the last question, complete the quiz
//       _completeQuiz();
//     }
//   }

//   void _completeQuiz() {
//     _timer?.cancel();
//     int correctAnswers = _calcuteScore();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Quiz completed! You answered $correctAnswers out of ${widget.quiz.questions.length} questions correctly.',
//         ),
//       ),
//     );
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QuizResultScreen(
//           quiz: widget.quiz,
//           totalQuestions: widget.quiz.questions.length,
//           correctAnswers: correctAnswers,
//           selectedAnswers: _selectedAnswers,
//         ),
//       ),
//     );
//   }

//   int _calcuteScore() {
//     int correctAnswers = 0;
//     for (int i = 0; i < widget.quiz.questions.length; i++) {
//       final selectedAnswers = _selectedAnswers[i];
//       if (selectedAnswers != null &&
//           selectedAnswers == widget.quiz.questions[i].correctOptionsIndex) {
//         correctAnswers++;
//       }
//     }
//     return correctAnswers;
//   }

//   Color _getTimerColor() {
//     double timeprogres =
//         1 - (_remainingMinuts * 60 + _remainingSeconds / (_totalMinutes * 60));
//     if (timeprogres < 0.4) {
//       return Colors.green; // More than half time left
//     } else if (timeprogres < 0.6) {
//       return Colors.orange; // Less than half but more than 20% time left
//     } else {
//       return Colors.redAccent; // Less than 20% time left
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.primaryColor,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.all(12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.close,
//                           color: AppTheme.textPrimaryColor,
//                         ),
//                       ),
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           SizedBox(
//                             height: 35,
//                             width: 35,
//                             child: CircularProgressIndicator(
//                               value:
//                                   (_remainingMinuts * 60 + _remainingSeconds) /
//                                   (_totalMinutes * 60),
//                               strokeAlign: 5,
//                               backgroundColor: Colors.grey[300],
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 _getTimerColor(),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '${_remainingMinuts.toString().padLeft(2, '0')}:${_remainingSeconds.toString().padLeft(2, '0')}',
//                             style: TextStyle(
//                               color: _getTimerColor(),
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   TweenAnimationBuilder<double>(
//                     tween: Tween(
//                       begin: 0,
//                       end:
//                           (_currentQuestionIndex + 1) /
//                           widget.quiz.questions.length,
//                     ),
//                     duration: const Duration(milliseconds: 300),
//                     builder: (context, value, child) {
//                       return LinearProgressIndicator(
//                         value: value,
//                         backgroundColor: Colors.grey[300],
//                         color: Colors.grey[300],
//                         valueColor: const AlwaysStoppedAnimation<Color>(
//                           AppTheme.primaryColor,
//                         ),
//                         minHeight: 6,
//                         borderRadius: const BorderRadius.horizontal(
//                           left: Radius.circular(10),
//                           right: Radius.circular(10),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: widget.quiz.questions.length,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentQuestionIndex = index;
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   final question = widget.quiz.questions[index];
//                   return _buildQuestionCard(question, index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuestionCard(Question question, int index) {
//     return Container(
//           margin: const EdgeInsets.all(16),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Question ${index + 1}/${widget.quiz.questions.length}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.textSecondaryColor,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 question.text,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: AppTheme.textPrimaryColor,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               ...question.options.asMap().entries.map((entry) {
//                 final optionIndex = entry.key;
//                 final option = entry.value;
//                 final isSelected = _selectedAnswers[index] == optionIndex;
//                 final isCorrect =
//                     _selectedAnswers[index] == question.correctOptionsIndex;
//                 return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? isCorrect
//                                     ? AppTheme.secondaryColor.withOpacity(0.1)
//                                     : Colors.redAccent.withOpacity(0.1)
//                               : Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected
//                                 ? isCorrect
//                                       ? AppTheme.secondaryColor
//                                       : Colors.redAccent
//                                 : Colors.grey,
//                           ),
//                         ),
//                         child: ListTile(
//                           onTap: _selectedAnswers[index] == null
//                               ? () {
//                                   _selectAnswer(optionIndex);
//                                 }
//                               : null,
//                           title: Text(
//                             option,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: isSelected
//                                   ? isCorrect
//                                         ? AppTheme.secondaryColor
//                                         : Colors.redAccent
//                                   : _selectedAnswers[index] != null
//                                   ? Colors.grey.shade500
//                                   : AppTheme.textPrimaryColor,
//                             ),
//                           ),
//                           trailing: isSelected
//                               ? isCorrect
//                                     ? const Icon(
//                                         Icons.check_circle,
//                                         color: AppTheme.secondaryColor,
//                                         size: 24,
//                                       )
//                                     : const Icon(
//                                         Icons.cancel,
//                                         color: Colors.redAccent,
//                                         size: 24,
//                                       )
//                               : null,
//                         ),
//                       ),
//                     )
//                     .animate(delay: const Duration(milliseconds: 300))
//                     .slideX(
//                       begin: 0.5,
//                       end: 0,
//                       duration: const Duration(milliseconds: 300),
//                     )
//                     .fadeIn();
//               }),
//               const Spacer(),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                   ),
//                   onPressed: () {
//                     _selectedAnswers[index] != null
//                         ? _nextQuestion()
//                         : ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please select an answer first.'),
//                             ),
//                           );
//                   },
//                   child: Text(
//                     index == widget.quiz.questions.length - 1
//                         ? "Finish Quiz"
//                         : "Next Question",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//         .animate()
//         .fadeIn(duration: const Duration(milliseconds: 500))
//         .slideY(begin: 0.1, end: 0, duration: const Duration(milliseconds: 300))
//         .fadeIn();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmproject/BM/quiz/model/questions.dart';
import 'package:bmproject/BM/quiz/model/quiz.dart';
import 'package:bmproject/BM/quiz/user/quiz_result_screen.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;
  const QuizPlayScreen({super.key, required this.quiz});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  int _totalMinutes = 0;
  int _remainingMinuts = 0;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _totalMinutes = widget.quiz.timeLimit;
    _currentQuestionIndex = prefs.getInt('currentIndex') ?? 0;
    _remainingMinuts = prefs.getInt('remainingMin') ?? _totalMinutes;
    _remainingSeconds = prefs.getInt('remainingSec') ?? 0;

    final savedAnswers = prefs.getString('selectedAnswers');
    if (savedAnswers != null) {
      final Map<String, dynamic> decoded = jsonDecode(savedAnswers);
      _selectedAnswers.clear();
      decoded.forEach((key, value) {
        _selectedAnswers[int.parse(key)] = value;
      });
    }

    setState(() {});
    _pageController.jumpToPage(_currentQuestionIndex);
    _startTimer();
  }

  void _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentIndex', _currentQuestionIndex);
    prefs.setInt('remainingMin', _remainingMinuts);
    prefs.setInt('remainingSec', _remainingSeconds);
    prefs.setString('selectedAnswers', jsonEncode(_selectedAnswers));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          if (_remainingMinuts > 0) {
            _remainingMinuts--;
            _remainingSeconds = 59;
          } else {
            _timer?.cancel();
            _completeQuiz();
          }
        }
        _saveState(); // يتم الحفظ كل ثانية
      });
    });
  }

  void _selectAnswer(int optionIndex) {
    if (_selectedAnswers[_currentQuestionIndex] == null) {
      setState(() {
        _selectedAnswers[_currentQuestionIndex] = optionIndex;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() async {
    _timer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentIndex');
    await prefs.remove('remainingMin');
    await prefs.remove('remainingSec');
    await prefs.remove('selectedAnswers');

    int correctAnswers = _calcuteScore();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Quiz completed! You answered $correctAnswers out of ${widget.quiz.questions.length} correctly.',
        ),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quiz: widget.quiz,
          totalQuestions: widget.quiz.questions.length,
          correctAnswers: correctAnswers,
          selectedAnswers: _selectedAnswers,
        ),
      ),
    );
  }

  int _calcuteScore() {
    int correctAnswers = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final selectedAnswer = _selectedAnswers[i];
      if (selectedAnswer != null &&
          selectedAnswer == widget.quiz.questions[i].correctOptionsIndex) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  Color _getTimerColor() {
    double timeProgress =
        1 - (_remainingMinuts * 60 + _remainingSeconds) / (_totalMinutes * 60);
    if (timeProgress < 0.4) {
      return Colors.green;
    } else if (timeProgress < 0.6) {
      return Colors.orange;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // منع الرجوع
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timer and header
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ), // لن يعمل بسبب WillPop
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 35,
                              width: 35,
                              child: CircularProgressIndicator(
                                value:
                                    (_remainingMinuts * 60 +
                                        _remainingSeconds) /
                                    (_totalMinutes * 60),
                                strokeAlign: 5,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTimerColor(),
                                ),
                              ),
                            ),
                            Text(
                              '${_remainingMinuts.toString().padLeft(2, '0')}:${_remainingSeconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: _getTimerColor(),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end:
                            (_currentQuestionIndex + 1) /
                            widget.quiz.questions.length,
                      ),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                          minHeight: 6,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Question & Options
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.quiz.questions.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentQuestionIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final question = widget.quiz.questions[index];
                    return _buildQuestionCard(question, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${index + 1}/${widget.quiz.questions.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                question.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 24),
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final isSelected = _selectedAnswers[index] == optionIndex;
                final isCorrect = optionIndex == question.correctOptionsIndex;

                return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? isCorrect
                                    ? AppTheme.secondaryColor.withOpacity(0.1)
                                    : Colors.redAccent.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? isCorrect
                                      ? AppTheme.secondaryColor
                                      : Colors.redAccent
                                : Colors.grey,
                          ),
                        ),
                        child: ListTile(
                          onTap: _selectedAnswers[index] == null
                              ? () => _selectAnswer(optionIndex)
                              : null,
                          title: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? isCorrect
                                        ? AppTheme.secondaryColor
                                        : Colors.redAccent
                                  : _selectedAnswers[index] != null
                                  ? Colors.grey.shade500
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                          trailing: isSelected
                              ? isCorrect
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: AppTheme.secondaryColor,
                                        size: 24,
                                      )
                                    : const Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                        size: 24,
                                      )
                              : null,
                        ),
                      ),
                    )
                    .animate(delay: const Duration(milliseconds: 300))
                    .slideX(begin: 0.5, end: 0)
                    .fadeIn();
              }),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  onPressed: () {
                    _selectedAnswers[index] != null
                        ? _nextQuestion()
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an answer first.'),
                            ),
                          );
                  },
                  child: Text(
                    index == widget.quiz.questions.length - 1
                        ? "Finish Quiz"
                        : "Next Question",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 500))
        .slideY(begin: 0.1, end: 0);
  }
}
