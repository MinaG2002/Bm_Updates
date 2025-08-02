import 'package:bmproject/BM/Login/view/Login.dart';
import 'package:bmproject/BM/admin/mange_category_screen.dart';
import 'package:bmproject/BM/admin/mange_quiz_screen.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>> _fatchStatistics() async {
    final categoriesCount = await _firestore
        .collection("categories")
        .count()
        .get();

    final quizzesCount = await _firestore.collection("quizzes").count().get();

    //get latest quiz
    final latestQuizzes = await _firestore
        .collection("quizzes")
        .orderBy("createdAt", descending: true)
        .limit(5)
        .get();

    final categories = await _firestore.collection("categories").get();

    final categoryDate = await Future.wait(
      categories.docs.map((category) async {
        final quizCount = await _firestore
            .collection("quizzes")
            .where("categoryId", isEqualTo: category.id)
            .count()
            .get();
        return {
          //   "id": Category.id,
          "name": category.data()["name"] as String,
          "count": quizCount.count,
        };
      }),
    );

    return {
      "totlCategories": categoriesCount.count,
      "totalquizzes": quizzesCount.count,
      "latestQuizzes": latestQuizzes.docs,
      "categoryDate": categoryDate,
    };
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 25),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashbordCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        backgroundColor: AppTheme.backgroundColor,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _fatchStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          final Map<String, dynamic> stats = snapshot.data!;
          //anerror
          //  final List<dynamic> categoryData = stats["categoryDate"] ?? [];
          final List<dynamic> categoryData = stats["categoryDate"] ?? [];

          final List<QueryDocumentSnapshot> latestQuizzes =
              stats["latestQuizzes"];
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Admin",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Here your quiz application overview",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "Total Categories",
                          stats["totlCategories"].toString(),
                          Icons.category,
                          AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          "Total Quizzes",
                          stats["totalquizzes"].toString(),
                          Icons.quiz,
                          AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  //start
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.pie_chart_rounded,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Category Statitcs",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryData.length,
                    itemBuilder: (context, index) {
                      final category = categoryData[index];
                      final totalQuizzes = categoryData.fold<int>(
                        0,
                        (sum, item) => sum + (item["count"] as int),
                      );
                      final percentage = totalQuizzes > 0
                          ? (category["count"] as int) / totalQuizzes * 100
                          : 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category["name"] as String,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${category["count"]}${(category["count"] as int) == 1 ? "quiz" : "quizzes"}     ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(1.0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${percentage.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Colors.white, // AppTheme.textPrimaryColor
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  //end
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.history,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Recent Activity",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 0,
                    itemBuilder: (context, index) {
                      final Quiz =
                          latestQuizzes[index].data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.quiz_rounded,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Quiz["title"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Created on: ${_formatDate(Quiz["createdAt"].toDate())}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  //end
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.speed_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Quiz Actions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 16,
                              children: [
                                _buildDashbordCard(
                                  context,
                                  " Quizzes",
                                  Icons.quiz_rounded,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MangeQuizScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _buildDashbordCard(
                                  context,
                                  " Categories",
                                  Icons.category_rounded,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MangeCategoryScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//41:40
