import 'package:flutter/material.dart';
import 'package:health_app/controller/firebase_firestore_controller.dart';

import '../controller/auth_controller.dart';
import '../model/constant.dart';
import '../model/viewscreen_models/displayscreen_model.dart';

class DisplayScreen extends StatefulWidget{
  const DisplayScreen({Key? key}): super(key:key);
   static const routeName = "/displayScreen";

  @override
  State<StatefulWidget> createState() {
    return _DisplayState();
  }
}


class _DisplayState extends State<DisplayScreen>{
  late _Controller con;
  late DisplayScreenModel screenModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con = _Controller(this);
    screenModel = DisplayScreenModel(user: Auth.user!);
    con.loadAccelerometerList();
  }

   void render(fn) => setState(fn);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Screen"),
      ),
      body: bodyView(),
    );
  }

  Widget bodyView(){
    if(screenModel.loadingErrorMessage != null){
      return Text(
        "Internal Error while loading: ${screenModel.loadingErrorMessage}"
      );
    }else if (screenModel.accelerometerList == null){
      return const Center(child: CircularProgressIndicator());
    }else{
      return showAccelerometerList();
    }
  }

  Widget showAccelerometerList(){
    if(screenModel.accelerometerList!.isEmpty){
      return Text('No Accelerometer Data Found', style: Theme.of(context).textTheme.headline6);
    }else {
      return Text('${screenModel.accelerometerList!.length}', style: Theme.of(context).textTheme.headline6);
    }
  }
}

class _Controller {
  _DisplayState state;
  _Controller(this.state);

  Future<void> loadAccelerometerList() async{
    try{
      state.screenModel.accelerometerList = await FirebaseFirestoreController.getAccelerometerList(email: state.screenModel.user.email!);
      state.render((){});
    }catch(e){
      if(Constant.devMode){
        print('=== loading error: $e');
        state.render(() {
          state.screenModel.loadingErrorMessage = '$e';
        });
      }
    }
  }
}