#!/bin/bash

echo "Enter your project name: "
read project_name

# Create the Flutter project
flutter create $project_name

# Navigate to the project directory
cd $project_name

# Add packages
flutter pub add provider dio get_storage get_it either_dart

# Create the main directories
mkdir -p lib/features/auth/screens lib/features/auth/screens/widgets lib/features/auth/controllers lib/features/auth/repos lib/features/auth/models lib/features/home/screens lib/features/home/screens/widgets lib/features/home/controllers lib/features/home/repos lib/features/home/models lib/repositories lib/utils

# Create the files
touch lib/main.dart
touch lib/di.dart
touch lib/features/auth/screens/login_page.dart
touch lib/features/auth/screens/signup_page.dart
touch lib/features/auth/screens/widgets/custom_text_field.dart
touch lib/features/auth/screens/widgets/custom_button.dart
touch lib/features/auth/controllers/auth_controller.dart
touch lib/features/auth/repos/auth_repo.dart
touch lib/features/auth/models/user_model.dart
touch lib/repositories/api_repository.dart
touch lib/utils/validators.dart

echo "Files structure created ✅"

# Add content to lib/di.dart
cat <<EOL > lib/di.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:$project_name/features/auth/controllers/auth_controller.dart';
import 'package:$project_name/features/auth/repos/auth_repo.dart';

final getIt = GetIt.instance;

void setup() {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://your-api-base-url.com', // Replace with your API base URL
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<AuthRepo>(AuthRepo());
  getIt.registerSingleton<AuthController>(AuthController());
}
EOL

# Add content to lib/repositories/api_repository.dart
cat <<EOL > lib/repositories/api_repository.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

class ApiRepository {
  static final Dio _dio = GetIt.instance<Dio>();

  static Future<Response> getApi(String url, {bool needToken = false}) async {
    final box = GetStorage();
    if (needToken) {
      final token = box.read('token');
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return _dio.get(url);
  }

  static Future<Response> postBody(String url, dynamic data, {bool needToken = false}) async {
    final box = GetStorage();
    if (needToken) {
      final token = box.read('token');
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return _dio.post(url, data: data);
  }

  static Future<Response> postFormData(String url, FormData data, {bool needToken = false}) async {
    final box = GetStorage();
    if (needToken) {
      final token = box.read('token');
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return _dio.post(url, data: data);
  }
}
EOL

# Add content to lib/features/auth/repos/auth_repo.dart
cat <<EOL > lib/features/auth/repos/auth_repo.dart
import 'package:dio/dio.dart';
import 'package:$project_name/repositories/api_repository.dart';

class AuthRepo {
  Future<Response> login(String email, String password) {
    return ApiRepository.postBody('/login', {
      'email': email,
      'password': password,
    });
  }

  Future<Response> signup(String name, String email, String password) {
    return ApiRepository.postBody('/signup', {
      'name': name,
      'email': email,
      'password': password,
    });
  }
}
EOL

# Add content to lib/features/auth/controllers/auth_controller.dart
cat <<EOL > lib/features/auth/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:$project_name/features/auth/repos/auth_repo.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

class AuthController with ChangeNotifier {
  final AuthRepo _authRepo = GetIt.instance<AuthRepo>();

  Future<Either<String, bool>> login(String email, String password) async {
    try {
      final response = await _authRepo.login(email, password);
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return const Left('Login failed');
      }
    } catch (e) {
      return const Left('Login failed');
    }
  }

  Future<Either<String, bool>> signup(
      String name, String email, String password) async {
    try {
      final response = await _authRepo.signup(name, email, password);
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return const Left('Signup failed');
      }
    } catch (e) {
      return const Left('Signup failed');
    }
  }
}
EOL

# Add content to lib/utils/validators.dart
cat <<EOL > lib/utils/validators.dart
class Validators {
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    // You can add more specific validation rules for names here if needed
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
EOL


# Add content to lib/features/auth/screens/widgets/custom_text_field.dart
cat <<EOL > lib/features/auth/screens/widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPasswordField;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPasswordField = false,
    this.validator,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      obscureText: widget.isPasswordField ? _obscureText : false,
      validator: widget.validator,
    );
  }
}
EOL


# Add content to lib/features/auth/screens/widgets/custom_button.dart
cat <<EOL > lib/features/auth/screens/widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final double widthFactor;

  const CustomButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color = Colors.blue,
    this.widthFactor = 0.9,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widthFactor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
EOL

# Add content to lib/features/auth/screens/login_page.dart
cat <<EOL > lib/features/auth/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:$project_name/features/auth/controllers/auth_controller.dart';
import 'package:$project_name/utils/validators.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = GetIt.instance<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                validator: Validators.emailValidator,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                isPasswordField: true,
                validator: Validators.passwordValidator,
              ),
              const SizedBox(height: 20),
              CustomButton(
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final result = await authController.login(
                      emailController.text,
                      passwordController.text,
                    );
                    result.fold(
                      (error) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      ),
                      (success) =>
                          Navigator.pushReplacementNamed(context, '/home'),
                    );
                  }
                },
              ),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/signup'),
                  child: const Text("Don't have an account? Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}
EOL

# Add content to lib/features/auth/screens/signup_page.dart
cat <<EOL > lib/features/auth/screens/signup_page.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:$project_name/features/auth/controllers/auth_controller.dart';
import 'package:$project_name/utils/validators.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = GetIt.instance<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                labelText: 'Name',
                validator: Validators.nameValidator,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                validator: Validators.emailValidator,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                isPasswordField: true,
                validator: Validators.passwordValidator,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final result = await authController.signup(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                    );
                    result.fold(
                      (error) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      ),
                      (success) =>
                          Navigator.pushReplacementNamed(context, '/home'),
                    );
                  }
                },
                child: const Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text("Already have an account? Login"))
            ],
          ),
        ),
      ),
    );
  }
}
EOL

# Add content to lib/main.dart
cat <<EOL > lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:$project_name/features/auth/controllers/auth_controller.dart';
import 'package:$project_name/features/auth/screens/login_page.dart';
import 'package:$project_name/features/auth/screens/signup_page.dart';
import 'package:$project_name/di.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthController>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginPage(),
          '/signup': (_) => const SignupPage(),
          // Add more routes here
        },
      ),
    );
  }
}
EOL

echo "Project setup complete. ✅"