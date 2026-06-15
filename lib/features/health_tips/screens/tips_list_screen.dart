import 'package:flutter/material.dart';

class TipsListScreen extends StatelessWidget {
  const TipsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tips Kesehatan')),
      body: const Center(
        child: Text('Ini adalah Halaman Daftar Tips Kesehatan', textAlign: TextAlign.center,),
      ),
    );
  }
}
