import 'package:apersi/utils/colors.dart';
import 'package:flutter/material.dart';

import 'pages/input_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: lightBlueColor),
        useMaterial3: true,
      ),
      home: const InputPage(),
    );
  }
}
