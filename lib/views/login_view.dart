import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

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
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthStateLoggedOut) {
                  if (state.exception is UserNotFoundAuthException ||
                      state.exception is WorngPasswordAuthException) {
                    await showErrorDialog(
                        context, 'Credenciales incorrectas, verifique.');
                  } else if (state.exception is GenericAuthException) {
                    await showErrorDialog(context, 'Error autenticación.');
                  }
                }
              },
              child: TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventLogIn(
                        email,
                        password,
                      ));
                  //try {
                  // await AuthService.firebase().logIn(
                  //   email: email,
                  //   password: password,
                  // );
                  // final user = AuthService.firebase().currentUser;
                  // if (!mounted) return;
                  // if (user?.isEmailVerified ?? false) {
                  //   //Si el usuario verifico el email se redirecciona a la vista de notas
                  //   Navigator.of(context)
                  //       .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  // } else {
                  //   //Si el usuario no verifico el email se redirecciona a la vista de verificacion
                  //   Navigator.of(context).pushNamedAndRemoveUntil(
                  //       verifyEmailRoute, (route) => false);
                  // }
                  // } on UserNotFoundAuthException {
                  //   await showErrorDialog(
                  //     context,
                  //     'El usuario no existe.',
                  //   );
                  // } on WorngPasswordAuthException {
                  //   await showErrorDialog(
                  //     context,
                  //     'El password es incorrecto.',
                  //   );
                  // } on GenericAuthException {
                  //   await showErrorDialog(
                  //     context,
                  //     'Error en la autenticación.',
                  //   );
                  // }
                },
                child: const Text('Ingresar'),
              ),
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
