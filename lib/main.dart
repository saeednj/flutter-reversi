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
  String difficulty;

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
          DropdownButton<String>(
            value: difficulty,
            onChanged: (String newValue) {
              setState(() {
                difficulty = newValue;
              });
            },
            items: <String>['Easy', 'Medium', 'Hard']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text('Select AI Level'),
          ),
          Center(
            child: RaisedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GamePage(title: widget.title, difficulty: difficulty)
                    )
                );
              },
              color: Colors.greenAccent,
              child: Text("New Game", style: TextStyle(fontSize: 24),),
            ),
          )
        ],
      ),
    );
  }
}
