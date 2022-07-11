import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Compartir',
    content: 'No puede compartir una nota vacia!!!.',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
