import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      home: const QuizScreen(),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Question> questions = [
    Question(
      questionText: 'Which language is used to build Flutter apps?',
      options: ['Java', 'Dart', 'Python', 'C++'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Who develops Flutter?',
      options: ['Apple', 'Microsoft', 'Google', 'Meta'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'Which widget arranges children vertically?',
      options: ['Row', 'Stack', 'Column', 'ListView'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'Which method updates the UI in a StatefulWidget?',
      options: ['build()', 'update()', 'refresh()', 'setState()'],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: 'Which widget is used for app navigation?',
      options: ['Navigator', 'Scaffold', 'Container', 'Expanded'],
      correctAnswerIndex: 0,
    ),
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  void answerQuestion(int selectedIndex) {
    if (selectedIndex ==
        questions[currentQuestionIndex].correctAnswerIndex) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            totalQuestions: questions.length,
            onRestart: restartQuiz,
          ),
        ),
      );
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(fontSize: 20),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 32),

                  ...List.generate(
                    question.options.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () => answerQuestion(index),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(question.options[index]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your Score',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                '$score / $totalQuestions',
                style: const TextStyle(fontSize: 48),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: onRestart,
                child: const Text('Restart Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
