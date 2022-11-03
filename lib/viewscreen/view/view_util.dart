import 'package:flutter/material.dart';
import 'package:health_app/viewscreen/view/kirby_loading.dart';

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

void startKirbyLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: KirbyLoading(),
      );
    }
  );
}

void stopKirbyLoading(BuildContext context) {
  Navigator.of(context).pop();
}
