import 'package:flutter/material.dart';

import '../models/student.dart';
import '../widgets/student_card.dart';
import '../widgets/student_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Student> _students = [
    const Student(
      name: 'Avery Johnson',
      email: 'avery.johnson@example.com',
      course: 'Flutter Development',
    ),
    const Student(
      name: 'Mia Carter',
      email: 'mia.carter@example.com',
      course: 'Mobile App Design',
    ),
    const Student(
      name: 'Noah Williams',
      email: 'noah.williams@example.com',
      course: 'Software Engineering Intern',
    ),
  ];

  void _addStudent(Student student) {
    setState(() {
      _students.add(student);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${student.name} added successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profiles'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop = constraints.maxWidth >= 800;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView(
      children: [
        StudentForm(onStudentAdded: _addStudent),
        const SizedBox(height: 16),
        ..._buildStudentCards(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 360,
          child: StudentForm(onStudentAdded: _addStudent),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ListView(
            children: _buildStudentCards(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStudentCards() {
    return [
      for (final student in _students) ...[
        StudentCard(student: student),
        const SizedBox(height: 12),
      ],
    ];
  }
}
