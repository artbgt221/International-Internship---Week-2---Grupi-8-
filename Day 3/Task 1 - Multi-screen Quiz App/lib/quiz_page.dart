import 'package:flutter/material.dart';

import 'question.dart';
import 'quiz_data.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  Question get _currentQuestion => quizQuestions[_currentQuestionIndex];

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _currentQuestion.correctIndex) {
      _score++;
    }

    final bool isLastQuestion = _currentQuestionIndex == quizQuestions.length - 1;

    if (isLastQuestion) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResultPage(score: _score, totalQuestions: quizQuestions.length),
        ),
      );
      return;
    }

    setState(() {
      _currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final double progress = (_currentQuestionIndex + 1) / quizQuestions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Quiz')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 18),
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${quizQuestions.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.primary),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _currentQuestion.prompt,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  for (int index = 0; index < _currentQuestion.options.length; index++) ...<Widget>[
                    OutlinedButton(
                      key: Key('answer$index'),
                      onPressed: () => _answerQuestion(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_currentQuestion.options[index]),
                        ),
                      ),
                    ),
                    if (index != _currentQuestion.options.length - 1) const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
