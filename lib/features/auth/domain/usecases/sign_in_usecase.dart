import 'package:booking_restaurant_app/core/app/errors/failures.dart';
import 'package:booking_restaurant_app/features/auth/domain/entity/user_entity.dart';
import 'package:booking_restaurant_app/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignInUseCase {
  final AuthRepository repo;
  SignInUseCase(this.repo);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) => repo.signIn(email: email, password: password);
}
