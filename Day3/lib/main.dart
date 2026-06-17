import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day 3 Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool answered = false;

  final List<Question> questions = const [
    Question(
      text: 'What is Flutter?',
      options: ['Programming language', 'UI framework', 'Database', 'Browser'],
      correctIndex: 1,
    ),
    Question(
      text: 'Which method refreshes the UI in a StatefulWidget?',
      options: ['print()', 'setState()', 'Navigator.push()', 'return'],
      correctIndex: 1,
    ),
    Question(
      text: 'What does Navigator.push() do?',
      options: [
        'Closes the app',
        'Deletes a screen',
        'Opens a new screen',
        'Changes the font',
      ],
      correctIndex: 2,
    ),
    Question(
      text: 'What does Navigator.pop() do?',
      options: [
        'Returns to the previous screen',
        'Adds a new question',
        'Refreshes the UI',
        'Creates a button',
      ],
      correctIndex: 0,
    ),
    Question(
      text: 'Why do we use model classes in Dart?',
      options: [
        'To organize data clearly',
        'To make the app slower',
        'To remove widgets',
        'To close the screen',
      ],
      correctIndex: 0,
    ),
  ];

  void chooseAnswer(int index) {
    if (answered) return;

    final Question currentQuestion = questions[currentQuestionIndex];
    final bool isCorrect = index == currentQuestion.correctIndex;

    setState(() {
      selectedAnswerIndex = index;
      answered = true;

      if (isCorrect) {
        score++;
      }
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct answer!' : 'Wrong answer!'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void goToNextQuestion() {
    if (!answered) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose an answer first.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final bool isLastQuestion = currentQuestionIndex == questions.length - 1;

    if (isLastQuestion) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            totalQuestions: questions.length,
          ),
        ),
      ).then((_) {
        restartQuiz();
      });
    } else {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        answered = false;
      });
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswerIndex = null;
      answered = false;
    });
  }

  void showRestartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restart Quiz'),
          content: const Text('Are you sure you want to restart the quiz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                restartQuiz();
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  Color getOptionColor(int index) {
    if (!answered) {
      return Colors.white;
    }

    final int correctIndex = questions[currentQuestionIndex].correctIndex;

    if (index == correctIndex) {
      return Colors.green.shade100;
    }

    if (index == selectedAnswerIndex && index != correctIndex) {
      return Colors.red.shade100;
    }

    return Colors.white;
  }

  Icon? getOptionIcon(int index) {
    if (!answered) {
      return null;
    }

    final int correctIndex = questions[currentQuestionIndex].correctIndex;

    if (index == correctIndex) {
      return const Icon(Icons.check_circle, color: Colors.green);
    }

    if (index == selectedAnswerIndex && index != correctIndex) {
      return const Icon(Icons.cancel, color: Colors.red);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Question currentQuestion = questions[currentQuestionIndex];
    final double progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 3 Quiz App'),
        actions: [
          Center(
            child: Text(
              'Score: $score',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: showRestartDialog,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1} of ${questions.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                LinearProgressIndicator(value: progress),

                const SizedBox(height: 24),

                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      currentQuestion.text,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ...List.generate(currentQuestion.options.length, (index) {
                  return Card(
                    color: getOptionColor(index),
                    child: ListTile(
                      title: Text(
                        currentQuestion.options[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: getOptionIcon(index),
                      onTap: () {
                        chooseAnswer(index);
                      },
                    ),
                  );
                }),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: goToNextQuestion,
                  child: Text(
                    currentQuestionIndex == questions.length - 1
                        ? 'Show Result'
                        : 'Next Question',
                  ),
                ),
              ],
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

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  String getMessage() {
    final double percentage = score / totalQuestions;

    if (percentage == 1) {
      return 'Excellent! Perfect score.';
    } else if (percentage >= 0.7) {
      return 'Very good result!';
    } else if (percentage >= 0.5) {
      return 'Good, but you can improve.';
    } else {
      return 'You should practice more.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String percent = ((score / totalQuestions) * 100).toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Your Score: $score / $totalQuestions',
                      style: const TextStyle(fontSize: 22),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      getMessage(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Restart Quiz'),
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
