// import 'package:booking_restaurant_app/features/home/data/repository/restaurant_repository_impl.dart';
// import 'package:booking_restaurant_app/features/home/data/source/restaurant_remote_datasource.dart';
// import 'package:booking_restaurant_app/features/home/domain/repository/restaurant_repository.dart';
// import 'package:booking_restaurant_app/features/home/domain/usecases/get_restaurants.dart';
// import 'package:booking_restaurant_app/features/home/presentation/bloc/restaurant_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_it/get_it.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   // DataSource
//   sl.registerLazySingleton<RestaurantRemoteDataSource>(
//     () => RestaurantRemoteDataSourceImpl(FirebaseFirestore.instance),
//   );

//   // Repository
//   sl.registerLazySingleton<RestaurantRepository>(
//     () => RestaurantRepositoryImpl(sl()),
//   );

//   // UseCase
//   sl.registerLazySingleton(() => GetRestaurants(sl()));

//   // Bloc
//   sl.registerFactory(() => RestaurantBloc(sl()));
// }
