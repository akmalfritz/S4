import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "dice",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: MyWidget(),
    ),
  ));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  int leftDiceNumber = 1;
  int rightDiceNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [

          Expanded(
            child: TextButton(
              onPressed: () {

                setState(() {
                  leftDiceNumber = Random().nextInt(6) + 1;
                });

                print("Left button got pressed");
              },

              child: Image.asset('images/dice$leftDiceNumber.png'),
            ),
          ),

          Expanded(
            child: TextButton(
              onPressed: () {

                setState(() {
                  rightDiceNumber = Random().nextInt(6) + 1;
                });

                print("Right button got pressed");
              },

              child: Image.asset('images/dice$rightDiceNumber.png'),
            ),
          ),

        ],
      ),
    );
  }
}