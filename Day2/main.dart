import 'package:flutter/material.dart';

void main() {
  runApp(const StudentListApp());
}

class Student {
  final String name;
  final String email;
  final String role;

  Student({
    required this.name,
    required this.email,
    required this.role,
  });
}

class StudentListApp extends StatefulWidget {
  const StudentListApp({super.key});

  @override
  State<StudentListApp> createState() => _StudentListAppState();
}

class _StudentListAppState extends State<StudentListApp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  String errorMessage = '';

  final List<Student> students = [
    Student(
      name: 'Orik Bublaku',
      email: 'orik@example.com',
      role: 'Flutter Student',
    ),
    Student(
      name: 'Arta Krasniqi',
      email: 'arta@example.com',
      role: 'UI Designer',
    ),
    Student(
      name: 'Dion Berisha',
      email: 'dion@example.com',
      role: 'Dart Beginner',
    ),
  ];

  void addStudent() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String role = roleController.text.trim();

    if (name.isEmpty || email.isEmpty || role.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields.';
      });
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        errorMessage = 'Please enter a valid email.';
      });
      return;
    }

    setState(() {
      students.add(
        Student(
          name: name,
          email: email,
          role: role,
        ),
      );

      errorMessage = '';
      nameController.clear();
      emailController.clear();
      roleController.clear();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day 2 Student List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFECEFF1),
        appBar: AppBar(
          title: const Text('Student Profiles'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Column(
                        children: [
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.person_add,
                                    size: 70,
                                    color: Colors.blue,
                                  ),

                                  const SizedBox(height: 10),

                                  const Text(
                                    'Add New Student',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  TextField(
                                    controller: roleController,
                                    decoration: const InputDecoration(
                                      labelText: 'Role',
                                      prefixIcon: Icon(Icons.work),
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  if (errorMessage.isNotEmpty)
                                    Text(
                                      errorMessage,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  const SizedBox(height: 15),

                                  ElevatedButton(
                                    onPressed: addStudent,
                                    child: const Text('Add Student'),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          const Text(
                            'Student List',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];

                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${student.role}\n${student.email}',
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
