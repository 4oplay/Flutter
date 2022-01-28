// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'bomb.dart';
import 'numberbox.dart';
import 'dart:math';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // grid variables
  int numberInEachRow = 13;
  int numberOfMinSnacks = 30;
  int numberOfMaxSnacks = 31;
  // time variables
  Timer? timer;
  Duration bestTime = Duration();
  Duration currentTime = Duration();

  // [ number of bombs around , revealed = true / false ]
  var squareStatus = [];

  // bomb locations
  var rng = Random();
  int numberOfBombs = 0;
  List<int> bombLocation = [];
  List<String> winString = [
    "W I N N E R !",
    "R O C K S T A R !",
    "S N A C K T I M E !"
  ];
  List<String> loseString = ["H U N G R Y ?", "A G A I N ?", "B O M B E D ?"];
  bool bombsRevealed = false;

  get aspectRatio => null;

  @override
  void initState() {
    super.initState();
    // initially, each square has 0 bombs around, and is not revealed
    for (int i = 0; i < numberInEachRow * numberInEachRow; i++) {
      squareStatus.add([0, false]);
    }
    newGame();
  }

  void replaceBombs() {
    setState(() {
      numberOfBombs = rng.nextInt(numberOfMaxSnacks - numberOfMinSnacks) +
          numberOfMinSnacks;
      bombLocation = List.generate(
          numberOfBombs, (_) => rng.nextInt(numberInEachRow * numberInEachRow));
    });
  }

  void newGame() {
    replaceBombs();
    scanBombs();
    currentTime = Duration();
    setState(() => timer?.cancel());
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = currentTime.inSeconds + addSeconds;
      currentTime = Duration(seconds: seconds);
    });
  }

  void newRecord() {
    setState(() {
      final currentSeconds = currentTime.inSeconds;
      final bestSeconds = bestTime.inSeconds;
      if (bestSeconds > currentSeconds || bestSeconds==0) {
        bestTime = Duration(seconds: currentSeconds);
      }
    });
  }

  void restartGame() {
    newGame();
    setState(() {
      bombsRevealed = false;
      for (int i = 0; i < numberInEachRow * numberInEachRow; i++) {
        squareStatus[i][1] = false;
      }
    });
  }

  void revealBoxNumbers(int index) {
    // reveal current box if it is a number: 1,2,3 etc
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
    }

    // if current box is 0
    else if (squareStatus[index][0] == 0) {
      // reveal current box, and the 8 surrounding boxes, unless you're on a wall
      setState(() {
        // reveal current box
        squareStatus[index][1] = true;

        // reveal left box (unless we are currently on the left wall)
        if (index % numberInEachRow != 0) {
          // if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }

          // reveal left box
          squareStatus[index - 1][1] = true;
        }

        // reveal top left box (unless we are currently on the top row or left wall)
        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }

          squareStatus[index - 1 - numberInEachRow][1] = true;
        }

        // reveal top box (unless we are on the top row)
        if (index >= numberInEachRow) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }

          squareStatus[index - numberInEachRow][1] = true;
        }

        // reveal top right box (unless we are on the top row or the right wall)
        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }

          squareStatus[index + 1 - numberInEachRow][1] = true;
        }

        // reveal right box (unless we are on the right wall)
        if (index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }

          squareStatus[index + 1][1] = true;
        }

        // reveal bottom right box (unless we are on the bottom row or the right wall)
        if (index < numberInEachRow * numberInEachRow - numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 + numberInEachRow);
          }

          squareStatus[index + 1 + numberInEachRow][1] = true;
        }

        // reveal bottom box (unless we are on the bottom row)
        if (index < numberInEachRow * numberInEachRow - numberInEachRow) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }

          squareStatus[index + numberInEachRow][1] = true;
        }

        // reveal bottom left box (unless we are on the bottom row or the left wall)
        if (index < numberInEachRow * numberInEachRow - numberInEachRow &&
            index % numberInEachRow != 0) {
          // if next box isn't revealed yet and is a 0, then recurse
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 + numberInEachRow);
          }

          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberInEachRow * numberInEachRow; i++) {
      // there are no bombs around initially
      int numberOfBombsAround = 0;

      /*

      check each square to see if it has bombs surrounding it,
      there are 8 surrounding boxes to check

      */

      // check square to the left, unless it is in the first column
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      // check square to the top left, unless it is in the first column or first row
      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the top, unless it is in the first row
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the top right, unless it is in the first row or last column
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      // check square to the right, unless it is in the last column
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      // check square to the bottom right, unless it is in the last column or last row
      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberInEachRow * numberInEachRow - numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the bottom, unless it is in the last row
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberInEachRow * numberInEachRow - numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the bottom left, unless it is in the last row or first column
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i < numberInEachRow * numberInEachRow - numberInEachRow &&
          i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      // add total number of bombs around to square status
      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost() {
    setState(() => timer?.cancel());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.pink[800],
            title: Center(
              child: Text(
                loseString[rng.nextInt(loseString.length)],
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              MaterialButton(
                  color: Colors.grey[100],
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.refresh))
            ],
          );
        });
  }

  void playerWon() {
    setState(() => timer?.cancel());
    newRecord();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.pink[800],
            title: Center(
              child: Text(
                winString[rng.nextInt(winString.length)],
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              Center(
                child: MaterialButton(
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.refresh, size: 30))),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void checkWinner() {
    // check how many boxes yet to reveal
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberInEachRow * numberInEachRow; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }

    // if this number is the same as the number of bombs, then player WINS!
    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // game stats and menu
          // branding
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child:
                Text('S N A C K S W E E P E R', style: TextStyle(fontSize: 20)),
          ),
          Container(
            height: 100,
            //color: Colors.grey,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // display number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bombLocation.length.toString(),
                        style: TextStyle(fontSize: 40)),
                    Text('S N A C K S'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentTime.inSeconds.toString(),
                        style: TextStyle(fontSize: 40)),
                    Text('T I M E'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bestTime.inSeconds.toString(),
                        style: TextStyle(fontSize: 40)),
                    Text('R E C O R D'),
                  ],
                ),
              ],
            ),
          ),

          // grid
          Expanded(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: numberInEachRow * numberInEachRow,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: numberInEachRow),
                        itemBuilder: (context, index) {
                          if (bombLocation.contains(index)) {
                            return MyBomb(
                              revealed: bombsRevealed,
                              function: () {
                                setState(() {
                                  bombsRevealed = true;
                                });
                                playerLost();
                                // player tapped the bomb, so player loses
                              },
                            );
                          } else {
                            return MyNumberBox(
                              child: squareStatus[index][0],
                              revealed: squareStatus[index][1],
                              function: () {
                                // reveal current box
                                revealBoxNumbers(index);
                                checkWinner();
                              },
                            );
                          }
                        }),
                  ))),
          Container(
            height: 100,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // display number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: restartGame,
                      child: Card(
                        child:
                            Icon(Icons.refresh, color: Colors.white, size: 40),
                        color: Colors.pink[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // branding
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text('- J J  G A M I N G -'),
          )
        ],
      ),
    );
  }
}
