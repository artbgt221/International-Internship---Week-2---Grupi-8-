import 'package:flutter/material.dart';

import 'student.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _programController = TextEditingController();

  final List<Student> _students = <Student>[
    const Student(name: 'Sara Novak', email: 'sara.novak@example.com', program: 'Business'),
    const Student(name: 'Jonas Keller', email: 'jonas.keller@example.com', program: 'Computer Science'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _programController.dispose();
    super.dispose();
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final String? requiredMessage = _requiredText(value);
    if (requiredMessage != null) {
      return requiredMessage;
    }

    final bool isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!.trim());
    if (!isValid) {
      return 'Enter a valid email';
    }

    return null;
  }

  void _addStudent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _students.insert(
        0,
        Student(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          program: _programController.text.trim(),
        ),
      );
    });

    _nameController.clear();
    _emailController.clear();
    _programController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Directory')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth >= 820;
            final Widget form = _StudentForm(
              formKey: _formKey,
              nameController: _nameController,
              emailController: _emailController,
              programController: _programController,
              onSubmit: _addStudent,
              requiredText: _requiredText,
              validateEmail: _validateEmail,
            );
            final Widget list = _StudentList(students: _students);

            if (isWide) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 360, child: form),
                    const SizedBox(width: 24),
                    Expanded(child: list),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  form,
                  const SizedBox(height: 16),
                  Expanded(child: list),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StudentForm extends StatelessWidget {
  const _StudentForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.programController,
    required this.onSubmit,
    required this.requiredText,
    required this.validateEmail,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController programController;
  final VoidCallback onSubmit;
  final FormFieldValidator<String> requiredText;
  final FormFieldValidator<String> validateEmail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Add Student',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
              TextFormField(
                key: const Key('nameField'),
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                validator: requiredText,
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('emailField'),
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('programField'),
                controller: programController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Program',
                ),
                validator: requiredText,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Add student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentList extends StatelessWidget {
  const _StudentList({required this.students});

  final List<Student> students;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Text(
                'Students (${students.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (BuildContext context, int index) {
                  final Student student = students[index];

                  return Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: ListTile(
                      leading: CircleAvatar(child: Text(student.name.characters.first)),
                      title: Text(student.name),
                      subtitle: Text('${student.email}\n${student.program}'),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
