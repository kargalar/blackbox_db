import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/3%20Page/appbar_manager.dart';
import 'package:blackbox_db/5%20Service/server_manager.dart';
import 'package:blackbox_db/6%20Provider/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isRegister ? "Register" : 'Login',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (isRegister) ...[
                    TextFormField(
                      style: const TextStyle(color: AppColors.white),
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: const TextStyle(color: AppColors.grey),
                        filled: true,
                        fillColor: AppColors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: _usernameValidator,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    style: const TextStyle(color: AppColors.white),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      hintStyle: const TextStyle(color: AppColors.grey),
                      filled: true,
                      fillColor: AppColors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    keyboardType: null,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: AppColors.grey),
                      filled: true,
                      fillColor: AppColors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(
                        Icons.visibility_off,
                        color: AppColors.grey,
                      ),
                    ),
                    validator: _passwordValidator,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      if (isRegister) {
                        loginUser = await ServerManager().register(
                          username: _usernameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      } else {
                        loginUser = await ServerManager().login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      }

                      if (loginUser != null) {
                        // SharedPreferences
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('email', _emailController.text);
                        prefs.setString('password', _passwordController.text);

                        GeneralProvider().currentIndex = 1;

                        await Get.offUntil(
                          GetPageRoute(
                            page: () => const AppbarManager(),
                            routeName: "/",
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      !isRegister ? 'Login' : "Register",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          isRegister = !isRegister;

                          setState(() {});
                        },
                        child: Text(
                          isRegister ? "Login" : 'Register',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen kullanıcı adınızı girin';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen e-posta adresinizi girin';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi girin';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }
}
