import 'package:flutter/material.dart';

class CustomAlert {
  static void show(BuildContext context, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('알림', style: TextStyle(color: color)),
          content: Text(message, style: TextStyle(color: color)),
          actions: <Widget>[
            TextButton(
              child: Text('확인', style: TextStyle(color: color)),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  static void showTwo(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('알림', style: TextStyle(color: color)),
          content: Text(message, style: const TextStyle()),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: const Text('확인', style: TextStyle()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('취소', style: TextStyle()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
