import 'package:flutter/material.dart';

import 'quiz_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    required this.score,
    required this.totalQuestions,
    super.key,
  });

  final int score;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final double percentage = score / totalQuestions;
    final String message = percentage >= 0.8
        ? 'Excellent work'
        : percentage >= 0.6
            ? 'Nice progress'
            : 'Keep practicing';

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Result')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Final Score',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$score / $totalQuestions',
                        key: const Key('scoreText'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(builder: (_) => const QuizPage()),
                          );
                        },
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Restart quiz'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
