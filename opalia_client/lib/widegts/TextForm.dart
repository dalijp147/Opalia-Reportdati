import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final String labelText;
  final TextEditingController textcontroller;
  const TextForm(
      {super.key, required this.labelText, required this.textcontroller});

  @override
  Widget build(BuildContext context) {
    bool isNotValide = false;
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: textcontroller,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          // ignore: dead_code
          errorText: isNotValide ? "Enter Proper Info" : null,
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red,
              width: 3,
            ),
          ),
        ),
      ),
    );
  }
}
