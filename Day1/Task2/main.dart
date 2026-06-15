// main.dart - Simple Grade Calculator UI for the internship task
import 'package:flutter/material.dart';

void main() {
  runApp(const GradeCalculatorApp());
}

class GradeCalculatorApp extends StatelessWidget {
  const GradeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GradeCalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GradeCalculatorScreen extends StatefulWidget {
  const GradeCalculatorScreen({super.key});

  @override
  State<GradeCalculatorScreen> createState() => _GradeCalculatorScreenState();
}

class _GradeCalculatorScreenState extends State<GradeCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for three grade fields (minimum requirement)
  final TextEditingController _grade1Controller = TextEditingController();
  final TextEditingController _grade2Controller = TextEditingController();
  final TextEditingController _grade3Controller = TextEditingController();

  double? _average;
  String _status = '';

  // Calculate average and determine status
  void _calculateAverage() {
    if (_formKey.currentState!.validate()) {
      double g1 = double.parse(_grade1Controller.text);
      double g2 = double.parse(_grade2Controller.text);
      double g3 = double.parse(_grade3Controller.text);

      double avg = (g1 + g2 + g3) / 3;

      setState(() {
        _average = double.parse(avg.toStringAsFixed(2));
        _status = _average! >= 5.0 ? 'Kalon' : 'Duhet përmirësim'; // Assuming 5.0 is passing threshold (common in many systems)
      });
    }
  }

  // Clear all fields
  void _clearFields() {
    _grade1Controller.clear();
    _grade2Controller.clear();
    _grade3Controller.clear();
    setState(() {
      _average = null;
      _status = '';
    });
  }

  @override
  void dispose() {
    _grade1Controller.dispose();
    _grade2Controller.dispose();
    _grade3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Fut notat (të paktën 3)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Grade 1
              TextFormField(
                controller: _grade1Controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nota 1',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.grade),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kjo fushë nuk mund të jetë bosh';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ju lutemi vendosni një numër të vlefshëm';
                  }
                  double num = double.parse(value);
                  if (num < 0 || num > 10) {
                    return 'Nota duhet të jetë midis 0 dhe 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Grade 2
              TextFormField(
                controller: _grade2Controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nota 2',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.grade),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kjo fushë nuk mund të jetë bosh';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ju lutemi vendosni një numër të vlefshëm';
                  }
                  double num = double.parse(value);
                  if (num < 0 || num > 10) {
                    return 'Nota duhet të jetë midis 0 dhe 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Grade 3
              TextFormField(
                controller: _grade3Controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nota 3',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.grade),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kjo fushë nuk mund të jetë bosh';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ju lutemi vendosni një numër të vlefshëm';
                  }
                  double num = double.parse(value);
                  if (num < 0 || num > 10) {
                    return 'Nota duhet të jetë midis 0 dhe 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Calculate Button
              ElevatedButton(
                onPressed: _calculateAverage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Llogarit Mesataren',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 16),

              // Clear Button
              OutlinedButton(
                onPressed: _clearFields,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Pastro Fushat'),
              ),

              const SizedBox(height: 40),

              // Results
              if (_average != null) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Text(
                          'Mesatarja',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          _average!.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Statusi: $_status',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _average! >= 5.0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // Info
              const Text(
                'Shënim: Nota kaluese është 5.0+',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
