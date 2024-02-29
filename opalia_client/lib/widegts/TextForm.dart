import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final String labelText;

  const TextForm({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
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
