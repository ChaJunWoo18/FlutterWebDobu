import 'package:flutter/material.dart';
import 'package:prob/widgets/line_widget.dart';

class TotalCard extends StatelessWidget {
  const TotalCard({super.key, this.budget, this.total, this.remainedBudget});
  final budget;
  final total;
  final remainedBudget;

  // void fetchData() {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '이번 달 소비는',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.settings_suggest_rounded,
                    size: 26,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                //월간 총 소비량
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll<Color>(Colors.amber),
                        minimumSize:
                            const WidgetStatePropertyAll<Size>(Size(20, 6)),
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                        ),
                        side: const WidgetStatePropertyAll<BorderSide>(
                            BorderSide.none),
                        shape: WidgetStatePropertyAll<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // 테두리 둥근 정도 조절
                          ),
                        )),
                    child: const Text(
                      '숨기기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    "$total 원",
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700),
                  )
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              const LineWidget(),
              const SizedBox(
                height: 6,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '이번 달 예산 : ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '$budget 원',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '남은 예산 : ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '$remainedBudget 원',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              //detailGoButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class detailGoButton extends StatelessWidget {
  const detailGoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shadowColor: const Color.fromARGB(255, 231, 144, 173),
            minimumSize: const Size(100, 45),
            elevation: 7,
          ),
          onPressed: () => Navigator.pushNamed(context, '/history'),
          child: const Row(
            children: [
              Text(
                "상세 내역 ",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Icon(
                Icons.forward_rounded,
                color: Colors.white,
              )
            ],
          ),
        )
      ],
    );
  }
}
