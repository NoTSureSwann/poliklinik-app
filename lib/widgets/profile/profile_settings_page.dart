import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';
import 'package:poliklinik/models/user.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/theme/app_text_style.dart';
import 'package:poliklinik/widgets/custom_textfield.dart';
import 'package:poliklinik/core/architecture/event_bus.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedGender = 'Laki-laki';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phone;
      selectedGender = user.gender.isNotEmpty ? user.gender : 'Laki-laki';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Center(child: Text("Sesi telah habis, silakan login kembali."));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pengaturan Profil',
                style: AppTextStyle.heading2.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              CustomTextField(controller: nameController, label: "Nama Lengkap"),
              const SizedBox(height: 16),
              CustomTextField(
                controller: TextEditingController(text: user.email),
                label: "Email (Tidak bisa diubah)",
                enabled: false,
              ),
              const SizedBox(height: 16),
              CustomTextField(controller: phoneController, label: "Nomor Telepon"),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedGender,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin', border: OutlineInputBorder()),
                items: ['Laki-laki', 'Perempuan'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) => setState(() => selectedGender = newValue!),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                label: "Password Baru (Kosongkan jika tidak diubah)",
                obscureText: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () {
                    final updatedUser = User(
                      id: user.id,
                      name: nameController.text.isNotEmpty ? nameController.text : user.name,
                      email: user.email,
                      password: passwordController.text.isNotEmpty ? passwordController.text : user.password,
                      role: user.role,
                      phone: phoneController.text,
                      gender: selectedGender,
                    );

                    context.read<AuthProvider>().updateProfile(updatedUser);
                    eventBus.publish(AppEvent('ProfileUpdated', updatedUser.name));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green),
                    );
                  },
                  child: const Text("SIMPAN PERUBAHAN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
