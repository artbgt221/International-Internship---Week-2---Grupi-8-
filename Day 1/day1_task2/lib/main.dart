import 'package:flutter/material.dart';

void main() {
  runApp(const GradeCalculatorApp());
}

// Root widget that configures the Material application.
class GradeCalculatorApp extends StatelessWidget {
  const GradeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grade Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const GradeCalculatorScreen(),
    );
  }
}

// Main screen where the user enters grades and sees the result.
class GradeCalculatorScreen extends StatefulWidget {
  const GradeCalculatorScreen({super.key});

  @override
  State<GradeCalculatorScreen> createState() => _GradeCalculatorScreenState();
}

class _GradeCalculatorScreenState extends State<GradeCalculatorScreen> {
  final TextEditingController _gradeOneController = TextEditingController();
  final TextEditingController _gradeTwoController = TextEditingController();
  final TextEditingController _gradeThreeController = TextEditingController();

  String _message = '';
  String _averageText = '';

  @override
  void dispose() {
    // Dispose controllers to release resources when the screen is removed.
    _gradeOneController.dispose();
    _gradeTwoController.dispose();
    _gradeThreeController.dispose();
    super.dispose();
  }

  void _calculateAverage() {
    final String gradeOneText = _gradeOneController.text.trim();
    final String gradeTwoText = _gradeTwoController.text.trim();
    final String gradeThreeText = _gradeThreeController.text.trim();

    // Validate that none of the fields are empty.
    if (gradeOneText.isEmpty || gradeTwoText.isEmpty || gradeThreeText.isEmpty) {
      setState(() {
        _averageText = '';
        _message = 'Ju lutem plotësoni të gjitha fushat.';
      });
      return;
    }

    final double? gradeOne = double.tryParse(gradeOneText);
    final double? gradeTwo = double.tryParse(gradeTwoText);
    final double? gradeThree = double.tryParse(gradeThreeText);

    // Validate that all entered values are valid numbers.
    if (gradeOne == null || gradeTwo == null || gradeThree == null) {
      setState(() {
        _averageText = '';
        _message = 'Ju lutem shkruani vetëm numra.';
      });
      return;
    }

    // Calculate the average and choose the status message.
    final double average = (gradeOne + gradeTwo + gradeThree) / 3;
    final String status = average >= 6 ? 'Kalon' : 'Duhet përmirësim';

    setState(() {
      _averageText = 'Mesatarja: ${average.toStringAsFixed(2)}';
      _message = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Vendosni 3 nota',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildGradeField(
                  controller: _gradeOneController,
                  label: 'Nota 1',
                ),
                const SizedBox(height: 12),
                _buildGradeField(
                  controller: _gradeTwoController,
                  label: 'Nota 2',
                ),
                const SizedBox(height: 12),
                _buildGradeField(
                  controller: _gradeThreeController,
                  label: 'Nota 3',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateAverage,
                  child: const Text('Llogarit mesataren'),
                ),
                const SizedBox(height: 20),
                Text(
                  _averageText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: _message == 'Kalon' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method used to create each numeric grade TextField.
  Widget _buildGradeField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
