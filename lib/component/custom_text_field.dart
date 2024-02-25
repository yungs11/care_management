import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  const CustomTextField({super.key, required this.labelText, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(flex : 2, child: Text(labelText, style: TextStyle(fontWeight: FontWeight.w700),)),
          Expanded(
            flex : 3,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
