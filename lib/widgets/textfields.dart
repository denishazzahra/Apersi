import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'texts.dart';

List<Widget> textFieldWithSeparatedLabel(
    {required TextEditingController controller,
    required String placeholder,
    bool isObscure = false,
    bool isReadOnly = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool numOnly = false,
    Function? onTap}) {
  return [
    label(placeholder),
    const SizedBox(height: 8),
    TextField(
      obscureText: isObscure,
      readOnly: isReadOnly,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      controller: controller,
      keyboardType: numOnly ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: whiteColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: lightGreyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: lightGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: lightGreyColor, width: 1.5),
        ),
      ),
    )
  ];
}
