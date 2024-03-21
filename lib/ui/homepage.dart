import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/models/blank_pixel.dart';
import 'package:snake_game/models/food_pixel.dart';

import '../models/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //Game start
  bool hasGameStarted = false;

  //Game pause
  bool isGamePaused = false;

  //players score
  int playerHighScore = 0;

  //grid dimensions
  int rowSize = 10;
  int totalNumberofSquares = 100;

  //snake position
  List<int> snakePosition = [0, 1, 2];

  //snake direction is initially to the right
  var currentDirection = snake_Direction.RIGHT;

  //food position
  int foodPosition = 55;

  //move the snake
  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          //add a new head

          snakePosition.last % rowSize == rowSize - 1
              ? snakePosition
                  .add(snakePosition.last - (snakePosition.last % rowSize))
              : snakePosition.add((snakePosition.last + 1));

          //remove the tail
          //snakePosition.remove(snakePosition.removeAt(0));
        }
        break;
      case snake_Direction.LEFT:
        {
          //add a new head

          snakePosition.last % rowSize == 0
              ? snakePosition.add(snakePosition.last + (rowSize - 1))
              : snakePosition.add(snakePosition.last - 1);

          //remove the tail
          //snakePosition.remove(snakePosition.removeAt(0));
        }
        break;
      case snake_Direction.UP:
        {
          //add a new head
          snakePosition.add(
              (snakePosition.last - rowSize + totalNumberofSquares) %
                  totalNumberofSquares);

          //remove the tail
          //snakePosition.remove(snakePosition.removeAt(0));
        }
        break;
      case snake_Direction.DOWN:
        {
          //add a new head
          snakePosition
              .add((snakePosition.last + rowSize) % totalNumberofSquares);
        }
        break;
      default:
    }
    //eat the food
    if (snakePosition.last == foodPosition) {
      eatFood();
    } else {
      //remove the tail
      snakePosition.remove(snakePosition.removeAt(0));
    }
  }

  //Eat the food
  void eatFood() {
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalNumberofSquares);
      setState(() {
        playerHighScore++;
      });
    }
  }

  //Initialize game
  void initGame() {
    setState(() {
      playerHighScore = 0;
      snakePosition = [0, 1, 2];
      currentDirection = snake_Direction.RIGHT;
      hasGameStarted = false;
    });
  }

  //Start the game
  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        //move the snake
        moveSnake();

        if (isGamePaused) {
          timer.cancel();
        }

        if (gameOver()) {
          timer.cancel();
          //display message

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Game Over"),
                  content: Text("Your score is: $playerHighScore"),
                );
              });
        }
      });
    });
  }

  void pauseGame() {
    setState(() {
      isGamePaused = true;
    });
  }

  void resumeGame() {
    setState(() {
      isGamePaused = false;
      startGame();
    });
  }

  //game over
  bool gameOver() {
    List<int> snakeBody = snakePosition.sublist(0, snakePosition.length - 1);
    if (snakeBody.contains(snakePosition.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    //get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (event) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
              currentDirection != snake_Direction.UP) {
            currentDirection = snake_Direction.DOWN;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
              currentDirection != snake_Direction.DOWN) {
            currentDirection = snake_Direction.UP;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              currentDirection != snake_Direction.RIGHT) {
            currentDirection = snake_Direction.LEFT;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
              currentDirection != snake_Direction.LEFT) {
            currentDirection = snake_Direction.RIGHT;
          }
        },
        child: SizedBox(
          width: screenWidth > 400 ? 400 : screenWidth,
          child: Column(
            children: [
              //high scores
              Expanded(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "player name",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        "Score : $playerHighScore",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      )
                    ],
                  ),
                ),
              )),

              // Game grid
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 0 &&
                          currentDirection != snake_Direction.UP) {
                        currentDirection = snake_Direction.DOWN;
                      } else if (details.delta.dy < 0 &&
                          currentDirection != snake_Direction.DOWN) {
                        currentDirection = snake_Direction.UP;
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0 &&
                          currentDirection != snake_Direction.LEFT) {
                        currentDirection = snake_Direction.RIGHT;
                      } else if (details.delta.dx < 0 &&
                          currentDirection != snake_Direction.RIGHT) {
                        currentDirection = snake_Direction.LEFT;
                      }
                    },
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: rowSize),
                        itemCount: totalNumberofSquares,
                        itemBuilder: (context, index) {
                          if (snakePosition.contains(index)) {
                            return SnakePixel(index: index);
                          } else if (index == foodPosition) {
                            return FoodPixel(index: index);
                          } else {
                            return BlankPixel(index: index);
                          }
                        }),
                  )),

              //play button
              Expanded(
                  child: Container(
                child: Center(
                  child: gameOver()
                      ? Center(
                          child: MaterialButton(
                            child: Text("RESTART"),
                            color: Colors.deepOrangeAccent,
                            onPressed: initGame,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              child: Text("PLAY"),
                              color:
                                  hasGameStarted ? Colors.grey : Colors.green,
                              onPressed: hasGameStarted ? () {} : startGame,
                            ),
                            !isGamePaused
                                ? MaterialButton(
                                    child: Text("PAUSE"),
                                    color: Colors.purple,
                                    onPressed: pauseGame,
                                  )
                                : MaterialButton(
                                    onPressed: resumeGame,
                                    child: Text("RESUME"),
                                    color: Colors.blueAccent,
                                  ),
                          ],
                        ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
