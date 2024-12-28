class FixedModel {
  final String receiver;
  final String startDate;
  final String card;
  final String categoryName;
  final int id;
  final int amount;

  FixedModel({
    required this.receiver,
    required this.startDate,
    required this.card,
    required this.categoryName,
    required this.id,
    required this.amount,
  });

  // JSON으로부터 객체를 생성하는 factory method
  factory FixedModel.fromJson(Map<String, dynamic> json) {
    return FixedModel(
      receiver: json['receiver'],
      startDate: json['start_date'],
      card: json['card'] ?? '', // null일 경우 빈 문자열로 설정
      categoryName: json['category_name'],
      id: json['id'],
      amount: json['amount'],
    );
  }
}
