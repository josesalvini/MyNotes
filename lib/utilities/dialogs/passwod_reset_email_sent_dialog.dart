import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Recuperar contraseña',
    content:
        'Se envio un mail para recuperar su contraseña. Revise su correo para mas información.',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
