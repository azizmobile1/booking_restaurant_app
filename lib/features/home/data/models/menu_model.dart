import 'package:booking_restaurant_app/features/home/domain/entities/menu_entity.dart';

class MenuModel extends MenuEntity {
  const MenuModel({
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.price,
  });

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }
}
