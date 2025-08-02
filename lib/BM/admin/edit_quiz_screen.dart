import 'package:bmproject/BM/quiz/model/questions.dart';
import 'package:bmproject/BM/quiz/model/quiz.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditQuizScreen extends StatefulWidget {
  final Quiz quiz;
  const EditQuizScreen({super.key, required this.quiz});

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class QuestionFormItem {
  final TextEditingController questionController;
  final List<TextEditingController> optionsControllers;
  int correctOptionIndex;
  QuestionFormItem({
    required this.questionController,
    required this.optionsControllers,
    required this.correctOptionIndex,
  });
  void dispose() {
    questionController.dispose();
    for (var controller in optionsControllers) {
      controller.dispose();
    }
  }
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _timeLimitController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  late List<QuestionFormItem> _questionsItems;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _timeLimitController.dispose();
    for (var item in _questionsItems) {
      item.dispose();
    }
    super.dispose();
  }

  void _initData() {
    _titleController = TextEditingController(text: widget.quiz.title);
    _timeLimitController = TextEditingController(
      text: widget.quiz.timeLimit.toString(),
    );
    _questionsItems = widget.quiz.questions.map((question) {
      return QuestionFormItem(
        questionController: TextEditingController(text: question.text),
        optionsControllers: question.options
            .map((option) => TextEditingController(text: option))
            .toList(),
        correctOptionIndex: question.correctOptionsIndex,
      );
    }).toList();
  }

  void _addQuestion() {
    setState(() {
      _questionsItems.add(
        QuestionFormItem(
          questionController: TextEditingController(),
          optionsControllers: List.generate(4, (e) => TextEditingController()),
          correctOptionIndex: 0,
        ),
      );
    });
  }

  void _removeQuestion(int index) {
    if (_questionsItems.length > 1) {
      setState(() {
        _questionsItems[index].dispose();
        _questionsItems.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz must have at least one question')),
      );
    }
  }

  Future<void> _updateQuiz() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final questions = _questionsItems
          .map(
            (item) => Question(
              text: item.questionController.text.trim(),
              options: item.optionsControllers
                  .map((e) => e.text.trim())
                  .toList(),
              correctOptionsIndex: item.correctOptionIndex,
            ),
          )
          .toList();
      final updateQuiz = widget.quiz.copywith(
        title: _titleController.text.trim(),
        timeLimit: int.parse(_timeLimitController.text),
        questions: questions,
        createdAt: widget.quiz.createdAt,
      );

      await _firestore
          .collection('quizzes')
          .doc(widget.quiz.id)
          .update(updateQuiz.toMap(isUpdate: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Quiz Updated successfully',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error saving quiz: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error Updated quiz: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        actions: [
          const Spacer(flex: 1),
          const Text(
            '         Edit Quiz',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Spacer(flex: 1),
          IconButton(
            color: AppTheme.primaryColor,
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _updateQuiz,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Quiz Title',
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Quiz Title',
                hintText: 'Enter the title of the quiz',
                prefixIcon: Icon(Icons.title, color: AppTheme.primaryColor),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quiz title';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _timeLimitController,
              decoration: const InputDecoration(
                labelText: 'Time Limit (minutes)',
                hintText: 'Enter time limit for the quiz',
                prefixIcon: Icon(Icons.timer, color: AppTheme.primaryColor),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a time limit';
                }
                final intValue = int.tryParse(value);
                if (intValue == null || intValue <= 0) {
                  return 'Please enter a valid time limit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Questions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _addQuestion,
                      label: const Text("Add Question"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ..._questionsItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final QuestionFormItem question = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Question ${index + 1}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              if (_questionsItems.length > 1)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeQuestion(index),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: question.questionController,
                            decoration: const InputDecoration(
                              labelText: 'Question',
                              hintText: 'Enter the question text',
                              prefixIcon: Icon(
                                Icons.question_answer,
                                color: AppTheme.primaryColor,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a question';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ...question.optionsControllers.asMap().entries.map((
                            entry,
                          ) {
                            final optionIndex = entry.key;
                            final optionController = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Radio<int>(
                                    activeColor: AppTheme.primaryColor,
                                    value: optionIndex,
                                    groupValue: question.correctOptionIndex,
                                    onChanged: (value) {
                                      setState(() {
                                        question.correctOptionIndex = value!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: optionController,
                                      decoration: InputDecoration(
                                        labelText: 'Option ${optionIndex + 1}',
                                        hintText: 'Enter option text',
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter option text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        // padding: EdgeInsets.symmetric(vertical: 55),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Update Quiz"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
