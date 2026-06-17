import 'package:flutter/material.dart';

import 'profile_card.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ProfileHomePage(),
    );
  }
}

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  final List<String> _statuses = <String>[
    'Open to international internships',
    'Currently building Flutter apps',
    'Available for remote collaboration',
  ];

  int _statusIndex = 0;

  void _updateStatus() {
    setState(() {
      _statusIndex = (_statusIndex + 1) % _statuses.length;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_statuses[_statusIndex])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Professional Profile')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double cardWidth = constraints.maxWidth < 720 ? double.infinity : 620;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: ProfileCard(
                    status: _statuses[_statusIndex],
                    onStatusPressed: _updateStatus,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
