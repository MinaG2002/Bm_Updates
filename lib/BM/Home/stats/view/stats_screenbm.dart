import 'package:bmproject/BM/Home/stats/widget/stats_widgetbm.dart';
import 'package:flutter/material.dart';

class StatesScreenBm extends StatefulWidget {
  const StatesScreenBm({super.key});

  @override
  State<StatesScreenBm> createState() => _StatesScreenBmState();
}

class _StatesScreenBmState extends State<StatesScreenBm> {
  final List people = [
    {
      'url':
          'https://tse4.mm.bing.net/th?id=OIP.VhVv258VYiNu63zTgENpZAHaDD&pid=Api&P=0&h=220',
      'age': "Rank 1",
    },
    {
      'url':
          'https://tse4.mm.bing.net/th?id=OIP.VhVv258VYiNu63zTgENpZAHaDD&pid=Api&P=0&h=220',
      'age': "Rank 2",
    },
    {
      'url':
          'https://tse4.mm.bing.net/th?id=OIP.VhVv258VYiNu63zTgENpZAHaDD&pid=Api&P=0&h=220',
      'age': "Rank 3",
    },
    {
      'url':
          'https://tse4.mm.bing.net/th?id=OIP.VhVv258VYiNu63zTgENpZAHaDD&pid=Api&P=0&h=220',
      'age': "Rank 4",
    },
    {
      'url':
          'https://tse4.mm.bing.net/th?id=OIP.VhVv258VYiNu63zTgENpZAHaDD&pid=Api&P=0&h=220',
      'age': "Rank 5",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: people.length,
      itemBuilder: (context, index) {
        return StatesWidgetBm(
          imgeurl: "${people[index]["url"]}",
          titel: "${people[index]["age"]}",
        );
      },
    );
  }
}
