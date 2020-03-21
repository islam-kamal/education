import 'package:education/view/ChatTabScreen.dart';
import 'package:education/view/Home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }

}

class LoginPageState extends State<LoginPage>{
  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);
  final _userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(),
      body: Center(
        child: new Column(
          children: <Widget>[
            new TextField(
                controller: _userNameController,
                decoration: InputDecoration(hintText: 'Input your user id')),
            new OutlineButton(
              child: Text( 'Login', style: textStyle),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context)=>
                      Home(
                        userId: _userNameController.text,
                      ),),
                );
              },
            )
          ],
        ),
      ),
    );
  }


}