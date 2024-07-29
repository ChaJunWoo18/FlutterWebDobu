import 'package:flutter/material.dart';
import 'package:prob/provider/look_list_provider.dart';
import 'package:provider/provider.dart';

class HistDetailOptionLeft extends StatelessWidget {
  const HistDetailOptionLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          "3개월 ",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "•",
          style: TextStyle(fontSize: 25),
        ),
        Text(
          " 전체 ",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "•",
          style: TextStyle(fontSize: 25),
        ),
        Text(
          " 최신순 ",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.keyboard_arrow_down_rounded),
      ],
    );
  }
}

class HistDetailOptionRight extends StatelessWidget {
  const HistDetailOptionRight({super.key});

  @override
  Widget build(BuildContext context) {
    final lookListProvider = Provider.of<LookListProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: lookListProvider.showListView
              ? const Icon(Icons.calendar_today_rounded)
              : const Icon(Icons.list_outlined),
          onPressed: () {
            lookListProvider.toggleView();
          },
        )
      ],
    );
  }
}
