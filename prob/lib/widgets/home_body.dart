import 'package:flutter/material.dart';
import 'package:prob/widgets/bar_widget.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key, this.user});
  final Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user?['nickname'] ?? 'Guest'}의 소비 TOP4",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 40,
            ),
            const AspectRatio(
              aspectRatio: 1.3,
              child: BarWidget(),
            )
          ],
        ),
      ),
    );
  }
}
