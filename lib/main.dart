import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Quiz(),
        ),
      ),
    ),
  ));
}

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<Widget> scoreKeeper = [];

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();
    
    setState(() {
      if (userPickedAnswer == correctAnswer) {
        scoreKeeper.add(Icon(
          Icons.check,
          color: Colors.green,
        ));
      } else {
        scoreKeeper.add(Icon(
          Icons.close,
          color: Colors.red,
        ));
      }

      if (quizBrain.isFinished()) {
        Alert(
          context: context,
          title: "SELESAI",
          desc: "Kamu sudah menyelesaikan quiz.",
          buttons: [
            DialogButton(
              child: Text(
                "ULANG QUIZ",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ), 
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  quizBrain.reset();
                  scoreKeeper = [];
                });
              },
            )
          ],
        ).show();
      } else {
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                )
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            checkAnswer(true);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.all(15),
            height: 100,
            width: double.infinity,
            child: Center(
              child: Text(
                "True",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            checkAnswer(false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.all(15),
            height: 100,
            width: double.infinity,
            child: Center(
              child: Text(
                "False",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}