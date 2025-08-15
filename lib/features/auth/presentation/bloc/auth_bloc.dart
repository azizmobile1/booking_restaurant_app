import 'package:booking_restaurant_app/features/auth/domain/entity/user_entity.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  AuthBloc({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.googleSignInUseCase,
  }) : super(const AuthState.initial()) {
    on<_SignUp>((event, emit) async {
      emit(const AuthState.loading());
      final res = await signUpUseCase(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      res.fold(
        (l) => emit(AuthState.failure(l.message)),
        (r) => emit(AuthState.authenticated(r)),
      );
    });

    on<_SignIn>((event, emit) async {
      emit(const AuthState.loading());
      final res = await signInUseCase(
        email: event.email,
        password: event.password,
      );
      res.fold(
        (l) => emit(AuthState.failure(l.message)),
        (r) => emit(AuthState.authenticated(r)),
      );
    });

    on<_GoogleSignIn>((event, emit) async {
      emit(const AuthState.loading());
      final res = await googleSignInUseCase();
      res.fold(
        (l) => emit(AuthState.failure(l.message)),
        (r) => emit(AuthState.authenticated(r)),
      );
    });

    on<_Reset>((event, emit) => emit(const AuthState.initial()));
  }
}
