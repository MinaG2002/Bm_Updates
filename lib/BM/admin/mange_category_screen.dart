// ignore_for_file: prefer_const_constructors

import 'package:bmproject/BM/admin/add_category_screen.dart';
import 'package:bmproject/BM/admin/add_quiz_question_screen.dart';
import 'package:bmproject/BM/quiz/model/category.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MangeCategoryScreen extends StatefulWidget {
  const MangeCategoryScreen({super.key});

  @override
  State<MangeCategoryScreen> createState() => _MangeCategoryScreenState();
}

class _MangeCategoryScreenState extends State<MangeCategoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mange Categories",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: AppTheme.primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('categories')
            .orderBy("createdAt")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No Categories Found",
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 18,
                    ),
                  ),
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
                          builder: (context) => AddCategoryScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Add Category",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
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

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final Category category = categories[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  subtitle: Text(category.description, style: TextStyle()),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "edit",
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text("Edit"),
                          leading: Icon(
                            Icons.edit,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: ListTile(
                          title: Text("Delete"),
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.delete, color: Colors.redAccent),
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      _handleCategoryAction(context, value, category);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddQuizQuestionScreen(
                          categoryId: category.id,
                          categoryName: category.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleCategoryAction(
    BuildContext context,
    String action,
    Category category,
  ) async {
    if (action == "edit") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddCategoryScreen(category: category),
        ),
      );
    } else if (action == "delete") {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Delet Category"),
          content: Text(
            "Are you sure you want to delete the category '${category.name}'? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // try {
        await _firestore.collection('categories').doc(category.id).delete();
      }
    }
  }
}
