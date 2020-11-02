import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const int BOARD_SIZE = 8;
const int X = 1;
const int O = -1;
const int EMPTY = 0;
const int INF = 2000000000; // infinity

const Color EmptyCellColor = Colors.lightBlueAccent;
const CellColors = {X: Colors.black54, O: Colors.red};
const int thinkingDepth = 2;

class GamePage extends StatefulWidget {
  final String title;

  GamePage(this.title);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  List<List> board;
  int _currentPlayer;
  var _cnt;
  String _info;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _currentPlayer = X;
    board = List.generate(BOARD_SIZE, (i) => List.generate(BOARD_SIZE, (j) => 0));


    _put(3, 3, O);
    _put(3, 4, X);
    _put(4, 3, X);
    _put(4, 4, O);

    _cnt = {X: 2, O: 2};

    _info = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildBoard(),
        ),
      ),
    );
  }

  List<Widget> _buildBoard() {
    List<Widget> L = List<Widget>();
    for(int i=0; i<BOARD_SIZE; i++) {
      L.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildRow(i),
      ));
    }
    L.add(Container(
        margin: EdgeInsets.only(top: 20),
        child: Text('$_info', style: TextStyle(fontSize: 18),)
    ));
    return L;
  }

  List<Widget> _buildRow(int r) {
    List<Widget> L = List<Widget>();
    for(int i=0; i<BOARD_SIZE; i++) {
      L.add(_buildCell(r, i));
    }
    return L;
  }

  Widget _buildCell(int r, int c) {
    return GestureDetector(
      onTap: () => _handleTap(r, c),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: EmptyCellColor,
        ),
        child: _buildPeg(r, c),
      ),
    );
  }

  Widget _buildPeg(int r, int c) {
    if (board[r][c] == EMPTY)
      return null;
    return Container(
      decoration: BoxDecoration(
        color: CellColors[board[r][c]],
        shape: BoxShape.circle,
      ),
    );
  }

  void _put(int i, int j, int peg) {
    board[i][j] = peg;
  }

  _handleTap(int r, int c) {
    if (!_isValid(r, c, _currentPlayer)) return;

    setState(() {
      _move(r, c, _currentPlayer);
      var w = _winner();
      if (w == X || w == O) {
        String s = (w == X) ? "Black" : "Red";
        _info = "$s won";
      } else if (!_hasValidMove(-_currentPlayer)) {
        String current = (_currentPlayer == X) ? "Black" : "Red";
        String opponent = (_currentPlayer == X) ? "Red" : "Black";
        _info = "$opponent doesn't have a valid move! $current should play again!";
      } else {
        _currentPlayer = -_currentPlayer;
        _info = '';
      }
    });
  }

  bool _inRange(int x, int y) {
    return (x >= 0 && x < BOARD_SIZE && y >= 0 && y < BOARD_SIZE);
  }

  bool _isValid(int x, int y, int player) {
    if (!_inRange(x, y))  return false;
    if (board[x][y] != 0) return false;

    for(int dx=-1; dx<=1; dx++)
      for(int dy=-1; dy<=1; dy++) {
        var opponent = 0, self = false;
        for(int i=x+dx,j=y+dy; _inRange(i, j); i+=dx,j+=dy) {
          if (board[i][j] == 0) break;
          if (board[i][j] == player) {
            self = true;
            break;
          } else
            opponent++;
        }
        if (self && opponent > 0) return true;
      }
    return false;
  }

  bool _hasValidMove(int player) {
    // one of the players has no pegs left
    if (_cnt[X] == 0 || _cnt[O] == 0)
      return false;
    // there are no empty cells
    if (_cnt[X] + _cnt[O] == BOARD_SIZE*BOARD_SIZE)
      return false;

    for(int i=0; i<BOARD_SIZE; i++)
      for(int j=0; j<BOARD_SIZE; j++)
        if (board[i][j] == 0 && _isValid(i, j, player))
          return true;

     return false;
  }

  int _winner() {
    // if one of the players has a valid move, the game is not finished
    if (!_hasValidMove(X) && !_hasValidMove(O))
      return (_cnt[X] > _cnt[O] ? X : _cnt[X] < _cnt[O] ? O : 0);
    return INF;
  }


  void _move(int x, int y, int player) {
    board[x][y] = player;

    _cnt[player]++;
    for(int dx=-1; dx<=1; dx++)
      for(int dy=-1; dy<=1; dy++) {
        var opponent = 0, self = false;
        int i = x+dx, j = y+dy;
        for(; _inRange(i, j); i+=dx,j+=dy) {
          if (board[i][j] == 0) break;
          if (board[i][j] == player) { self = true; break; }
          else opponent++;
        }
        if ( self && opponent > 0 )
          for(int I=x+dx,J=y+dy; I!=i || J!=j; I+=dx,J+=dy) {
            board[I][J] = player;
            _cnt[X] += player;
            _cnt[O] -= player;
          }
      }
  }
}

