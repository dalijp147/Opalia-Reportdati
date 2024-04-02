import 'package:flutter/material.dart';
import 'constant.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.focusNode,
    required this.textController,
    required this.label,
    required this.icons,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textController;
  final String label;
  final Icon icons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        obscureText: label == "Password" ? true : false,
        controller: textController,
        autofocus: false,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(focusNode);
        },
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
                borderRadius: kBorderRadius),
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.transparent,
            hintText: label,
            prefixIcon: icons),
      ),
    );
  }
}
