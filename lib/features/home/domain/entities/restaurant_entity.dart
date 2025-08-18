import 'package:equatable/equatable.dart';

import 'menu_entity.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String openTime;
  final String closeTime;
  final double lat;
  final double lng;
  final List<MenuEntity> menu;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.openTime,
    required this.closeTime,
    required this.lat,
    required this.lng,
    required this.menu,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, openTime, closeTime, lat, lng, menu];
}
