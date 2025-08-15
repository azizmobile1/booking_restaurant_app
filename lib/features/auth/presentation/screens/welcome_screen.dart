import 'package:booking_restaurant_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:booking_restaurant_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:booking_restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:booking_restaurant_app/features/auth/presentation/injection_container.dart';
import 'package:booking_restaurant_app/features/auth/presentation/widgets/auth_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openAuthSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return BlocProvider(
          create: (_) => AuthBloc(
            signUpUseCase: sl<SignUpUseCase>(),
            signInUseCase: sl<SignInUseCase>(),
            googleSignInUseCase: sl<GoogleSignInUseCase>(),
          ),
          child: AuthBottomSheet(initialLogin: true),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: SvgPicture.asset("assets/svgs/welcome.svg")),
            SizedBox(height: 40),
            Text(
              "Welcome",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Before enjoying Foodmedia services Please register first",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5563),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 100),
            InkWell(
              onTap: () => _openAuthSheet(context),
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Color(0xFF32B768),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => _openAuthSheet(context),
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10B981),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "By logging in or registering, you have agreed to the Terms and Conditions and Privacy Policy.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
