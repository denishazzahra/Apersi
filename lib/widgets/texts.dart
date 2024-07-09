import 'package:apersi/utils/colors.dart';
import 'package:flutter/material.dart';

Text label(String placeholder) {
  return Text(
    placeholder,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}

Text secondaryLabel(String placeholder) {
  return Text(
    placeholder,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: darkGreyColor,
    ),
  );
}

Widget itemTotal(String placeholder, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        placeholder,
        style: TextStyle(fontSize: 16, color: darkGreyColor),
      ),
      Text(
        value,
        style: TextStyle(fontSize: 16, color: darkGreyColor),
      ),
      // secondaryLabel(value),
    ],
  );
}

Widget wholeTotal(String placeholder, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        placeholder,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    ],
  );
}
