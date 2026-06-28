import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';
import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/user.dart';
import 'package:poliklinik/widgets/dashboard/dashboard_page.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:poliklinik/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  String selectedGender = 'Laki-laki';
  String selectedRole = 'pasien';
  bool isTermsAccepted = false;

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Terms, Agreement & Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: const SingleChildScrollView(
            child: Text(
              'Dengan mendaftar, Anda menyetujui persyaratan dan kebijakan privasi kami yang mengacu pada standar regulasi berikut:\n\n'
              '• UU ITE (Informasi dan Transaksi Elektronik)\n'
              '• UU PDP (Pelindungan Data Pribadi)\n'
              '• UU Permenkes 2025\n'
              '• OECD (Organisation for Economic Co-operation and Development)\n'
              '• HIPAA (Health Insurance Portability and Accountability Act)\n'
              '• WHO (World Health Organization)\n'
              '• Health Organization International\n\n'
              'Data rekam medis dan informasi pribadi Anda akan dienkripsi dan dikelola secara aman.',
              style: TextStyle(height: 1.5, fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Register Akun Live"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Buat Akun Baru',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.heading2
                        .copyWith(color: AppColors.primary, fontSize: 24)),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: nameController, label: "Nama Lengkap"),
                const SizedBox(height: 12),
                CustomTextField(
                    controller: emailController, label: "Email (Login)"),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: passwordController,
                    label: "Password",
                    obscureText: true),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: phoneController, label: "Nomor Telepon"),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedGender,
                  decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  items: ['Laki-laki', 'Perempuan'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: const TextStyle(fontSize: 14)));
                  }).toList(),
                  onChanged: (newValue) =>
                      setState(() => selectedGender = newValue!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedRole,
                  decoration: const InputDecoration(
                      labelText: 'Pilih Role Akses',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  items: ['pasien', 'admin loket', 'dokter', 'farmasi']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase(),
                            style: const TextStyle(fontSize: 14)));
                  }).toList(),
                  onChanged: (newValue) =>
                      setState(() => selectedRole = newValue!),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isTermsAccepted,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          isTermsAccepted = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showTermsDialog(context),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                height: 1.4),
                            children: const [
                              TextSpan(text: 'Saya setuju dengan '),
                              TextSpan(
                                text: 'Terms & Agreement serta Policy Privacy',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (!isTermsAccepted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Anda harus menyetujui Terms & Agreement serta Policy Privacy')));
                              return;
                            }
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Nama, Email, dan Password wajib diisi')));
                              return;
                            }
                            final newUser = User(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              role: selectedRole,
                              phone: phoneController.text,
                              gender: selectedGender,
                            );

                            final result = await auth.register(newUser.toJson());
                            if (!context.mounted) return;

                            if (result) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DashboardPage()),
                                (route) => false,
                              );
                            } else if (auth.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(auth.error!)));
                            }
                          },
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text("DAFTAR & OTOMATIS LOGIN",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
