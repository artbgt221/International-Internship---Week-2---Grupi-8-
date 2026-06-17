import 'package:flutter/material.dart';

void main() {
  runApp(const RegistrationFormApp());
}

class RegistrationFormApp extends StatefulWidget {
  const RegistrationFormApp({super.key});

  @override
  State<RegistrationFormApp> createState() => _RegistrationFormAppState();
}

class _RegistrationFormAppState extends State<RegistrationFormApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedRole = 'Student';

  String nameError = '';
  String emailError = '';
  String passwordError = '';

  bool passwordHidden = true;

  void submitForm() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      nameError = '';
      emailError = '';
      passwordError = '';
    });

    bool hasError = false;

    if (name.isEmpty) {
      setState(() {
        nameError = 'Please enter your name.';
      });
      hasError = true;
    }

    if (email.isEmpty) {
      setState(() {
        emailError = 'Please enter your email.';
      });
      hasError = true;
    } else if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        emailError = 'Please enter a valid email.';
      });
      hasError = true;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter your password.';
      });
      hasError = true;
    } else if (password.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters.';
      });
      hasError = true;
    }

    if (hasError) {
      return;
    }

    final dialogContext = navigatorKey.currentContext;

    if (dialogContext == null) {
      return;
    }

    showDialog(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 15),
              Text('Name: $name'),
              Text('Email: $email'),
              Text('Role: $selectedRole'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                nameController.clear();
                emailController.clear();
                passwordController.clear();

                setState(() {
                  selectedRole = 'Student';
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget buildErrorText(String error) {
    if (error.isEmpty) {
      return const SizedBox(height: 0);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        error,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Registration Form',
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
          title: const Text('Registration Form'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.app_registration,
                            size: 80,
                            color: Colors.blue,
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Fill the form below to register.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),

                          const SizedBox(height: 25),

                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          buildErrorText(nameError),

                          const SizedBox(height: 15),

                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          buildErrorText(emailError),

                          const SizedBox(height: 15),

                          TextField(
                            controller: passwordController,
                            obscureText: passwordHidden,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordHidden = !passwordHidden;
                                  });
                                },
                              ),
                            ),
                          ),
                          buildErrorText(passwordError),

                          const SizedBox(height: 15),

                          DropdownButtonFormField<String>(
                            value: selectedRole,
                            decoration: const InputDecoration(
                              labelText: 'Role / Status',
                              prefixIcon: Icon(Icons.badge),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Student',
                                child: Text('Student'),
                              ),
                              DropdownMenuItem(
                                value: 'Intern',
                                child: Text('Intern'),
                              ),
                              DropdownMenuItem(
                                value: 'Developer',
                                child: Text('Developer'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value!;
                              });
                            },
                          ),

                          const SizedBox(height: 25),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: submitForm,
                              child: const Text('Submit Registration'),
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
      ),
    );
  }
}
