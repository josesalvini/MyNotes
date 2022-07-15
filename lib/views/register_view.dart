import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'El password es demasiado debil.');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context, 'El email ingresado ya esta en uso.');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'El email ingresado no es valido.');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Fallo al registrar el usuario.');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registro'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ingrese su email y password para ver sus notas.'),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese email',
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true, //oculta los caracteres
                  enableSuggestions:
                      false, //no suguiere valores para este campo
                  autocorrect: false, //no realiza correcciones
                  decoration: const InputDecoration(
                    hintText: 'Ingrese password',
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(AuthEventRegister(
                                email,
                                password,
                              ));
                        },
                        child: const Text('Registrar'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthEventLogOut());
                        },
                        child: const Text('Estas registrado?, Login aqui.'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
