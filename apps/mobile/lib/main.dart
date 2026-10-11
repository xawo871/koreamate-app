import 'package:flutter/material.dart';

void main() {
  runApp(const KoreaMateApp());
}

class KoreaMateApp extends StatelessWidget {
  const KoreaMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KoreaMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B5BD6)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KoreaMate'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_rounded, size: 72),
            SizedBox(height: 16),
            Text(
              'Phase 0 Foundation',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Learning app skeleton ready for MVP development.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
