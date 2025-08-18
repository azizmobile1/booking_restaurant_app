import 'package:booking_restaurant_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:booking_restaurant_app/features/auth/data/source/firebase_auth_datasource.dart';
import 'package:booking_restaurant_app/features/auth/domain/repository/auth_repository.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:booking_restaurant_app/features/home/data/repository/restaurant_repository_impl.dart';
import 'package:booking_restaurant_app/features/home/data/source/restaurant_remote_datasource.dart';
import 'package:booking_restaurant_app/features/home/domain/repository/restaurant_repository.dart';
import 'package:booking_restaurant_app/features/home/domain/usecases/get_restaurants.dart';
import 'package:booking_restaurant_app/features/home/presentation/bloc/restaurant_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl()),
  );
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));

  sl.registerLazySingleton<RestaurantRemoteDataSource>(
    () => RestaurantRemoteDataSourceImpl(sl()), 
  );
  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetRestaurants(sl()));
  sl.registerFactory(() => RestaurantBloc(sl()));
}
