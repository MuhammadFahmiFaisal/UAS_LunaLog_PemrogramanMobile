import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Menstruasi')),
      body: const Center(
        child: Text('Ini adalah Halaman Riwayat / History\n(Daftar Catatan Menstruasi)', textAlign: TextAlign.center,),
      ),
    );
  }
}
