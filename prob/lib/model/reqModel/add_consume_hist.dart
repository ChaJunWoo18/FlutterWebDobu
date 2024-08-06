class AddConsumeHist {
  final String receiver;
  final String date;
  final String amount;
  final String categoryName;

  AddConsumeHist({
    required this.receiver,
    required this.date,
    required this.amount,
    required this.categoryName,
  });

  Map<String, dynamic> toJson() => {
        'receiver': receiver,
        'date': date,
        'amount': amount,
        'category_name': categoryName,
      };
}
