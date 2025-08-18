import 'package:booking_restaurant_app/features/home/data/models/restaurant_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getAllRestaurants();
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final FirebaseFirestore firestore;

  RestaurantRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<RestaurantModel>> getAllRestaurants() async {
    try {
      final snapshot = await firestore
          .collection('restaurants')
          .get(); 
      return snapshot.docs
          .map((doc) => RestaurantModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error fetching restaurants: $e");
    }
  }
}
