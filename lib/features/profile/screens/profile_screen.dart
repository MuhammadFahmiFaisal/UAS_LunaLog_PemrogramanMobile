import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Ini adalah Halaman Profil'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logout navigasi kembali ke login
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
