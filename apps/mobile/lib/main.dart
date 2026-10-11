import 'package:flutter/material.dart';

import 'services/dictionary_service.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    OverviewPage(),
    DictionaryPage(),
    ProgressPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KoreaMate'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Kamus'),
          NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Progress'),
        ],
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phase 1 – MVP Learning App',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Focus utama hari ini:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text('• Home screen\n• Kamus resmi / mock backend\n• Progress dan review dasar'),
        ],
      ),
    );
  }
}

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final _controller = TextEditingController();
  final _api = const DictionaryApi(baseUrl: 'http://localhost:8000');
  bool _loading = false;
  List<dynamic> _results = [];
  String? _error;

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() {
        _error = 'Masukkan kata yang ingin dicari.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _api.search(query);
      final entries = response['entries'] as List<dynamic>? ?? <dynamic>[];
      setState(() {
        _results = entries;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data kamus: $e';
        _results = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Cari kata Korea',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _loading ? null : _search,
                icon: const Icon(Icons.search_rounded),
                label: const Text('Cari'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red))
          else if (_loading)
            const CircularProgressIndicator()
          else if (_results.isEmpty)
            const Text('Belum ada hasil. Coba cari kata seperti "사랑" atau "공부".')
          else
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index] as Map<String, dynamic>;
                  final word = item['word'] ?? 'kata';
                  final meaning = item['meaning'] ?? 'Tidak ada arti';
                  final part = item['part_of_speech'] ?? 'kata';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(word, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('$part\n$meaning'),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress belajar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('• 12 kata baru hari ini\n• 3 sesi review\n• 72% target minggu ini'),
        ],
      ),
    );
  }
}
