import 'package:flutter/material.dart';
import 'package:education/agora_rtm.dart';
import 'models/ConversationModel.dart';
import 'ChatScreen.dart';




class ChatTabScreen extends StatefulWidget {
  String userId;

  ChatTabScreen({this.userId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatTabScreenState();
  }
}
class ChatTabScreenState extends State<ChatTabScreen> {
  String userId;
  String teacher_id;
  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);
  bool _isLogin = false;
  bool _isInChannel = false;
  final _infoStrings = <String>[];
  AgoraRtmClient _client;

  @override
  void initState() {
    super.initState();
    _createConnection();
    print('Connection created successufly');
    _createUserLogin();
    print('UserLogin created successufly');
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (BuildContext context, index) =>
              conversation(context, conversations[index])
      ),
    );

  }

  //_createClient();
  void _createConnection() async {
    //  _client = await AgoraRtmClient.createInstance('YOUR APP ID');
    _client = await AgoraRtmClient.createInstance('29d049f9bcad47939dfa45283abe6ad8');    //link app with agora project in agora website and get APP ID from it
    _client.onMessageReceived = (AgoraRtmMessage message, String clientId) {
      _log("Peer msg: " + clientId + ", msg: " + message.text);
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      _log('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client.logout();
        _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
  }

  //_toggleLogin
  void _createUserLogin() async {
    if (_isLogin) {
      try {
        await _client.logout();
        _log('Logout success.');

        setState(() {
          _isLogin = false;
          _isInChannel = false;
        });
      } catch (errorCode) {
        _log('Logout error: ' + errorCode.toString());
      }
    } else {
      userId = widget.userId; //phone of user which take from login page example (phone :0101)
      print('user-id : $userId');
      if (userId.isEmpty) {
        _log('Please ensure of your phone.');
        return;
      }

      try {
        await _client.login(null, userId);
        _log('Login success: ' + userId);
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        _log('Login error: ' + errorCode.toString());
      }
    }
  }
  //_toggleQuery()

  void _create_teacherLogin() async {
     teacher_id = '1'; //phone of teacher which take from login page example (phone :0101)
    if (teacher_id.isEmpty) {
      _log('Please input teacher user id to query.');
      return;
    }
    try {
      Map<dynamic, dynamic> result =
      await _client.queryPeersOnlineStatus([teacher_id]);
      _log('Query result: ' + result.toString());
    } catch (errorCode) {
      _log('Query error: ' + errorCode.toString());
    }
  }
//_toggleSendPeerMessage
  // use in send button

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }



  Widget conversation(BuildContext context, ConversationModel conversation) {
    return  InkWell(
/*
    onTap: ()=>Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context)=>
          ChatScreen(
              conversation:conversation
          ),),
    ),

 */
        onTap: (){
          _create_teacherLogin();
          print('teacherLogin created successufly');
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context)=>
                  ChatScreen(
                    conversation:conversation,teacher_id: teacher_id,user_id: userId,
                ),),
          );
        },


        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: ClipOval(
                  child: Image.network(
                      conversation.image),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          conversation.fullName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                        ),
                        Text(
                          conversation.message,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          conversation.date,
                          style: TextStyle(
                              color: conversation.messageCout > 0
                                  ? Color(0xFF25D366)
                                  : Colors.grey),
                        ),
                        conversation.messageCout > 0
                            ? Chip(
                          backgroundColor: Color(0xFF25D366),
                          label: Text(
                            '${conversation.messageCout}',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Text(''),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: 330,
                height: 1,
                margin: EdgeInsets.only(left: 56, top: 21),
                color: Colors.grey.withOpacity(.2),
              )
            ],
          ),
        ),
    );



  }
}




