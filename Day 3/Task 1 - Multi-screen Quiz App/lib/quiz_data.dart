import 'question.dart';

const List<Question> quizQuestions = <Question>[
  Question(
    prompt: 'Which language is used to write Flutter apps?',
    options: <String>['Dart', 'Kotlin', 'Swift', 'Ruby'],
    correctIndex: 0,
  ),
  Question(
    prompt: 'Which widget creates a vertical layout?',
    options: <String>['Stack', 'Column', 'GridView', 'Divider'],
    correctIndex: 1,
  ),
  Question(
    prompt: 'What does setState do?',
    options: <String>[
      'Changes the app icon',
      'Builds a database',
      'Schedules a widget rebuild',
      'Deletes a route',
    ],
    correctIndex: 2,
  ),
  Question(
    prompt: 'Which widget enables scrolling through many children?',
    options: <String>['ListView', 'Text', 'Icon', 'SizedBox'],
    correctIndex: 0,
  ),
  Question(
    prompt: 'Which class is commonly used for app-level Material styling?',
    options: <String>['SnackBar', 'ThemeData', 'Navigator', 'TextField'],
    correctIndex: 1,
  ),
];
