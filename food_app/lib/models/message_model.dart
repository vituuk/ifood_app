class MessageModel {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String type;
  final bool isUser;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isUser,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'chat',
      isUser: json['is_user'] is bool
          ? json['is_user']
          : json['is_user'] == 1,
      isRead: json['is_read'] is bool
          ? json['is_read']
          : json['is_read'] == 1,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'is_user': isUser,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
