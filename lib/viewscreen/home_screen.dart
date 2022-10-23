import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = "/startScreen";

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("This Screen Should: "),
              const Text(" - Display user information and data"),
              const Text(" - Display accomplishments with goal"),
              SizedBox(
                width: 200,
                child: Image.asset("images/kirby-succs.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _HomeScreenState state;
  _Controller(this.state);
}
