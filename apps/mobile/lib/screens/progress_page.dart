import 'package:flutter/material.dart';

import '../services/learning_storage.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Future<LearningProgress> _progressFuture;

  @override
  void initState() {
    super.initState();
    _progressFuture = LearningStorageService.loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LearningProgress>(
      future: _progressFuture,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? const LearningProgress();
        final metrics = [
          _MetricCard(label: 'Kosakata', value: '${progress.vocabularyCount}', delta: '+${progress.vocabularyCount} minggu ini'),
          _MetricCard(label: 'Streak', value: '${progress.streakDays} hari', delta: 'Tinggi'),
          _MetricCard(label: 'Review', value: '${progress.reviewRate}%', delta: 'Berhasil'),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Progress'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress belajar',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: metrics,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pencapaian minggu ini',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Membaca dasar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('${progress.reviewRate}/100 poin review'),
                      const SizedBox(height: 14),
                      LinearProgressIndicator(
                        value: (progress.reviewRate / 100).clamp(0.0, 1.0),
                        minHeight: 10,
                      ),
                      const SizedBox(height: 18),
                      const Text('Kosakata harian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('${progress.vocabularyCount} kata tersimpan dalam progress'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String delta;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.delta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 4),
          Text(delta, style: const TextStyle(fontSize: 10, color: Color(0xFF10B981))),
        ],
      ),
    );
  }
}
