import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Ingrese email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true, //oculta los caracteres
            enableSuggestions: false, //no suguiere valores para este campo
            autocorrect: false, //no realiza correcciones
            decoration: const InputDecoration(
              hintText: 'Ingrese password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                if (!mounted) return;
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/notes/', (route) => false);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  devtools.log('El usuario no existe.');
                } else if (e.code == 'wrong-password') {
                  devtools.log('El password es incorrecto.');
                } else {
                  devtools.log(e.code);
                }
              }
            },
            child: const Text('Ingresar'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: const Text('No esta registrado?, registrar aqui.'))
        ],
      ),
    );
  }
}
