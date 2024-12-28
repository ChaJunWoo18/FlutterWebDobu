class HistModel {
  final int id;
  final String receiver;
  final String date;
  final int amount;
  final int installment;
  final int fixedId;
  final String? card;
  final int subId;
  final String icon;
  final String categoryName;
  final String color;
  final bool chart;
  final bool visible;

  HistModel({
    required this.id,
    required this.receiver,
    required this.date,
    required this.amount,
    required this.fixedId,
    required this.installment,
    this.card,
    required this.subId,
    required this.icon,
    required this.categoryName,
    required this.color,
    required this.chart,
    required this.visible,
  });

  // JSON을 HistModel로 변환하는 생성자
  factory HistModel.fromJson(Map<String, dynamic> json) {
    return HistModel(
      id: json['id'],
      receiver: json['receiver'],
      date: json['date'],
      amount: json['amount'],
      fixedId: json['fixed_id'] ?? -1,
      installment: json['installment'],
      card: json['card'],
      subId: json['sub_id'],
      icon: json['icon'],
      categoryName: json['name'],
      color: json['color'],
      chart: json['chart'],
      visible: json['visible'],
    );
  }
}
