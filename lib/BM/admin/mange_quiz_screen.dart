import 'package:bmproject/BM/admin/add_quiz_question_screen.dart';
import 'package:bmproject/BM/admin/edit_quiz_screen.dart';
import 'package:bmproject/BM/quiz/model/category.dart';
import 'package:bmproject/BM/quiz/model/quiz.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MangeQuizScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  const MangeQuizScreen({super.key, this.categoryId, this.categoryName});

  @override
  State<MangeQuizScreen> createState() => _MangeQuizScreenState();
}

class _MangeQuizScreenState extends State<MangeQuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId;
  List<Category> _categories = [];
  Category? _initialCategory;

  @override
  void initState() {
    super.initState();
    _fatchCategories();
  }

  Future<void> _fatchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      final categories = snapshot.docs
          .map((doc) => Category.fromMap(doc.id, doc.data()))
          .toList();
      setState(() {
        _categories = categories;

        if (widget.categoryId != null) {
          _initialCategory = _categories.firstWhere(
            (category) => category.id == widget.categoryId,
            orElse: () => Category(
              id: widget.categoryId!,
              name: 'unknown',
              description: '',
            ),
          );
          _selectedCategoryId = _initialCategory!.id;
        }
      });
    } catch (e) {}
  }

  Stream<QuerySnapshot> _getQuizStream() {
    Query query = _firestore.collection('quizzes');
    String? filterCategoryId = _selectedCategoryId ?? widget.categoryId;

    if (filterCategoryId != null && _selectedCategoryId!.isNotEmpty) {
      query = query.where('categoryId', isEqualTo: filterCategoryId);
    }
    return query.snapshots();
  }

  Widget _buildTitle() {
    String? categoryId = _selectedCategoryId ?? widget.categoryId;
    if (categoryId == null) {
      return const Text(
        "All Quizzes",
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('categories').doc(categoryId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading Category...");
        }
        final category = Category.fromMap(
          categoryId,
          snapshot.data!.data() as Map<String, dynamic>,
        );

        // final categoryData = snapshot.data!.data() as Map<String, dynamic>;
        return Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        actions: [
          IconButton(
            onPressed: () {
              //1:30
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddQuizQuestionScreen(
                    categoryId: _selectedCategoryId,
                    categoryName: widget.categoryName,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Quizzes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Category",
              ),
              value: _selectedCategoryId,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text("All Categories"),
                ),
                ..._categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                  // ignore: unnecessary_to_list_in_spreads
                }).toList(),
                if (_initialCategory != null &&
                    _categories.every((e) => e.id != _initialCategory!.id))
                  DropdownMenuItem(
                    // ignore: sort_child_properties_last
                    child: Text(_initialCategory!.name),
                    value: _initialCategory!.name,
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getQuizStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text("No quizzes found"));
                }

                final quizzes = snapshot.data!.docs
                    .map(
                      (doc) => Quiz.fromMap(
                        doc.id,
                        doc.data() as Map<String, dynamic>,
                      ),
                    )
                    .where(
                      (quiz) =>
                          _searchQuery.isEmpty ||
                          quiz.title.toLowerCase().contains(_searchQuery),
                    )
                    .toList();
                if (quizzes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No Quizzes yet",
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddQuizQuestionScreen(
                                  categoryId: _selectedCategoryId,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Add Quiz",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
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
                        title: Text(
                          quiz.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.question_answer_outlined),
                                const SizedBox(width: 4),
                                Text("${quiz.questions.length} Questions"),
                                const SizedBox(width: 16),
                                const Icon(Icons.timer_outlined, size: 16),
                                const SizedBox(width: 4),
                                Text("${quiz.timeLimit} mins"),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "edit",
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text("Edit"),
                                leading: Icon(
                                  Icons.edit_outlined,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: ListTile(
                                title: Text("Delete"),
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                          onSelected: (value) =>
                              _handleQuize(context, value, quiz),
                        ),
                        onTap: () {},
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

  Future<void> _handleQuize(
    BuildContext context,
    String value,
    Quiz quiz,
  ) async {
    if (value == "edit") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditQuizScreen(quiz: quiz)),
      );
    } else if (value == "delete") {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Quiz"),
            content: const Text("Are you sure you want to delete this quiz?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
      if (confirm == true) {
        await _firestore.collection('quizzes').doc(quiz.id).delete();
      }
    }
  }
}
