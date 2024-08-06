class HistModel {
  final int id;
  final String categoryName;
  final int amount;
  final String receiver;
  final DateTime date;

  HistModel({
    required this.id,
    required this.categoryName,
    required this.amount,
    required this.receiver,
    required this.date,
  });

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'id': id,
        'category_name': categoryName,
        'amount': amount,
        'receiver': receiver,
        'date': date,
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory HistModel.fromJson(Map<String, dynamic> json) => HistModel(
        id: json['id'],
        categoryName: json['category_name'],
        amount: json['amount'],
        receiver: json['receiver'],
        date: json['date'],
      );
}
