import 'package:apersi/widgets/appbar.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'history_page.dart';
import 'input_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      bottomNavigationBar: bottomNavbar(currentPageIndex, changePage),
      backgroundColor: whiteColor,
      body: currentPageIndex == 0 ? const InputPage() : const HistoryPage(),
    );
  }

  void changePage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }
}
