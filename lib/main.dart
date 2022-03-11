import 'dart:convert';
import 'dart:math';
//import 'drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'piano.dart';

void main() {
  runApp(MyApp());

}

//chords.txt
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.indigo,// Colors.blue,
        ),
        home: LoaderOverlay(
          child: MyHomePage(title: 'Learn music chords'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //var drawer = get_drawer();
  //loaderOverlay.show();
  var error = false;
  var response;
  var loadingProgress;
  //var ch_player= chords_player().play();
  //ch_player.play();
  int _counter = 0;
  int _right = 0;
//  var right_one = 0;
//  var some_chord = 0;
  var chords;
  var filter = "base";
  late Future<List> keys;
  var all_chords = [];
  var base_chords = [];
  var sept_chords = [];
  var nine_chords = [];

  Future<List> _fetchData() async {
    // buttons.clear();
    //chords_player().play();
    var keys = [];
    //keys.clear();
    print("hello");
    final url =
    // Uri.parse("http://1.u0156265.z8.ru/old/chord_images/chords.txt");
    //Uri.parse("http://1.u0156265.z8.ru/old/chord_images/checked_chords.txt");
    Uri.parse("http://1.u0156265.z8.ru/old/chords_easy/chords.json");
   // Uri.parse("http://1.u0156265.z8.ru/old/pianochords/www.pianochord.org/panfilius.json");
    final response = await http.get(url);
    //print(response);
    if (response.statusCode == 200) {
      print("200");
      print(response.body);
      print("okey");
      final map = json.decode(response.body);
      final playersJson = map;
      print(map);
      //  _isLoading = false;
      this.chords = playersJson;
      // this._counter = this.chords[0].length;
      var counter = 0;
      var condition = false;

      chords.forEach((k, v)
          {
            print(v);
        keys.add(k);
      });
     // keys.add(chords);
      return await keys;
    } else {
      print("bad");
      return ["Am"];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //  context.loaderOverlay.show();
    print('init_state');

    this.keys = _fetchData();
    super.initState();
  }

  bool check(x) {
    var numbers = ["1", "3", "4", "5", "6", "7", "9"];
    print(numbers);
    print(filter +
        x +
        (x.length <= 3 && !numbers.contains(x[x.length - 1])).toString());
    var condition;
    if (filter == "base") {
      condition = (!x.contains("/") && x.length <= 3 && !numbers.contains(x[x.length - 1]));
    }
    if (filter == "0") {
      condition = true;
    }
    if (x[x.length - 1] == filter || condition == true) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    print('hello');
    //create_buttons();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack( children: <Widget>[
        Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(

                child: Text( (_counter == 0) ? "0" : ((_right/_counter)*100).floor().toString()+"%"),
                onPressed: (){
                  setState(() {
                    _counter=0;
                    _right=0;
                  });

                })),
        Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  FutureBuilder<List>(
                      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                          print(snapshot.data);
                        if (snapshot.hasData) {
                          context.loaderOverlay.hide();
                          print(this.chords);
                          print("chords???");
                          var inner_chords = [];
                          //print(chords);
                          //print(this.keys);
                          //print(chords);
                          var final_keys=snapshot.data!;

                          print("<<");
                          final_keys.forEach((element) {
                            print(element);
                          //  if (check(element)) {
                              //print("el:"+element[2]);
                              inner_chords.add(element);
                           // }
                          });
                          print("inner??");
                          print(inner_chords);
                          var some_chord = new Random().nextInt(inner_chords.length);

                          var ch = inner_chords[some_chord];
                          var ch_path= ch;
                          var url;
                            url ='http://1.u0156265.z8.ru/old/chords_easy/'+this.chords[final_keys[some_chord]][2];
                          print(url);
                         // else { url =
                          print(ch_path);
                          var buttons = create_buttons(inner_chords, some_chord);

                          return Column(children: [
/*
                            Center(child: Image.network(''
                                'https://www.pianochord.org/images/'+
                                ch.toLowerCase().replaceAll("b","_flat").
                                replaceAll("#","_sharp")+'.png')
                            ),*//*
                      Center(
                        child:
                          FadeInImage.assetNetwork(
                            imageErrorBuilder: (BuildContext context, Object exception, StackTrace? s) {
                            error = true;
                            send_error(
                                ch.replaceAll("#", "flat") +
                                '_img.png');
                           // WidgetsBinding.instance!.addPostFrameCallback(() => setState((){}));
                            return Text("cant find image");
                            },
                            placeholder: 'images/empty_img.png',
                            image: 'http://1.u0156265.z8.ru/old/t_images/chords3/' +
                                ch.replaceAll("#", "flat") +
                                '_img.png',
                          )
                      ),*/

                            Container(

                                child:  GestureDetector(
                          onTap: () {create_buttons(inner_chords, some_chord); },
                              child: Image.network(
                                url,
                                gaplessPlayback: true,
                                fit: BoxFit.contain,
                              ))),
                            Container(
                                padding: EdgeInsets.all(20),
                                child: Wrap(children: buttons))
                          ]);
                        } else
                          return Text("loading");
                      },
                      future: this.keys),
                ]))]),
      //bottomNavigationBar: Text("bottom"),
      /* persistentFooterButtons: [Center(
            child: Wrap(
                children: [
                  FloatingActionButton.extended(onPressed: () {
                    this.filter = "5";
                  },
                      label: Text("Base chords?")),
                  FloatingAextended(onPressed: () {
                    // _fetchData();
                    setState(() {
                      print('refresh?');
                      //   _fetchData();
                    });
                  },
                      label: Text("All chords")),
                ]
            ))
        ], */
      drawer: get_drawer(),
    );

    // This trailing comma makes auto-formatting nicer for build methods.
  }
  nice_string(ch)
  {
    var nice_string = ch.toLowerCase().replaceAll("#", "-sharp");
    nice_string.replaceAll('db','d-flat');
    nice_string.replaceAll('eb','e-flat');
    nice_string.replaceAll('gb','g-flat');
    nice_string.replaceAll('ab','a-flat');
    nice_string.replaceAll('bb','b-flat');
    nice_string.replaceAll('db','d-flat');

    if ( nice_string.indexOf("flat")!=(-1) && nice_string.substring(nice_string.length - 5)!="t.png")
    {
      nice_string.replaceAll("flat","flat-");
    }

    if ( nice_string.indexOf("sharp")!=(-1) && nice_string.substring(nice_string.length - 5)!="p.png")
      {
          nice_string.replaceAll("sharp","sharp-");
      }
return nice_string;
  }
  create_buttons(keys, some_chord) {
    chords_player().play(keys[some_chord]);
    var started_from_chords = [];
    keys.forEach((element) {
      if (element[0] == keys[some_chord][0]) // strings beginning same?
          {
        started_from_chords.add(element);
      }
    }); //return true;
    print("buttons");
    List<FloatingActionButton> buttons = [];
    print(started_from_chords);
    started_from_chords.shuffle();
    var color;
    var texts = [];
    var len = started_from_chords.length;
    if (len > 5) {
      len = 4;
    }
    for (var i = 0; i < len; i++) {
      //print(i);
      // r = Random().nextInt(started_from_chords.length);
      print(some_chord);
      var text = started_from_chords[i];
      print(text);
      texts.add(text);

      if (text == keys[some_chord] && 1==2) {
        //_counter++;
        color = Colors.green;
      } else {
        color = Colors.blue;
      }
      buttons.add(FloatingActionButton.extended(
        //backgroundColor: color,
        //  isExtended: true,
          elevation: 10.0,
          label: Text(text),
          onPressed: () {

            // print("pressed"+this.);
            setState(() {
              _counter++;
              if( text == keys[some_chord]) { _right++;
              Fluttertoast.showToast(
                  msg: text+" was right",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              }
              else {
                Fluttertoast.showToast(
                    msg: text+" was wrong",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
              print('refresh?');
              print('I am Floating button');
            });
            //  _fetchData();
          }));
    }
    if (texts.contains(keys[some_chord]) == false) {
      buttons.add(FloatingActionButton.extended(
        //backgroundColor: Colors.green,
        //  isExtended: true,
          elevation: 10.0001,
          label: Text(keys[some_chord]),
          onPressed: () {

            setState(() {
              _right++; _counter++;
              print('refresh?');
              print('I am Floating button');
            });
            //  _fetchData();
          }));
    }

    buttons.shuffle();
    for (var j = 0; j < buttons.length; j++) {
      //  if ( buttons[j].elevation == 10.0001 ) { right_one = j;  }

    }
    return buttons;
//    this.buttons = buttons;
  }

  get_drawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          _createHeader(),
          _createDrawerItem(
              icon: Icons.audiotrack,
              text: 'Base chords (Am, A)',
              onTap: () {
                setState(() {
                  this.filter = "base";
                  Navigator.pop(context);
                }); } ),
        /*  _createDrawerItem(
              icon: Icons.audiotrack,
              text: 'All chords',
              onTap: () {
                setState(() {
                  this.filter = "0";
                  Navigator.pop(context);
                }); } ),
          _createDrawerItem(
            icon: Icons.audiotrack,
            text: '7-th chords ( Am7 )',
            onTap: () {
              setState(() {
                this.filter = "7";
                Navigator.pop(context);
              });
            },
          ),
          _createDrawerItem(
            icon: Icons.audiotrack,
            text: 'power chords ( Am5 )',
            onTap: () {
              setState(() {
                this.filter = "5";
                Navigator.pop(context);
              });
            },
          ),
          _createDrawerItem(
            icon: Icons.audiotrack,
            text: '9th chords ( Am9 )',
            onTap: () {
              setState(() {
                this.filter = "9";
                Navigator.pop(context);
              });
            },
          ),
          _createDrawerItem(
            icon: Icons.audiotrack,
            text: 'Inverstions',
            onTap: () {
              setState(() {
                this.filter = "Am/C";
                Navigator.pop(context);
              });
            },
          ),*/
        ],
      ),
    );
  }
  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("images/piano.gif"))),
        //   AssetImage('piano.gif'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Learn piano chords",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }
  Widget _createDrawerItem(
      {required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
send_error(e) {
  print(e);

  return http.post(
      Uri.parse('http://1.u0156265.z8.ru/old/music_errors.php?error='+e),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
  );

}