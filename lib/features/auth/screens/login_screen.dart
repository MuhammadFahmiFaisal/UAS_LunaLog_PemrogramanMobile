import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Halaman Auth Statis'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman utama (Dashboard)
                Navigator.pushReplacementNamed(context, AppRoutes.main);
              },
              child: const Text('Masuk ke Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
