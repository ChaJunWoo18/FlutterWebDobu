import 'package:flutter/material.dart';
import 'package:prob/widgets/history_card.dart';
import 'package:prob/widgets/history_details.dart';
import 'package:prob/widgets/home_header.dart';
import 'package:prob/widgets/add_modal.dart';

class ConsumptionHistory extends StatelessWidget {
  const ConsumptionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(
              height: 18,
            ),
            Container(
              decoration: const BoxDecoration(),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: HistoryCard(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AddModal(),

                        // HistoryControlBtn(
                        //   label: "????",
                        //   method: () {},
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  HistoryDetails()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
