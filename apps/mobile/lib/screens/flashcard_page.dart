import 'package:flutter/material.dart';

class FlashcardItem {
  final String korean;
  final String meaning;
  final String example;

  const FlashcardItem({
    required this.korean,
    required this.meaning,
    required this.example,
  });
}

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final List<FlashcardItem> _cards = const [
    FlashcardItem(
      korean: '사랑',
      meaning: 'cinta / kasih sayang',
      example: '사랑이 깊어져요.',
    ),
    FlashcardItem(
      korean: '공부',
      meaning: 'belajar',
      example: '매일 공부해요.',
    ),
    FlashcardItem(
      korean: '도시',
      meaning: 'kota',
      example: '도시는 매우 크다.',
    ),
    FlashcardItem(
      korean: '학교',
      meaning: 'sekolah',
      example: '학교에 가요.',
    ),
  ];

  int _index = 0;
  bool _showMeaning = false;

  void _nextCard() {
    setState(() {
      _index = (_index + 1) % _cards.length;
      _showMeaning = false;
    });
  }

  void _toggleMeaning() {
    setState(() {
      _showMeaning = !_showMeaning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = _cards[_index];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kartu ${_index + 1}/${_cards.length}'),
                const Text('Review harian'),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onTap: _toggleMeaning,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            card.korean,
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 18),
                          if (_showMeaning) ...[
                            Text(
                              card.meaning,
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Contoh: ${card.example}',
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 16,
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Ketuk untuk melihat arti',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _nextCard,
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Belum tahu'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _nextCard,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Tahu'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
