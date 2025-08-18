import 'package:booking_restaurant_app/features/home/domain/entities/restaurant_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // GeoPoint uchun import

import 'menu_model.dart';

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.openTime,
    required super.closeTime,
    required super.lat,
    required super.lng,
    required super.menu,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> map, String id) {
    final location = map['location'];
    double lat = 0.0;
    double lng = 0.0;

    if (location is GeoPoint) {
      lat = location.latitude;
      lng = location.longitude;
    } else if (location is Map<String, dynamic>) {
      // Agar location obyekt sifatida kelgan bo'lsa
      lat = (location['lat']?.toDouble() ?? 0.0);
      lng = (location['long']?.toDouble() ?? 0.0);
    }

    return RestaurantModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      openTime: map['openTime'] ?? '',
      closeTime: map['closeTime'] ?? '',
      lat: lat,
      lng: lng,
      menu: map['menu'] != null
          ? List<MenuModel>.from(map['menu'].map((x) => MenuModel.fromMap(x)))
          : [],
    );
  }
}
