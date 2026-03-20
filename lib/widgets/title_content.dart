import 'package:flutter/material.dart';

class TitleContent extends StatelessWidget {
  const TitleContent({super.key, required this.title, required this.content});
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        content,
      ],
    );
  }
}
