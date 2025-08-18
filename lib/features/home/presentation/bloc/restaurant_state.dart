import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant_entity.dart';

abstract class RestaurantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<RestaurantEntity> restaurants;

  RestaurantLoaded(this.restaurants);

  @override
  List<Object?> get props => [restaurants];
}

class RestaurantError extends RestaurantState {
  final String message;

  RestaurantError(this.message);

  @override
  List<Object?> get props => [message];
}
