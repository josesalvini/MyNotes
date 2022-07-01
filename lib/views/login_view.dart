import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            //Si la conexion esta bien cargo la pantalla
            case ConnectionState.done:
              return Column(
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
                    enableSuggestions:
                        false, //no suguiere valores para este campo
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
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: password);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('El usuario no existe.');
                        } else if (e.code == 'wrong-password') {
                          print('El password es incorrecto.');
                        } else {
                          print(e.code);
                        }
                      }
                    },
                    child: const Text('Ingresar'),
                  ),
                ],
              );
            default:
              return const Text('Cargando....');
          }
        }),
      ),
    );
  }
}
