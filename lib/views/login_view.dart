import 'package:flutter/material.dart';
import 'admin/admin_home.dart';
import 'user/user_home.dart';
import '../auth/auth.dart';
import '../controllers/controller.dart'; // Sesuaikan dengan struktur proyek Anda
// Sesuaikan dengan struktur proyek Anda

class LoginView extends StatefulWidget {
  final TaskController taskController;

  LoginView({required this.taskController});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _selectedUserType = 'user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            DropdownButton<String>(
              value: _selectedUserType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUserType = newValue!;
                });
              },
              items: <String>['user', 'admin']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value == 'user' ? 'Login as User' : 'Login as Admin',
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _performLogin,
              child: _isLoading ? CircularProgressIndicator() : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _performLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    AuthController authController = AuthController();
    bool isAuthenticated =
        await authController.login(username, password, _selectedUserType);

    setState(() {
      _isLoading = false;
    });

    if (isAuthenticated) {
      // Navigate ke halaman utama berdasarkan tipe pengguna
      if (authController.userType == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserHomePage(taskController: widget.taskController),
          ),
        );
      } else if (authController.userType == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid username or password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
