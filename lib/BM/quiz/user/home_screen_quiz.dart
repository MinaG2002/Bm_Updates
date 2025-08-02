import 'package:bmproject/BM/quiz/model/category.dart';
import 'package:bmproject/BM/quiz/user/category_screen.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreenQuiz extends StatefulWidget {
  const HomeScreenQuiz({super.key});

  @override
  State<HomeScreenQuiz> createState() => _HomeScreenQuizState();
}

class _HomeScreenQuizState extends State<HomeScreenQuiz> {
  final TextEditingController _searchController = TextEditingController();
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<String> _categoryfilters = ["All"];
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .orderBy("createdAt", descending: true)
        .get();

    setState(() {
      _allCategories = snapshot.docs
          .map((doc) => Category.fromMap(doc.id, doc.data()))
          .toList();
      _categoryfilters =
          ["All"] +
          _allCategories.map((category) => category.name).toSet().toList();
      _filteredCategories = _allCategories;
    });
  }

  void _filterCategories(String query, {String? categoryFilter}) {
    setState(() {
      _filteredCategories = _allCategories.where((category) {
        final matchesSerach =
            category.name.toLowerCase().contains(query.toLowerCase()) ||
            category.description.toLowerCase().contains(query.toLowerCase());
        final matchesCategoryFilter =
            categoryFilter == null ||
            categoryFilter == "All" ||
            category.name == categoryFilter.toLowerCase();
        return matchesSerach && matchesCategoryFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 225,
            pinned: true,
            floating: true,
            centerTitle: true,
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            title: const Text(
              "Smart Quiz",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome, Agent!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Let's test your knowledge Today",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                _filterCategories(
                                  value,
                                  categoryFilter: _selectedCategory,
                                );
                              },
                              decoration: const InputDecoration(
                                hintText: "Search categories....",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categoryfilters.length,
                itemBuilder: (context, index) {
                  final filter = _categoryfilters[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: _selectedCategory == filter
                              ? Colors.white
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                      selected: _selectedCategory == filter,
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = filter;
                          _filterCategories(
                            _searchController.text,
                            categoryFilter: filter,
                          );
                        });
                      },
                      labelStyle: TextStyle(
                        color: _selectedCategory == filter
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _filteredCategories.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "No Category Found",
                        style: TextStyle(color: AppTheme.textSecondaryColor),
                      ),
                    ),
                  )
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildCategoryCard(_filteredCategories[index], index),
                      childCount: _filteredCategories.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category, int index) {
    return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(category: category),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.quiz,
                      size: 48,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideY(begin: 0.5, end: 0, duration: const Duration(milliseconds: 300))
        .fadeIn();
  }
}
