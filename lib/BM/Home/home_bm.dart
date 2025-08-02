import 'package:bmproject/BM/Home/Trubleshooting/trubleshooting.dart';
import 'package:bmproject/BM/Home/details/details_page.dart';
import 'package:bmproject/BM/Home/model/model_updates.dart';
import 'package:bmproject/BM/Home/stats/view/stats_screenbm.dart';
import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/admin/Home/Category/category_screen.dart';
import 'package:bmproject/BM/notification/notification_page.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:provider/provider.dart';

class HomeBm extends StatefulWidget {
  const HomeBm({super.key});

  @override
  State<HomeBm> createState() => _HomeBmState();
}

class _HomeBmState extends State<HomeBm> {
  List<PostModel> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    NoScreenshot.instance.screenshotOn();
  }

  // @override
  // void dispose() {
  //   NoScreenshot.instance.screenshotOn(); // إعادة السماح
  //   super.dispose();
  // }

  void fetchPosts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('updates')
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 136, 30, 53),

        actions: [
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(size: 38, Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 18),
          const Spacer(flex: 1),
          Text(
            S.of(context).Updates,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const Spacer(flex: 1),
          IconButton(
            icon: const Icon(
              size: 38,
              Icons.notifications_active_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                  //      NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(255, 136, 30, 53),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 130, child: StatesScreenBm()),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //start Trubleshooting
              Trubleshooting(),

              //end Trubleshooting
              Container(color: AppTheme.backgroundColor, height: 10),

              //start Category
              CategoryScreen(),
              //end cat
              Container(height: 11, color: AppTheme.backgroundColor),
              Container(
                color: AppTheme.backgroundColor,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      S.of(context).Latestupdates,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
              //end
            ],
          ),
        ),
      ),
    );
  }
}
