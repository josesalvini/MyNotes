import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Cerrar sesión',
    content: '¿Seguro que quiere cerrar la sesión?',
    optionsBuilder: () => {
      'Cancelar': false,
      'Ok': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
