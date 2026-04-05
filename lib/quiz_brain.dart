import 'questions.dart';

class QuizBrain {
  int _questionNumber = 0;

  List<Question> _questionBank = [
    Question(
      q: "Jika ijazah mas jack asli, kita harus curiga.", 
      a: false),
    Question(
      q: "Alasan kenapa banyak yang meragukan ijazah mas jack adalah karena mungkin saja bohong.", 
      a: true),
    Question(
      q: "Darah itu warnanya emas jendrall", 
      a: false),
  ];

  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    }
    print(_questionNumber);
    print(_questionBank.length);
  }

  void reset() {
    _questionNumber = 0;
  }

  String getQuestionText() {
    return _questionBank[_questionNumber].questionText;
  }

  bool getCorrectAnswer() {
    return _questionBank[_questionNumber].questionAnswer;
  }

  bool isFinished() {
    return _questionNumber >= _questionBank.length - 1;
  }
}