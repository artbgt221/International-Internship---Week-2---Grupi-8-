import 'package:flutter/material.dart';

void main() {
  runApp(const GradeCalculatorApp());
}

class GradeCalculatorApp extends StatefulWidget {
  const GradeCalculatorApp({super.key});

  @override
  State<GradeCalculatorApp> createState() => _GradeCalculatorAppState();
}

class _GradeCalculatorAppState extends State<GradeCalculatorApp> {
  final TextEditingController grade1Controller = TextEditingController();
  final TextEditingController grade2Controller = TextEditingController();
  final TextEditingController grade3Controller = TextEditingController();

  String resultText = 'Enter three scores and calculate the average.';
  String statusText = '';

  void calculateAverage() {
    String grade1Text = grade1Controller.text;
    String grade2Text = grade2Controller.text;
    String grade3Text = grade3Controller.text;

    if (grade1Text.isEmpty || grade2Text.isEmpty || grade3Text.isEmpty) {
      setState(() {
        resultText = 'Please fill all fields.';
        statusText = '';
      });
      return;
    }

    double? grade1 = double.tryParse(grade1Text);
    double? grade2 = double.tryParse(grade2Text);
    double? grade3 = double.tryParse(grade3Text);

    if (grade1 == null || grade2 == null || grade3 == null) {
      setState(() {
        resultText = 'Please enter only numbers.';
        statusText = '';
      });
      return;
    }

    double average = (grade1 + grade2 + grade3) / 3;

    setState(() {
      resultText = 'Average: ${average.toStringAsFixed(2)}';

      if (average >= 50) {
        statusText = 'Status: Kalon';
      } else {
        statusText = 'Status: Duhet përmirësim';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Calculator UI',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFECEFF1),
        appBar: AppBar(
          title: const Text('Grade Calculator UI'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calculate,
                          size: 80,
                          color: Colors.blue,
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          'Grade Calculator',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Enter three scores to calculate the average.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: grade1Controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Score 1',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.looks_one),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller: grade2Controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Score 2',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.looks_two),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller: grade3Controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Score 3',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.looks_3),
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: calculateAverage,
                          child: const Text('Calculate Average'),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          resultText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          statusText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
    );
  }
}
