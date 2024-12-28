class SavingModel {
  final int id;
  final DateTime date;
  final String receiver;
  final int amount;

  SavingModel({
    required this.id,
    required this.date,
    required this.receiver,
    required this.amount,
  });

  factory SavingModel.fromJson(Map<String, dynamic> json) => SavingModel(
        id: json['id'],
        date: DateTime.parse(json['date']),
        receiver: json['receiver'],
        amount: json['amount'] as int,
      );

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'receiver': receiver,
      'amount': amount,
    };
  }
}

class GroupedSavings {
  final String month;
  final List<SavingModel> savings;

  GroupedSavings({required this.month, required this.savings});

  factory GroupedSavings.fromJson(String month, List<dynamic>? jsonList) {
    List<SavingModel> savings = jsonList == null || jsonList.isEmpty
        ? []
        : jsonList.map((data) => SavingModel.fromJson(data)).toList();

    return GroupedSavings(
      month: month,
      savings: savings,
    );
  }
}
