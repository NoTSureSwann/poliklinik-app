import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/widgets/dashboard/dashboard_page.dart';
import 'package:poliklinik/widgets/auth/register_page.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';

import 'package:poliklinik/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(
      context,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'CareHub',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.heading1.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan masuk ke akun Anda',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.body1.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: emailController,
                  label: "Email",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  label: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Email dan Password tidak boleh kosong')),
                              );
                              return;
                            }

                            final result = await auth.login(
                              emailController.text,
                              passwordController.text,
                            );

                            if (!mounted) return;

                            if (result) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DashboardPage(),
                                ),
                              );
                            } else if (auth.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(auth.error!)),
                              );
                            }
                          },
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text("LOGIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterPage()),
                    );
                  },
                  child: const Text('Belum punya akun? Buat Akun Dummy di sini'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
