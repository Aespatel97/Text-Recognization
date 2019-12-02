import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:textrecognization/camera.dart';
import 'package:textrecognization/hello.dart';

void main() {
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickimage;
  List<String> texts = List();
  bool imageLoaded = false;
  var firstCamera;
  String text = "";
  Future pickImage() async {
    var tempstore = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      pickimage = tempstore;
      imageLoaded = true;
    });
  }

  @override
  void initState()   {
    super.initState();
    hetcamera();
  }

  hetcamera() async {
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;
  }

  Future readText() async {
    text = "";
    texts = [];
    FirebaseVisionImage ourimage = FirebaseVisionImage.fromFile(pickimage);
    TextRecognizer reconizetext = FirebaseVision.instance.textRecognizer();
    VisionText readtext = await reconizetext.processImage(ourimage);

    // for (TextBlock block in readtext.blocks) {
    //   print(block.lines[0].text);
    //   // print("++++++++++++++++${block.text.split(",").toList().length}");
    //   texts = block.text.split(",").toList();
    //   // print(texts);
    // }
     for (TextBlock block in readtext.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          // print(word.text);
          texts.add(word.text);
            text += word.text +" ";
            print(text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              pickimage != null
                  ? Center(
                      child: Container(
                        height: 450,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: FileImage(
                                pickimage,
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        height: 450,
                        width: 350,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Pick Image'),
                      ),
                    ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: MaterialButton(
                  color: Colors.blue,
                  minWidth: 150,
                  height: 50,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.transparent)),
                  elevation: 0.0,
                  child: Text(
                    'Pick an Image',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    texts = [];
                    pickImage().then((onValue) {
                      print(onValue.runtimeType);
                     
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //  text == ""? Offstage():Text(text,style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w300),),
              // SizedBox(
              //   height: 50,
              // ),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: MaterialButton(
                    color: Colors.blue,
                    minWidth: 150,
                    height: 50,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.transparent)),
                    elevation: 0.0,
                    child: Text(
                      'Read Texts',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                       if (pickimage != null) {
                        readText().then((onValue) {
                            Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowText(
                                    abc: text,
                                  )));
                        });
                      }
                    
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   height: 50,
              //   width: 150,
              //   decoration: BoxDecoration(
              //       color: Colors.blue,
              //       borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(10),
              //           bottomRight: Radius.circular(10))),
              //   child: MaterialButton(
              //       color: Colors.blue,
              //       minWidth: 150,
              //       height: 50,
              //       shape: OutlineInputBorder(
              //           borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(10),
              //               bottomRight: Radius.circular(10)),
              //           borderSide: BorderSide(color: Colors.transparent)),
              //       elevation: 0.0,
              //       child: Text(
              //         'Open Camera',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => TakePictureScreen(
              //                       camera: firstCamera,
              //                     )));
              //       }),
              // ),
              // if(!imageLoaded)...[
              //  Text('data'),
              //  Text('djhuv'),
              // ]else...[
              //  Text('object')
              // ],

              //  Padding(
              //    padding: const EdgeInsets.all(20.0),
              //    child: TextField(
              //     //  readOnly: true,
              //     cursorWidth: 15,
              //     onSubmitted: (sdc){
              //       print(sdc);

              //     },
              //     onTap: (){
              //       print('object');
              //     },
              //     textAlignVertical: TextAlignVertical.center,
              //     cursorRadius: Radius.circular(10),
              //     cursorColor: Colors.amberAccent,
              //      autocorrect: true,

              //    ),
              //  )
            ],
          ),
        ),
      ),
    );
  }
}
