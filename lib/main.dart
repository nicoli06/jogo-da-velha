import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha Colorido',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String result = '';
  bool isSinglePlayer = false;

  void _handleTap(int index) {
    if (board[index].isEmpty && result.isEmpty) {
      setState(() {
        board[index] = currentPlayer;
        if (_checkWinner()) {
          result = '$currentPlayer venceu!';
        } else if (!board.contains('')) {
          result = 'Empate!';
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          if (isSinglePlayer && currentPlayer == 'O') {
            _computerMove();
          }
        }
      });
    }
  }

  void _computerMove() {
    List<int> emptyIndices = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        emptyIndices.add(i);
      }
    }
    if (emptyIndices.isNotEmpty) {
      int randomIndex = emptyIndices[Random().nextInt(emptyIndices.length)];
      _handleTap(randomIndex);
    }
  }

  bool _checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == currentPlayer &&
          board[pattern[1]] == currentPlayer &&
          board[pattern[2]] == currentPlayer) {
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: board[index] == 'X' ? Colors.blue[50] : board[index] == 'O' ? Colors.red[50] : Colors.pink[50],
                  ),
                  child: Center(
                    child: Text(
                      board[index],
                      style: TextStyle(
                        fontSize: 40,
                        color: board[index] == 'X' ? Colors.blue : board[index] == 'O' ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Text(
            result,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Reiniciar Jogo'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isSinglePlayer = !isSinglePlayer;
                _resetGame();
              });
            },
            child: Text(isSinglePlayer ? 'Jogar Manual' : 'Jogar Contra o Computador'),
          ),
        ],
      ),
    );
  }
}
