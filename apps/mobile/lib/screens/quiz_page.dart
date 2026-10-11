import 'package:flutter/material.dart';

import '../services/learning_storage.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> _questions = const [
    {
      'question': 'Arti dari "사랑" adalah?',
      'options': ['cinta', 'rumah', 'makan', 'air'],
      'answer': 'cinta',
    },
    {
      'question': 'Arti dari "공부" adalah?',
      'options': ['belajar', 'jalan', 'kota', 'sakit'],
      'answer': 'belajar',
    },
    {
      'question': 'Arti dari "도시" adalah?',
      'options': ['kota', 'makanan', 'pekerjaan', 'hutan'],
      'answer': 'kota',
    },
  ];

  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _showResult = false;

  void _answer(String value) {
    final correct = value == _questions[_currentIndex]['answer'];
    if (correct) {
      _score += 1;
    }

    setState(() {
      _selectedAnswer = value;
      _showResult = true;
    });
  }

  Future<void> _nextQuestion() async {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex += 1;
        _selectedAnswer = null;
        _showResult = false;
      });
      return;
    }

    final total = _questions.length;
    await LearningStorageService.saveQuizResult(_score, total);
    final reviewRate = ((_score / total) * 100).round();
    await LearningStorageService.saveReviewRate(reviewRate);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Selesai'),
        content: Text('Skor kamu: $_score/$total'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz harian')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soal ${_currentIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              question['options'].length,
              (index) {
                final option = question['options'][index];
                final isSelected = _selectedAnswer == option;
                final isCorrect = option == question['answer'];
                final showCorrect = _showResult && isCorrect;
                final showWrong = _showResult && isSelected && !isCorrect;

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: OutlinedButton(
                    onPressed: _showResult ? null : () => _answer(option),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: showCorrect
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : showWrong
                              ? const Color(0xFFEF4444).withOpacity(0.1)
                              : null,
                      side: BorderSide(
                        color: showCorrect
                            ? const Color(0xFF10B981)
                            : showWrong
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_showResult) ...[
              const SizedBox(height: 12),
              Text(
                _selectedAnswer == question['answer']
                    ? 'Benar! Great job.'
                    : 'Salah. Jawaban benar: ${question['answer']}',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedAnswer == question['answer']
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextQuestion,
                  child: const Text('Lanjutkan'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
