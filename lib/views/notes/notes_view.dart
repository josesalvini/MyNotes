import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
import '../../services/cloud/cloud_note.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  //String get userEmail => AuthService.firebase().currentUser!.email;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    //_notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: _notesService.getAllNotes(ownerUserId: userId).getLength,
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                final noteCount = snapshot.data ?? 0;
                final text = context.loc.notes_title(noteCount);
                return Text(text);
              } else {
                return const Text('');
              }
            }),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final result = await showLogOutDialog(context);
                if (result) {
                  if (!mounted) return;
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                  // await AuthService.firebase().logOut();
                  //La propiedad mounted debe verificarse después de un espacio asíncrono.
                  // if (!mounted) return;
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log out'),
              ),
            ];
          })
        ],
      ),
      body: StreamBuilder(
          stream: _notesService.getAllNotes(
            ownerUserId: userId,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final notesList = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: notesList,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) async {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const Text('No hay notas para mostrar!!!');
                }
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

/*
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Salir'),
          content: const Text('¿Seguro que quiere cerrar la sesión?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Salir')),
          ],
        );
      }).then((value) => value ?? false);
}
*/

/*FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final notesList = snapshot.data as List<DatabaseNote>;
                          return NotesListView(
                            notes: notesList,
                            onDeleteNote: (note) async {
                              await _notesService.deleteNote(id: note.id);
                            },
                            onTap: (note) async {
                              Navigator.of(context).pushNamed(
                                createOrUpdateNoteRoute,
                                arguments: note,
                              );
                            },
                          );
                        } else {
                          return const Text('No hay notas para mostrar!!!');
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  });
            default:
              return const CircularProgressIndicator();
          }
        },
      ), */