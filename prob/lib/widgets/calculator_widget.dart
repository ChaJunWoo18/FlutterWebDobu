import 'package:flutter/material.dart';
import 'package:prob/api/get_total_consume.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/period_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:provider/provider.dart';

class CalculatorWidget extends StatelessWidget {
  const CalculatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final periodProvider =
            Provider.of<Periodprovider>(context, listen: false);
        // final totalProvider =
        //     Provider.of<TotalProvider>(context, listen: false);
        final token = context.read<AuthProvider>().token;
        final startDate = periodProvider.startDate;
        final endDate = periodProvider.endDate;

        // 기존 데이터가 없는 경우 API 요청

        int periodTotal =
            await GetTotalConsume.readPreiodTotal(startDate, endDate, token);

        // totalProvider.setPreiodTotal(periodTotal);

        // UI가 안전하게 빌드될 수 있는지 확인 후 모달 열기
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return TotalConsumptionModal(
                startDate: startDate,
                endDate: endDate,
                total: periodTotal,
              );
            },
          );
        }
      },
      child: const Text('소비 계산기'),
    );
  }
}

class TotalConsumptionModal extends StatelessWidget {
  final String startDate;
  final String endDate;
  final int total;

  const TotalConsumptionModal({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '총 소비 확인',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Text('$startDate부터 $endDate까지'),
          const SizedBox(height: 16.0),
          Text(
            '총 소비: $total원',
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
}
