import 'package:booking_restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:booking_restaurant_app/features/navigation/presentation/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBottomSheet extends StatefulWidget {
  const AuthBottomSheet({super.key, required bool initialLogin});

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _signupName = TextEditingController();
  final _signupEmail = TextEditingController();
  final _signupPass = TextEditingController();

  final _loginEmail = TextEditingController();
  final _loginPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signupName.dispose();
    _signupEmail.dispose();
    _signupPass.dispose();
    _loginEmail.dispose();
    _loginPass.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Container(
      height: media.size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(height: 15),
            TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.green,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'Create Account'),
                Tab(text: 'Login'),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  state.maybeWhen(
                    authenticated: (user) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Xush kelibsiz, ${user.displayName ?? user.email}!',
                          ),
                        ),
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => NavigationScreen()),
                      );
                    },
                    failure: (msg) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(msg)));
                    },
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  final isLoading = state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'Full Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _signupName,
                              decoration: _dec('Enter your full name'),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Email address',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _signupEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _dec('Eg name@email.com'),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _signupPass,
                              obscureText: true,
                              decoration: _dec('•••• •••• ••••'),
                            ),
                            SizedBox(height: 50),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      final name = _signupName.text.trim();
                                      final email = _signupEmail.text.trim();
                                      final pass = _signupPass.text.trim();

                                      if (name.isEmpty ||
                                          email.isEmpty ||
                                          pass.length < 6) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Maydonlarni to‘g‘ri to‘ldiring (parol ≥ 6)!',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      context.read<AuthBloc>().add(
                                        AuthEvent.signUp(
                                          name: name,
                                          email: email,
                                          password: pass,
                                        ),
                                      );
                                    },
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isLoading
                                      ? Colors.grey
                                      : Color(0xFF32B768),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'Registration',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('or'),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              // ignore: sort_child_properties_last
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google.png',
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      'Sign up with Google',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: isLoading
                                  ? null
                                  : () {
                                      context.read<AuthBloc>().add(
                                        const AuthEvent.googleSignIn(),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'Email address',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _loginEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _dec('Eg name@email.com'),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _loginPass,
                              obscureText: true,
                              decoration: _dec('•••• •••• ••••'),
                            ),
                            SizedBox(height: 80),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      final email = _loginEmail.text.trim();
                                      final pass = _loginPass.text.trim();
                                      if (email.isEmpty || pass.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Email va parolni kiriting!',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      context.read<AuthBloc>().add(
                                        AuthEvent.signIn(
                                          email: email,
                                          password: pass,
                                        ),
                                      );
                                    },
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isLoading
                                      ? Colors.grey
                                      : Color(0xFF32B768),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text('or'),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              // ignore: sort_child_properties_last
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google.png',
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      'Sign up with Google',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: isLoading
                                  ? null
                                  : () {
                                      context.read<AuthBloc>().add(
                                        const AuthEvent.googleSignIn(),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
