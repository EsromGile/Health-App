import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  int? seconds,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: seconds ?? 5), //3 seconds default
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(
      snackBar); //defined snackBar will be rendered under the context
}
