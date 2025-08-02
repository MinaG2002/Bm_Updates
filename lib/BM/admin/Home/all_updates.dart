import 'package:bmproject/BM/Home/details/details_page.dart';
import 'package:bmproject/BM/Home/model/model_updates.dart';
import 'package:bmproject/BM/admin/Home/add_updates.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllUpdates extends StatefulWidget {
  const AllUpdates({super.key});

  @override
  State<AllUpdates> createState() => _AllUpdatesState();
}

class _AllUpdatesState extends State<AllUpdates> {
  List<PostModel> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('updates') // استبدلها باسم الـ Collection
          .orderBy('date', descending: true) // ترتيب حسب التاريخ
          .get();

      List<PostModel> loadedPosts = snapshot.docs.map((doc) {
        return PostModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      setState(() {
        posts = loadedPosts;
        isLoading = false;
      });
    } catch (e) {
      print('خطأ أثناء جلب البيانات: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Spacer(flex: 1),
          SizedBox(width: 10),
          Text(
            'All Updats',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Spacer(flex: 1),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: AppTheme.primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUpdates()),
              );
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppTheme.backgroundColor,
              // height: MediaQuery.of(context).size.height * 1 / 2 - 80,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  // List<PostModel> likes = posts["likes"] ?? [];
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: AppTheme.primaryColor,
                              ),
                              Spacer(flex: 1),
                              Text(DateFormat("yyyy-MM-dd").format(post.date)),
                            ],
                          ),
                          Text(
                            post.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            post.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppTheme.textPrimaryColor),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('تأكيد الحذف'),
                                      content: Text(
                                        'هل أنت متأكد أنك تريد حذف هذا التحديث؟',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(),
                                          child: Text('إلغاء'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                            deletePost(post.id);
                                          },
                                          child: Text(
                                            'حذف',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddUpdates(
                                        post: post, // نمرر البيانات لتعديلها
                                        isEdit: true,
                                      ),
                                    ),
                                  ).then((_) {
                                    fetchPosts(); // إعادة تحميل البيانات بعد التعديل
                                  });
                                },
                              ),
                              Spacer(flex: 1),
                              //confirm
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsPage(post: post),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    AppTheme.primaryColor,
                                  ),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.all(10),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "عرض التفاصيل",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              //confirm
                            ],
                          ),
                        ],
                      ),
                    ),
                    //end
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deletePost(String id) async {
    try {
      await FirebaseFirestore.instance.collection('updates').doc(id).delete();
      setState(() {
        posts.removeWhere((post) => post.id == id);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم حذف التحديث بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الحذف: $e')));
    }
  }
}
