import 'package:bmproject/BM/Home/model/model_updates.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUpdates extends StatefulWidget {
  final PostModel? post;
  final bool isEdit;
  const AddUpdates({super.key, this.post, this.isEdit = false});

  @override
  // ignore: library_private_types_in_public_api
  _AddUpdatesState createState() => _AddUpdatesState();
}

class _AddUpdatesState extends State<AddUpdates> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlcontroller = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.post != null) {
      titleController.text = widget.post!.title;
      descriptionController.text = widget.post!.description;
    }
  }

  void submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      if (widget.isEdit && widget.post != null) {
        await FirebaseFirestore.instance
            .collection('updates')
            .doc(widget.post!.id)
            .update({
              'title': titleController.text,
              'description': descriptionController.text,
              'url': urlcontroller.text,
              'date': Timestamp.now(),
              "category": selectedcategorys,
            });
      } else {
        await FirebaseFirestore.instance.collection('updates').add({
          'title': titleController.text,
          'description': descriptionController.text,
          'url': urlcontroller.text,
          'date': Timestamp.now(),
          "category": selectedcategorys,
        });
      }
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  final categorys = [
    "Accounts & Certificates",
    "Services",
    "Important Information",
    "Cards",
    "Quality",
    "Latest News",
  ];
  String? selectedcategorys;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "تعديل المنشور" : 'اضافه منشور جديد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    fillColor: Colors.grey,
                    labelText: "Title",
                    hintText: "Enter Title",
                    prefixIcon: const Icon(
                      Icons.title,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? S.of(context).Pleaseenteryourname : null,
                  textInputAction: TextInputAction.next,
                ),
                // TextField(
                //   controller: titleController,
                //   decoration: InputDecoration(labelText: 'العنوان'),
                // ),
                SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    fillColor: Colors.grey,
                    labelText: "description",
                    hintText: "Enter description",
                    prefixIcon: const Icon(
                      Icons.note,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: urlcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    fillColor: Colors.grey,
                    labelText: "Url",
                    hintText: "Enter Url",
                    prefixIcon: const Icon(
                      Icons.photo,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  // validator: (value) =>
                  //     value!.isEmpty ? "please enter Url" : "",
                  // textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // enabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      fillColor: Colors.grey,

                      labelText: "Enter Category",
                      hintText: "Enter Category",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    items: categorys
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                    onChanged: (val) => selectedcategorys = val as String,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).Pleaseselectalocation;
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          submitUpdate();
                        },

                        //  addPost,
                        child: Text(widget.isEdit ? "حفظ التعديل" : 'نشر'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
