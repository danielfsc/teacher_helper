import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/login/google_login_button.dart';
import 'package:teacher_helper/controllers/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<FirebaseApp>? _auth;

  @override
  void initState() {
    _auth = Authentication.initializeFirebase(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.topLeft,
          colors: [
            Colors.indigo,
            Colors.blue,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          'assets/teacher_logo.png',
                          height: 160,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Teacher Helper',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: _auth,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Erro ao iniciar o Banco de dados (Firebase)');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return const GoogleLoginButton();
                    }
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange,
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
  }
}
