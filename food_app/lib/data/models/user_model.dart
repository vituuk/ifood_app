import '../../config/api_config.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String role;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.role = 'user',
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? img = json['avatar']?.toString();
    String? parsedAvatar;
    if (img != null && img.isNotEmpty) {
      if (img.startsWith('http')) {
        parsedAvatar = ApiConfig.resolveImageUrl(img);
      } else {
        // Remove leading /storage or storage/ if it exists, since ApiConfig.storageUrl already has it
        if (img.startsWith('/storage/')) {
          img = img.replaceFirst('/storage/', '');
        } else if (img.startsWith('storage/')) {
          img = img.replaceFirst('storage/', '');
        }
        
        // Also remove leading slash just in case
        if (img.startsWith('/')) {
          img = img.substring(1);
        }
        
        parsedAvatar = '${ApiConfig.storageUrl}/$img';
      }
    }

    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: parsedAvatar,
      role: json['role'] ?? 'user',
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'role': role,
      'status': status,
    };
  }
}
