import 'package:flutter/material.dart';

class HistoryControlBtn extends StatelessWidget {
  final String label;
  final VoidCallback method;

  const HistoryControlBtn({
    super.key,
    required this.label,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: method,
      style: ButtonStyle(
          backgroundColor:
              const WidgetStatePropertyAll<Color>(Color(0xffFFEECC)),
          //minimumSize: const WidgetStatePropertyAll<Size>(Size(20, 6)),
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 45,
            ),
          ),
          side: const WidgetStatePropertyAll<BorderSide>(BorderSide.none),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 테두리 둥근 정도 조절
            ),
          )),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
