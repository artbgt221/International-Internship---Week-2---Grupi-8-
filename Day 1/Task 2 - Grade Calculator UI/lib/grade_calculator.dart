import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradeCalculatorPage extends StatefulWidget {
  const GradeCalculatorPage({super.key});

  @override
  State<GradeCalculatorPage> createState() => _GradeCalculatorPageState();
}

class _GradeCalculatorPageState extends State<GradeCalculatorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List<TextEditingController>.generate(
    3,
    (_) => TextEditingController(),
  );

  double? _average;

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validateGrade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a grade';
    }

    final double? grade = double.tryParse(value.trim());
    if (grade == null) {
      return 'Use a valid number';
    }

    if (grade < 0 || grade > 100) {
      return 'Use 0 to 100';
    }

    return null;
  }

  void _calculateAverage() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _average = null);
      return;
    }

    final double total = _controllers
        .map((TextEditingController controller) => double.parse(controller.text.trim()))
        .reduce((double first, double second) => first + second);

    setState(() {
      _average = total / _controllers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Grade Calculator')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Course Average',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter three grades from 0 to 100.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        for (int index = 0; index < _controllers.length; index++) ...<Widget>[
                          TextFormField(
                            key: Key('gradeField$index'),
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              labelText: 'Grade ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                            validator: _validateGrade,
                          ),
                          if (index != _controllers.length - 1) const SizedBox(height: 16),
                        ],
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _calculateAverage,
                          icon: const Icon(Icons.calculate_outlined),
                          label: const Text('Calculate average'),
                        ),
                        if (_average != null) ...<Widget>[
                          const SizedBox(height: 24),
                          Container(
                            key: const Key('resultPanel'),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: colors.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Average: ${_average!.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: colors.onSecondaryContainer,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _average! >= 60 ? 'Status: Pass' : 'Status: Needs Improvement',
                                  style: TextStyle(color: colors.onSecondaryContainer),
                                ),
                              ],
                            ),
                          ),
                        ],
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
