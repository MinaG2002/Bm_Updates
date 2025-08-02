import 'package:bmproject/BM/quiz/model/category.dart';
import 'package:bmproject/BM/quiz/model/questions.dart';
import 'package:bmproject/BM/quiz/model/quiz.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuizQuestionScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  const AddQuizQuestionScreen({super.key, this.categoryId, this.categoryName});

  @override
  State<AddQuizQuestionScreen> createState() => _AddQuizQuestionScreenState();
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

class _AddQuizQuestionScreenState extends State<AddQuizQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _selectedCategoryId;
  final List<QuestionFormItem> _questionsItems = [];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    _addQuestion();
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

  void _addQuestion() {
    setState(() {
      _questionsItems.add(
        QuestionFormItem(
          questionController: TextEditingController(),
          optionsControllers: List.generate(4, (_) => TextEditingController()),
          correctOptionIndex: 0,
        ),
      );
    });
  }

  Future<void> _saveQuiz() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
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
      await _firestore
          .collection('quizzes')
          .doc()
          .set(
            Quiz(
              id: _firestore.collection('quizzes').doc().id,
              title: _titleController.text.trim(),
              timeLimit: int.parse(_timeLimitController.text),
              categoryId: _selectedCategoryId!,
              questions: questions,
              createdAt: DateTime.now(),
            ).toMap(),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Quiz added successfully',
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
            'Error saving quiz: $e',
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

  void _removeQuestion(int index) {
    setState(() {
      _questionsItems[index].dispose();
      _questionsItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName != null
              ? "Add ${widget.categoryName} Quiz"
              : "Add Quiz Question",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // backgroundColor: const Color.fromARGB(255, 199, 38, 252),
        actions: [
          IconButton(
            color: AppTheme.primaryColor,
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveQuiz,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quiz Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
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
                if (widget.categoryId == null)
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('categories')
                        .orderBy("name")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        );
                      }
                      final categories = snapshot.data!.docs
                          .map(
                            (doc) => Category.fromMap(
                              doc.id,
                              doc.data() as Map<String, dynamic>,
                            ),
                          )
                          .toList();
                      return DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Select Category',
                          hintText: 'Choose a category ',
                          prefixIcon: Icon(
                            Icons.category,
                            color: AppTheme.primaryColor,
                          ),
                          // border: OutlineInputBorder(),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      );
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
                const SizedBox(height: 20),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            question.correctOptionIndex =
                                                value!;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: optionController,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Option ${optionIndex + 1}',
                                            hintText: 'Enter option text',
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                          onPressed: _isLoading ? null : _saveQuiz,
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
                              : const Text("Save Quiz"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//colors 2:47
