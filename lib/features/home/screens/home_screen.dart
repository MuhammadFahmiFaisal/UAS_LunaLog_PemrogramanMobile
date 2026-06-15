import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(
        child: Text('Ini adalah Halaman Home / Dashboard\n(Ringkasan siklus & Haid Terakhir)', textAlign: TextAlign.center,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigasi ke Add Log
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
