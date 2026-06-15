import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Card',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3157D5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FC),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showContactMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Faleminderit! Kontakti u hap me sukses.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili im'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black26,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3157D5), Color(0xFF6C8CFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person_rounded,
                              size: 58,
                              color: Color(0xFF3157D5),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Rion Krasniqi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Student Developer',
                            style: TextStyle(
                              color: Color(0xFFE8EDFF),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Rreth meje',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Jam duke zhvilluar aftesite e mia ne Dart dhe '
                            'Flutter per te krijuar aplikacione moderne dhe '
                            'te lehta per perdorim.',
                            style: TextStyle(
                              height: 1.5,
                              color: Color(0xFF555B6E),
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Row(
                            children: [
                              Expanded(
                                child: ContactItem(
                                  icon: Icons.email_outlined,
                                  label: 'Email',
                                  value: 'rion.krasniqi',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ContactItem(
                                  icon: Icons.location_on_outlined,
                                  label: 'Lokacioni',
                                  value: 'Kosove',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              SkillChip(label: 'Dart'),
                              SkillChip(label: 'Flutter'),
                              SkillChip(label: 'GitHub'),
                            ],
                          ),
                          const SizedBox(height: 26),
                          ElevatedButton.icon(
                            onPressed: () => _showContactMessage(context),
                            icon: const Icon(Icons.send_rounded),
                            label: const Text('Me kontakto'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  const ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF3157D5)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  const SkillChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.check_circle, size: 18),
      label: Text(label),
      side: BorderSide.none,
      backgroundColor: const Color(0xFFE7ECFF),
    );
  }
}
