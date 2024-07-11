import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../utils/colors.dart';

AppBar appBar() {
  return AppBar(
    elevation: 2,
    surfaceTintColor: whiteColor,
    backgroundColor: whiteColor,
    shadowColor: blackColor,
    title: Row(
      children: [
        Image.asset(
          'assets/images/jasa-raharja-logo.png',
          height: 36,
        ),
        const SizedBox(width: 8),
        const Text(
          'Apersi',
          style: TextStyle(fontFamily: 'Bebas Neue', fontSize: 24),
        ),
      ],
    ),
    centerTitle: true,
  );
}

Widget bottomNavbar(int currentPageIndex, Function changePage) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.grey.shade600,
          blurRadius: 2,
        ),
      ],
    ),
    child: NavigationBar(
      backgroundColor: whiteColor,
      surfaceTintColor: whiteColor,
      onDestinationSelected: (int index) {
        changePage(index);
      },
      indicatorColor: lightBlueColor,
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            Symbols.edit_document,
            color: whiteColor,
            fill: 1,
          ),
          icon: const Icon(
            Symbols.edit_document,
            fill: 0,
          ),
          label: 'Input Data',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Symbols.history,
            color: whiteColor,
            fill: 1,
            weight: 600,
          ),
          icon: const Icon(
            Icons.history,
            fill: 0,
          ),
          label: 'Riwayat',
        ),
      ],
    ),
  );
}
