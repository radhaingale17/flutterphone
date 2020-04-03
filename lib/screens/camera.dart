import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:phoneflutter/screens/dashboard.dart';
import 'package:video_player/video_player.dart';



File _cameraVideo;

VideoPlayerController _cameraVideoPlayerController;

class Sendvideo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: false,
      body: new MyvideoPage(),
    );
  }
}

class MyvideoPage extends StatefulWidget {
  @override
  _MyvideoPageState createState() => new _MyvideoPageState();
}

class _MyvideoPageState extends State<MyvideoPage> {
  Future getVedio() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
    _cameraVideo = video;
    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)
      ..initialize().then((_) {
        setState(() {
          _cameraVideoPlayerController.setLooping(true);
        });
        _cameraVideoPlayerController.play();
      });
  }
  @override
  void dispose(){
    super.dispose();
    _cameraVideoPlayerController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset:false ,
      body: new Center(
        child: _cameraVideo == null ? Text('Record A Video') : enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getVedio,
        tooltip: 'Add Vedio',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // function for uploading video

   Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          if (_cameraVideo != null)
            _cameraVideoPlayerController.value.initialized
                ? AspectRatio(
                    aspectRatio: 100/80,
                    child: VideoPlayer(
                      _cameraVideoPlayerController,
                    ),
                  )
                : Container()
          else
            Text(
              "Click on Pick Video to select video",
              style: TextStyle(fontSize: 18.0),
            ),
          RaisedButton(
            elevation: 7.0,
            child: Text('Add Massage'),
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () {
              showAlertDialog(context);
            },
          )
        ],
      ),
    );
  }
}

// controller
TextEditingController _textFieldController = TextEditingController();
// function of dialog box

showAlertDialog(BuildContext context) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Add Massage'),
    content: TextField(
      
      controller: _textFieldController,
      decoration: InputDecoration(hintText: "Enter here"),
    ),
    actions: <Widget>[
      new FlatButton(
        child: new Text('Add'),
        onPressed: () {
          navigateToSubPage(context);
        //  Navigator.pop(context);

 },
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// class of another page

Future navigateToSubPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SubPage()));
}

class SubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Confirmation'),
        backgroundColor: Colors.green,
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                height: 500,
                child: new Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio:
                          _cameraVideoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_cameraVideoPlayerController),
                    )
                  ],
                ),
              ),
              Spacer(),
              new Card(
                child: new Container(
                  padding: new EdgeInsets.all(32.0),
                  child: new Column(
                    children: <Widget>[
                      Text('Message'),
                      new Text(
                        _textFieldController.text,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              RaisedButton(
                elevation: 7.0,
                child: Text('SEND'),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child('myimage.mp3');
                  final StorageUploadTask task =
                      firebaseStorageRef.putFile(_cameraVideo);
                  showAlertDialog2(context);
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// secod alert box

showAlertDialog2(BuildContext context) {
  // Create AlertDialog
  AlertDialog alert2 = AlertDialog(
    title: Text('Thank You'),
    content: Text('Your Massage Is Succesfullly Submited!!'),
    actions: <Widget>[
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>DashboardPage()),
          );
        },
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert2;
    },
  );
}
