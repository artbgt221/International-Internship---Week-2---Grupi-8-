import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({
    super.key,
    required this.onStudentAdded,
  });

  final ValueChanged<Student> onStudentAdded;

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _courseController = TextEditingController();

  final RegExp _emailRegex = RegExp(
    r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final student = Student(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      course: _courseController.text.trim(),
    );

    widget.onStudentAdded(student);
    _nameController.clear();
    _emailController.clear();
    _courseController.clear();
  }

  String? _validateRequiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final requiredError = _validateRequiredField(value, 'Email');
    if (requiredError != null) {
      return requiredError;
    }

    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Student',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter full name',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) => _validateRequiredField(value, 'Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email address',
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  hintText: 'Enter course or role',
                ),
                textInputAction: TextInputAction.done,
                validator: (value) => _validateRequiredField(value, 'Course'),
                onFieldSubmitted: (_) => _submitForm(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submitForm,
                child: const Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
