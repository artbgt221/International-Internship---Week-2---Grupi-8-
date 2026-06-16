import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const GradeCalculatorApp());
}

class GradeCalculatorApp extends StatelessWidget {
  const GradeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grade Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GradeCalculatorPage(),
    );
  }
}

class GradeCalculatorPage extends StatefulWidget {
  const GradeCalculatorPage({super.key});

  @override
  State<GradeCalculatorPage> createState() => _GradeCalculatorPageState();
}

class _GradeCalculatorPageState extends State<GradeCalculatorPage> {
  final TextEditingController nota1Controller = TextEditingController();
  final TextEditingController nota2Controller = TextEditingController();
  final TextEditingController nota3Controller = TextEditingController();

  String mesatarja = '--';
  String statusi = 'Vendosni notat';
  Color ngjyraStatusit = Colors.grey;

  @override
  void dispose() {
    nota1Controller.dispose();
    nota2Controller.dispose();
    nota3Controller.dispose();
    super.dispose();
  }

  void llogaritMesataren() {
    if (nota1Controller.text.isEmpty ||
        nota2Controller.text.isEmpty ||
        nota3Controller.text.isEmpty) {
      shfaqGabim('Ju lutem plotesoni te gjitha fushat.');
      return;
    }

    double? nota1 = double.tryParse(nota1Controller.text);
    double? nota2 = double.tryParse(nota2Controller.text);
    double? nota3 = double.tryParse(nota3Controller.text);

    if (nota1 == null || nota2 == null || nota3 == null) {
      shfaqGabim('Vlerat duhet te jene numra.');
      return;
    }

    if (nota1 < 1 ||
        nota1 > 5 ||
        nota2 < 1 ||
        nota2 > 5 ||
        nota3 < 1 ||
        nota3 > 5) {
      shfaqGabim('Notat duhet te jene nga 1 deri ne 5.');
      return;
    }

    double rezultati = (nota1 + nota2 + nota3) / 3;

    setState(() {
      mesatarja = rezultati.toStringAsFixed(2);

      if (rezultati >= 2) {
        statusi = 'Kalon';
        ngjyraStatusit = Colors.green;
      } else {
        statusi = 'Duhet permiresim';
        ngjyraStatusit = Colors.red;
      }
    });
  }

  void shfaqGabim(String mesazhi) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesazhi),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget krijoFushen(String emri, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: emri,
        hintText: '1 - 5',
        prefixIcon: const Icon(Icons.edit_note),
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4FA),
      appBar: AppBar(
        title: const Text('Kalkulatori i Notave'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.calculate,
                      size: 65,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Llogarit mesataren',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Shkruani tri nota nga 1 deri ne 5.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    krijoFushen('Nota e pare', nota1Controller),
                    const SizedBox(height: 14),
                    krijoFushen('Nota e dyte', nota2Controller),
                    const SizedBox(height: 14),
                    krijoFushen('Nota e trete', nota3Controller),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: llogaritMesataren,
                      icon: const Icon(Icons.calculate_outlined),
                      label: const Text('Llogarit'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: ngjyraStatusit.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ngjyraStatusit),
                      ),
                      child: Column(
                        children: [
                          const Text('Mesatarja'),
                          Text(
                            mesatarja,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            statusi,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ngjyraStatusit,
                            ),
                          ),
                        ],
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
