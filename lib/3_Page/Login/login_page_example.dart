import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Example login page showing how to migrate from ServerManager to MigrationService
/// Minimal changes required - just replace ServerManager() with MigrationService()
class LoginPageExample extends StatefulWidget {
  const LoginPageExample({super.key});

  @override
  State<LoginPageExample> createState() => _LoginPageExampleState();
}

class _LoginPageExampleState extends State<LoginPageExample> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final MigrationService _migrationService = MigrationService();

  bool isLoading = false;
  bool isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLoginMode) ...[
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSubmit,
                child: isLoading ? const CircularProgressIndicator() : Text(isLoginMode ? 'Login' : 'Register'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoginMode = !isLoginMode;
                });
              },
              child: Text(
                isLoginMode ? 'Don\'t have an account? Register' : 'Already have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (!isLoginMode && usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLoginMode) {
        // Login - same method signature as ServerManager
        loginUser = await _migrationService.login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      } else {
        // Register - same method signature as ServerManager
        loginUser = await _migrationService.register(
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      }

      if (loginUser != null) {
        // Save credentials for auto-login (optional)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString('password', passwordController.text);

        // Navigate to main app
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainAppScreen(), // Your main app screen
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

// Placeholder for your main app screen
class MainAppScreen extends StatelessWidget {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlackBox DB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Logout using Supabase
              final migrationService = MigrationService();
              await migrationService.client.auth.signOut();
              loginUser = null;

              // Clear saved credentials
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('password');

              // Navigate back to login
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPageExample(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${loginUser?.username ?? 'User'}!'),
            const SizedBox(height: 16),
            const Text('BlackBox DB is now running with Supabase!'),
          ],
        ),
      ),
    );
  }
}
