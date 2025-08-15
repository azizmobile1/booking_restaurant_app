import 'package:booking_restaurant_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:booking_restaurant_app/features/auth/data/source/firebase_auth_datasource.dart';
import 'package:booking_restaurant_app/features/auth/domain/repository/auth_repository.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remote: sl()));

  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
}
