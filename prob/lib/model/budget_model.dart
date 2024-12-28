class BudgetModel {
  final int userId;
  int curBudget;
  final int preBudget;

  BudgetModel({
    required this.userId,
    required this.curBudget,
    required this.preBudget,
  });

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'cur_budget': curBudget,
        'pre_budget': preBudget,
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        userId: json['user_id'],
        curBudget: json['cur_budget'],
        preBudget: json['pre_budget'],
      );
}
