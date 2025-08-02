import 'package:bmproject/BM/quiz/model/category.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  final Category? category;
  const AddCategoryScreen({super.key, this.category});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  @override
  void initState() {
    //error

    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _descriptionController = TextEditingController(
      text: widget.category?.description,
    );
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.category != null) {
        final updateCategory = widget.category!.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
        );
        await _firestore
            .collection('categories')
            .doc(widget.category!.id)
            .update(updateCategory.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category updated successfully')),
        );
      } else {
        await _firestore
            .collection('categories')
            .add(
              Category(
                id: _firestore.collection('categories').doc().id,
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
                createdAt: DateTime.now(),
              ).toMap(),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category added successfully')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      print("Error : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Discard Changes"),
          content: const Text("Are you sure want to discard changes?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Discard",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      );
      return confirm ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.category != null ? "Edit Category" : "Add Category",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Category Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create anew category for organizing your quizzes.",
                  style: TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    fillColor: Colors.white,
                    labelText: "Category Name",
                    hintText: "Enter category name",
                    prefixIcon: const Icon(
                      Icons.category_rounded,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter category name" : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: InputBorder.none,
                    fillColor: Colors.white,
                    labelText: "Description ",
                    hintText: "Enter category Description",
                    prefixIcon: const Icon(
                      Icons.description_rounded,
                      color: AppTheme.primaryColor,
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter Description name" : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _saveCategory,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 195, 29, 29),
                              ),
                              //  color: AppTheme.primaryColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.category != null
                                ? "Update Category"
                                : "Add Category",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//2:11
