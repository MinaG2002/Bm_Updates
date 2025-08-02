// ignore_for_file: avoid_print, deprecated_member_use

import 'package:bmproject/BM/Home/details/details_page.dart';
import 'package:bmproject/BM/Home/model/model_updates.dart';
import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class CatCards extends StatefulWidget {
  const CatCards({super.key});

  @override
  State<CatCards> createState() => _CatCardsState();
}

class _CatCardsState extends State<CatCards> {
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
          .collection('updates')
          .where("category", isEqualTo: "Cards")
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    return Scaffold(
      appBar: AppBar(backgroundColor: AppTheme.primaryColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Center(
                child: Text(
                  "Cards",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  )
                : posts.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        "لا توجد منشورات حالياً",
                        style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: AppTheme.backgroundColor,

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
                                    Text(
                                      DateFormat(
                                        "yyyy-MM-dd",
                                      ).format(post.date),
                                    ),
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
                                  style: TextStyle(
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    LikeButton(
                                      isLiked: post.likes.contains(cisco),
                                      likeCount: post.likes.length,
                                      onTap: (isLiked) async {
                                        final postref = FirebaseFirestore
                                            .instance
                                            .collection("updates")
                                            .doc(post.id);
                                        if (isLiked) {
                                          await postref.update({
                                            "likes": FieldValue.arrayRemove([
                                              cisco,
                                            ]),
                                          });
                                        } else {
                                          await postref.update({
                                            "likes": FieldValue.arrayUnion([
                                              cisco,
                                            ]),
                                          });
                                        }
                                        return !isLiked;
                                      },
                                      likeBuilder: (isLiked) {
                                        return Icon(
                                          Icons.favorite,
                                          size: 30,
                                          color: isLiked
                                              ? AppTheme.primaryColor
                                              : Colors.grey,
                                        );
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
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              AppTheme.primaryColor,
                                            ),
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.all(10),
                                        ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
}
