import 'package:flutter/material.dart';

import 'screens/dictionary_page.dart';
import 'screens/home_page.dart';
import 'screens/onboarding_page.dart';
import 'theme.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    DictionaryPage(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
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
          NavigationDestination(icon: Icon(Icons.analytics_rounded), label: 'Progress'),
        ],
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KoreaMate',
      theme: AppTheme.lightTheme(),
      initialRoute: 'onboarding',
      routes: {
        'onboarding': (_) => const OnboardingPage(),
        'home': (_) => const RootShell(),
        'dictionary': (_) => const DictionaryPage(),
      },
    );
  }
}
