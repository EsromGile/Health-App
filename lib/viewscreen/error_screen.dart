import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen(this.errorMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Internal Error'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                Image.asset(
                  "images/kirby-error-message.png",
                  height: 300,
                ),
                const SizedBox(height: 30,),
                Text(
                  "Error: $errorMessage",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 238, 147, 182),
                    fontSize: 18.0,
                  ),
                ),
              ], 
            ),
          ),
        )
      );
  }
}
