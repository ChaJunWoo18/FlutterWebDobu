import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SignButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // 가로 길이를 최대화
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
