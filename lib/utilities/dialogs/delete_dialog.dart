import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Eliminar',
    content: '¿Seguro que quiere eliminar este ítem?',
    optionsBuilder: () => {
      'Cancelar': false,
      'Ok': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
