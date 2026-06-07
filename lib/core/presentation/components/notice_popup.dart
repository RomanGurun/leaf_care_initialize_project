import 'package:flutter/material.dart';

class NoticePopup extends StatelessWidget {
  final String message;

  const NoticePopup({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('सूचना', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ठिक छ'), // "OK" in Nepali
        ),
      ],
    );
  }
}
