class UserModel {
  final int id;
  final String username;

  UserModel({required this.id, required this.username});

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        username: json['username'],
      );
}
