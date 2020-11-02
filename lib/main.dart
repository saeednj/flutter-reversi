import 'package:flutter/material.dart';
import 'package:reversi/game_page.dart';

String title = "Reversi";

void main() {
  runApp(Reversi());
}

class Reversi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: title),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Welcome to Reversi", style: TextStyle(fontSize: 24),),
          Center(
            child: RaisedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GamePage(widget.title))
                );
              },
              color: Colors.amber,
              child: Text("New Game", style: TextStyle(fontSize: 24),),
            ),
          )
        ],
      ),
    );
  }
}
