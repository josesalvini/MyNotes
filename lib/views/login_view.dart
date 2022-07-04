import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
      body: SingleChildScrollView(
        child: Column(
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
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                  final user = FirebaseAuth.instance.currentUser;
                  if (!mounted) return;
                  if (user?.emailVerified ?? false) {
                    //Si el usuario verifico el email se redirecciona a la vista de notas
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  } else {
                    //Si el usuario no verifico el email se redirecciona a la vista de verificacion
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute, (route) => false);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    //devtools.log('El usuario no existe.');
                    await showErrorDialog(
                      context,
                      'El usuario no existe.',
                    );
                  } else if (e.code == 'wrong-password') {
                    await showErrorDialog(
                      context,
                      'El password es incorrecto.',
                    );
                  } else {
                    await showErrorDialog(
                      context,
                      'Error ${e.code}',
                    );
                  }
                } catch (e) {
                  await showErrorDialog(
                    context,
                    'Error ${e.toString()}',
                  );
                }
              },
              child: const Text('Ingresar'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('No esta registrado?, registrar aqui.'))
          ],
        ),
      ),
    );
  }
}
