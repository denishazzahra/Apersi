import 'package:apersi/utils/colors.dart';
import 'package:flutter/material.dart';

Text boldDefault({required String text, TextAlign alignment = TextAlign.left}) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
    ),
    textAlign: alignment,
  );
}

Text label(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}

Text secondaryLabel(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: darkGreyColor,
    ),
  );
}

Text secondaryText(
    {required String text, TextAlign alignment = TextAlign.left}) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: 14,
      color: darkGreyColor,
    ),
  );
}

Text smallSecondaryText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 12,
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
