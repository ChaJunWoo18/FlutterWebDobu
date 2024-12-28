class IncomeModel {
  final int curIncome;
  final int preIncome;
  final int twoMonthAgoIncome;

  IncomeModel({
    required this.curIncome,
    required this.preIncome,
    required this.twoMonthAgoIncome,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      curIncome: json['cur_income'],
      preIncome: json['pre_income'],
      twoMonthAgoIncome: json['two_month_ago_income'],
    );
  }
}
