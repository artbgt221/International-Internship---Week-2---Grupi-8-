import 'package:flutter/material.dart';

void main() {
  runApp(const GradeCalculatorApp());
}

class GradeCalculatorApp extends StatelessWidget {
  const GradeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Calculator UI',
      debugShowCheckedModeBanner: false,
      home: const GradeCalculatorScreen(),
    );
  }
}

class GradeCalculatorScreen extends StatefulWidget {
  const GradeCalculatorScreen({super.key});

  @override
  State<GradeCalculatorScreen> createState() => _GradeCalculatorScreenState();
}

class _GradeCalculatorScreenState extends State<GradeCalculatorScreen> {
  final TextEditingController firstGradeController = TextEditingController();
  final TextEditingController secondGradeController = TextEditingController();
  final TextEditingController thirdGradeController = TextEditingController();

  String resultText = 'Enter three grades or points.';
  String statusText = '';
  String errorText = '';

  final double passingAverage = 50;

  @override
  void dispose() {
    firstGradeController.dispose();
    secondGradeController.dispose();
    thirdGradeController.dispose();
    super.dispose();
  }

  double? convertToNumber(String value) {
    return double.tryParse(value.replaceAll(',', '.'));
  }

  void calculateAverage() {
    String firstValue = firstGradeController.text.trim();
    String secondValue = secondGradeController.text.trim();
    String thirdValue = thirdGradeController.text.trim();

    if (firstValue.isEmpty || secondValue.isEmpty || thirdValue.isEmpty) {
      setState(() {
        errorText = 'Please fill in all fields.';
        resultText = 'Enter three grades or points.';
        statusText = '';
      });
      return;
    }

    double? firstGrade = convertToNumber(firstValue);
    double? secondGrade = convertToNumber(secondValue);
    double? thirdGrade = convertToNumber(thirdValue);

    if (firstGrade == null || secondGrade == null || thirdGrade == null) {
      setState(() {
        errorText = 'Please enter only valid numbers.';
        resultText = 'Enter three grades or points.';
        statusText = '';
      });
      return;
    }

    double average = (firstGrade + secondGrade + thirdGrade) / 3;

    setState(() {
      errorText = '';
      resultText = 'Average: ${average.toStringAsFixed(2)}';

      if (average >= passingAverage) {
        statusText = 'Status: Kalon';
      } else {
        statusText = 'Status: Duhet përmirësim';
      }
    });
  }

  void clearFields() {
    firstGradeController.clear();
    secondGradeController.clear();
    thirdGradeController.clear();

    setState(() {
      resultText = 'Enter three grades or points.';
      statusText = '';
      errorText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text('Day 1 - Grade Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calculate,
                      size: 80,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Grade Calculator UI',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Enter three numeric values to calculate the average.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: firstGradeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'First grade / points',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.looks_one),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: secondGradeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Second grade / points',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.looks_two),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: thirdGradeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Third grade / points',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.looks_3),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (errorText.isNotEmpty)
                      Text(
                        errorText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    if (errorText.isNotEmpty) const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            resultText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (statusText.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              statusText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: statusText.contains('Kalon')
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: calculateAverage,
                            child: const Text('Calculate'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: clearFields,
                            child: const Text('Clear'),
                          ),
                        ),
                      ],
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
