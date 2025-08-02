import 'package:bmproject/BM/admin/Home/Category/Accounts/cat_account.dart';
import 'package:bmproject/BM/admin/Home/Category/Cards/cat_cards.dart';
import 'package:bmproject/BM/admin/Home/Category/Information/cat_information.dart';
import 'package:bmproject/BM/admin/Home/Category/News/cat_news.dart';
import 'package:bmproject/BM/admin/Home/Category/Quality/cat_quality.dart';
import 'package:bmproject/BM/admin/Home/Category/Services/cat_sertvices.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.backgroundColor,
          child: Row(
            children: [
              SizedBox(width: 10),
              Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        Container(color: AppTheme.backgroundColor, height: 10),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(padding: EdgeInsetsGeometry.only(left: 10)),
              Container(
                color: AppTheme.backgroundColor,
                child: Column(
                  children: [
                    //row1
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatAccount(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 1 / 2,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Accounts & Certificates",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatSertvices(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 1 / 2,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Services",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatInformation(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 1 / 2,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Important Information",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    //row2
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatCards(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 1 / 2,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Cards",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatQuality(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 1 / 2,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Quality",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatNews(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 1 / 2,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Latest News",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
