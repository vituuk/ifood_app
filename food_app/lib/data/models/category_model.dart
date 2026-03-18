import '../../config/api_config.dart';

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final int? foodsCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.foodsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    String? img = json['image']?.toString();
    String? parsedIcon;
    if (img != null && img.isNotEmpty) {
      if (img.startsWith('http')) {
        parsedIcon = ApiConfig.resolveImageUrl(img);
      } else {
        parsedIcon = '${ApiConfig.storageUrl}/$img';
      }
    }

    return CategoryModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      icon: parsedIcon ?? json['icon'],
      foodsCount: json['foods_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
    };
  }
}
