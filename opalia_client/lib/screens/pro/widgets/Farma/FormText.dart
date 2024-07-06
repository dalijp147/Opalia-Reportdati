import 'package:flutter/material.dart';

import '../../../client/widgets/Allappwidgets/constant.dart';

class FormText extends StatelessWidget {
  final TextEditingController nameController;
  final String hintText;
  const FormText(
      {super.key, required this.nameController, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "veullez saisire ${hintText} ";
            } else {
              return null;
            }
          },
          controller: nameController,
          autofocus: false,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: kBorderRadius),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: kBorderRadius,
            ),
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            filled: true,
            hintText: hintText,
            fillColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
