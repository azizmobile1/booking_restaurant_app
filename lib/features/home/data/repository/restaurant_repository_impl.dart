import 'package:booking_restaurant_app/features/home/data/source/restaurant_remote_datasource.dart';
import 'package:booking_restaurant_app/features/home/domain/entities/restaurant_entity.dart';
import 'package:booking_restaurant_app/features/home/domain/repository/restaurant_repository.dart';


class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RestaurantEntity>> getAllRestaurants() {
    return remoteDataSource.getAllRestaurants();
  }
}
