import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  static const routeName = "/startScreen";

  @override
  State<StatefulWidget> createState() {
    return _StartScreenState();
  }
}

class _StartScreenState extends State<StartScreen> {
  late _Controller con;
  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kirby Collects Your Health Data"),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Image.asset("images/kirby-succs.png"),
        ),
      ),
    );
  }
}

class _Controller {
  _StartScreenState state;
  _Controller(this.state);
}
