import 'package:flutter/material.dart';
import 'package:house_matching/post_files/post_list/post_list_page.dart';
import 'package:house_matching/time_line_files/time_line/time_line_page.dart';

import 'account/account_page.dart';
import 'favorite_list/favorite_page.dart';

class MainSelectPage extends StatefulWidget {
  const MainSelectPage({Key? key}) : super(key: key);

  @override
  State<MainSelectPage> createState() => _MainSelectPageState();
}

class _MainSelectPageState extends State<MainSelectPage> {
  int selectedIndex = 0;
  List<Widget> pageList = [
    const TimeLinePage(),
    const PostListPage(),
    const FavoritePage(),
    const AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: '注目の物件'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: '物件を投稿'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'お気に入り'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
        ],
      ),
    );
  }
}
