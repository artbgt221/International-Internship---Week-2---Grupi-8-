import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
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

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int currentQuestionIndex = 0;
  int score = 0;

  final List<Question> questions = [
    Question(
      questionText: 'What language is used with Flutter?',
      options: ['Python', 'Dart', 'Java', 'C++'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Which widget creates the basic screen structure?',
      options: ['Text', 'Column', 'Scaffold', 'Icon'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'What does setState do?',
      options: [
        'Updates the UI',
        'Deletes the app',
        'Creates a database',
        'Stops Flutter',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Which widget places children vertically?',
      options: ['Row', 'Container', 'Column', 'AppBar'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'What is Navigator.push used for?',
      options: [
        'Changing color',
        'Opening a new screen',
        'Deleting a widget',
        'Creating a variable',
      ],
      correctAnswerIndex: 1,
    ),
  ];

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex].correctAnswerIndex) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      navigatorKey.currentState?.push(
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

    navigatorKey.currentState?.pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Multi-screen Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: const Color(0xFFECEFF1),
        appBar: AppBar(
          title: const Text('Multi-screen Quiz App'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.quiz,
                            size: 60,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Question ${currentQuestionIndex + 1} of ${questions.length}',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            currentQuestion.questionText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 18),
                          for (int i = 0; i < currentQuestion.options.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    answerQuestion(i);
                                  },
                                  child: Text(currentQuestion.options[i]),
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            'Current score: $score',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  String getResultMessage() {
    if (score == totalQuestions) {
      return 'Excellent work!';
    } else if (score >= 3) {
      return 'Good job!';
    } else {
      return 'Keep practicing!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        title: const Text('Quiz Result'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        size: 65,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Final Result',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Score: $score / $totalQuestions',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        getResultMessage(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onRestart,
                          child: const Text('Restart Quiz'),
                        ),
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
