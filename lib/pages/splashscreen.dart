import 'dart:async';

import 'package:apersi/pages/home_page.dart';
import 'package:apersi/widgets/texts.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return const HomePage();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            'assets/images/background-horizontal.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/jasa-raharja-full-logo.png',
                  fit: BoxFit.contain,
                  height: 120,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Apersi',
                  style: TextStyle(
                    fontFamily: 'BaskervvilleSC',
                    fontSize: 48,
                  ),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 8),
                const Text(
                  'Aplikasi Perhitungan Mutasi',
                  style: TextStyle(
                    fontFamily: 'BaskervvilleSC',
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                secondaryText(
                  text: 'Oleh Hotsarido Sinaga',
                  alignment: TextAlign.center,
                ),
                secondaryText(
                  text: '© Jasa Raharja Pematangsiantar',
                  alignment: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
