import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSignUp = false;
  String error = '';
  bool isErrorOccur = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onErrorOccur(String msg) {
    setState(() {
      isErrorOccur = true;
      error = msg;
    });
  }

  void onSignUpClicked() {
    setState(() {
      isSignUp = true;
    });
  }

  Future<void> onLoginClicked(AuthServiceProvider authProvider) async {
    try {
      UserModel user = await authProvider.signIn(
          loginEmailController.text, loginPasswordController.text);
      // navigate to chat screen
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChatRoomScreen(user: user)));
    } catch (e) {
      onErrorOccur(e.toString());
    }
  }

  Future<void> onSignUpConfirmClicked(AuthServiceProvider authProvider) async {
    UserModel user = UserModel(
      email: emailController.text,
      username: usernameController.text,
      uid: "",
    );

    try {
      bool result = await authProvider.signUp(
          user, passwordController.text, confirmPasswordController.text);
      if (result) {
        showSuccessDialog();
      }
    } catch (e) {
      onErrorOccur(e.toString());
    }
  }

  void showSuccessDialog() {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: const Text("Sign Up Success"), actions: [
              TextButton(
                  onPressed: () {
                    resetSignUpState();
                    Navigator.pop(context);
                  },
                  child: const Text('OK'))
            ]));
  }

  void onBackBtnClicked() {
    resetSignUpState();
  }

  void resetSignUpState() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      isSignUp = false;
      error = '';
      isErrorOccur = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthServiceProvider>(context);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          'assets/images/Login_page.jpg'), // Replace with your image asset
                    ],
                  ),
                ),
              ),
            ),
          ),
          isSignUp ? signUpWidget(authProvider) : signInWidget(authProvider),
        ],
      ),
    );
  }

  Widget signInWidget(AuthServiceProvider authProvider) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back To FireChat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: loginEmailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: loginPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            isErrorOccur
                ? Text(
                    error,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                onLoginClicked(authProvider);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Login'),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onSignUpClicked,
              child: const Text('Sign Up / Register Here'),
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpWidget(AuthServiceProvider authProvider) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: onBackBtnClicked,
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(width: 30),
                const Text(
                  'Sign Up To FireChat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            isErrorOccur
                ? Text(
                    error,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await onSignUpConfirmClicked(authProvider);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
