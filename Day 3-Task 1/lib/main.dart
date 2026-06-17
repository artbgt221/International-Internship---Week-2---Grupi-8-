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
      title: 'Day 3 Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const QuizScreen(),
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  final String question;
  final List<String> options;
  final int correctAnswerIndex;
}

const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question: 'Cili widget përdoret për tekst në Flutter?',
    options: ['Column', 'Text', 'Scaffold', 'Container'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Çfarë bën setState në Flutter?',
    options: [
      'Mbyll aplikacionin',
      'Ndryshon route',
      'Rifreskon UI pas ndryshimit të state',
      'Krijon vetëm model class',
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'Cili përdoret për të kaluar në ekran tjetër?',
    options: ['Navigator.push', 'print', 'setState', 'TextField'],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: 'Sa opsione ka çdo pyetje në këtë task?',
    options: ['2', '3', '4', '5'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'Çfarë shfaqet në fund të quiz-it?',
    options: ['Vetëm menu', 'Rezultati final', 'Një form login', 'Asgjë'],
    correctAnswerIndex: 1,
  ),
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;

  QuizQuestion get currentQuestion => quizQuestions[currentQuestionIndex];

  void answerQuestion(int selectedIndex) {
    final bool isCorrect = selectedIndex == currentQuestion.correctAnswerIndex;

    if (isCorrect) {
      score++;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Përgjigje e saktë!' : 'Përgjigje e gabuar.'),
        duration: const Duration(milliseconds: 700),
      ),
    );

    final bool isLastQuestion = currentQuestionIndex == quizQuestions.length - 1;

    if (isLastQuestion) {
      Future.delayed(const Duration(milliseconds: 450), () {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              score: score,
              totalQuestions: quizQuestions.length,
              onRestart: restartQuiz,
            ),
          ),
        );
      });
      return;
    }

    setState(() {
      currentQuestionIndex++;
    });
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int questionNumber = currentQuestionIndex + 1;
    final double progress = questionNumber / quizQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-screen Quiz App'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFD8DEE8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Pyetja $questionNumber nga ${quizQuestions.length}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: const Color(0xFF0F766E),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(value: progress),
                      const SizedBox(height: 24),
                      Text(
                        currentQuestion.question,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 22),
                      ...currentQuestion.options.asMap().entries.map((entry) {
                        final int optionIndex = entry.key;
                        final String optionText = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FilledButton.tonal(
                            onPressed: () => answerQuestion(optionIndex),
                            style: FilledButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '${optionIndex + 1}. $optionText',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 6),
                      Text(
                        'Pikët aktuale: $score',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF5F6B7A),
                              fontWeight: FontWeight.w700,
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

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRestart,
  });

  final int score;
  final int totalQuestions;
  final VoidCallback onRestart;

  String get resultMessage {
    final double percentage = score / totalQuestions;

    if (percentage == 1) return 'Perfekt! I gjete të gjitha.';
    if (percentage >= 0.6) return 'Shumë mirë! Vazhdo kështu.';
    return 'Provo përsëri dhe do të përmirësohesh.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezultati'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFD8DEE8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined,
                        size: 64,
                        color: Color(0xFF0F766E),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Rezultati final',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$score / $totalQuestions',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: const Color(0xFF0F766E),
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        resultMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        onPressed: () {
                          onRestart();
                          Navigator.pop(context);
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
