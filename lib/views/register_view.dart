import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Registro'),
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
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  //final user = AuthService.firebase().currentUser;
                  //if(user != null){
                  await AuthService.firebase().sendEmailVerification();
                  if (!mounted) return;
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                  //}
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'El password es debil.',
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'El email ingresado ya esta en uso.',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'El email ingresado no es valido.',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Error en el registro del usuario.',
                  );
                }
              },
              child: const Text('Registrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Estas registrado?, Login aqui.'),
            ),
          ],
        ),
      ),
    );
  }
}
