/// 用户模型
class UserModel {
  final String id;
  final String username;
  final String? nickname;
  final String? avatar;
  final String? phone;
  final String? email;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.username,
    this.nickname,
    this.avatar,
    this.phone,
    this.email,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      nickname: json['nickname'],
      avatar: json['avatar'],
      phone: json['phone'],
      email: json['email'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nickname': nickname,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
