import 'package:flutter/material.dart';
import 'package:prob/widgets/bar_widget.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "소비 TOP4",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 40,
            ),
            AspectRatio(
              aspectRatio: 1.3,
              child: BarWidget(),
            )
          ],
        ),
      ),
    );
  }
}
