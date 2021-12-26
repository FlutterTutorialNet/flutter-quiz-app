import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/common/extensions.dart';
import 'package:flutter_quiz_app/common/theme_helper.dart';
import 'package:flutter_quiz_app/models/dto/option_selection.dart';
import 'package:flutter_quiz_app/models/dto/quiz_result.dart';
import 'package:flutter_quiz_app/models/option.dart';
import 'package:flutter_quiz_app/models/question.dart';
import 'package:flutter_quiz_app/models/quiz.dart';
import 'package:flutter_quiz_app/models/quiz_history.dart';
import 'package:flutter_quiz_app/screens/quiz_result_screen.dart';
import 'package:flutter_quiz_app/services/quiz_engine.dart';
import 'package:flutter_quiz_app/stores/quiz_store.dart';
import 'package:flutter_quiz_app/widgets/disco_button.dart';
import 'package:flutter_quiz_app/widgets/question_option.dart';
import 'package:flutter_quiz_app/widgets/time_indicator.dart';

class QuizScreen extends StatefulWidget {
  static const routeName = '/quiz';
  late Quiz quiz;
  QuizScreen(this.quiz, {Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState(quiz);
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  late QuizEngine engine;
  late QuizStore store;
  late Quiz quiz;
  Question? question;
  Timer? progressTimer;
  AppLifecycleState? state;

  int _remainingTime = 0;
  Map<int, OptionSelection> _optionSerial = {};

  _QuizScreenState(this.quiz) {
    store = QuizStore();
    engine = QuizEngine(quiz, onNextQuestion, onQuizComplete, onStop);
  }

  @override
  void initState() {
    engine.start();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    this.state = state;
  }

  @override
  void dispose() {
    if (progressTimer != null && progressTimer!.isActive) {
      progressTimer!.cancel();
    }
    engine.stop();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                screenHeader(),
                quizQuestion(),
                questionOptions(),
                quizProgress(),
                footerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget screenHeader() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        quiz.title,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget quizQuestion() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 10),
      decoration: ThemeHelper.roundBoxDeco(),
      child: Text(
        question?.text ?? "",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget questionOptions() {
    return Container(
      alignment: Alignment.center,
      decoration: ThemeHelper.roundBoxDeco(),
      child: Column(
        children: List<Option>.from(question?.options ?? []).map((e) {
          int optionIndex = question!.options.indexOf(e);
          var optWidget = GestureDetector(
            onTap: () {
              setState(() {
                engine.updateAnswer(quiz.questions.indexOf(question!), optionIndex);
                for (int i = 0; i < _optionSerial.length; i++) {
                  _optionSerial[i]!.isSelected = false;
                }
                _optionSerial.update(optionIndex, (value) {
                  value.isSelected = true;
                  return value;
                });
              });
            },
            child: QuestionOption(
              optionIndex,
              _optionSerial[optionIndex]!.optionText,
              e.text,
              isSelected: _optionSerial[optionIndex]!.isSelected,
            ),
          );
          return optWidget;
        }).toList(),
      ),
    );
  }

  Widget quizProgress() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TimeIndicator(
              question?.duration ?? 1,
              _remainingTime,
              () {},
            ),
          ),
          Text(
            "$_remainingTime Seconds",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget footerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DiscoButton(
          onPressed: () {
            setState(() {
              engine.stop();
              if (progressTimer != null && progressTimer!.isActive) {
                progressTimer!.cancel();
              }
            });
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: 20),
          ),
          width: 130,
          height: 50,
        ),
        DiscoButton(
          onPressed: () {
            engine.next();
          },
          child: Text(
            "Next",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          isActive: true,
          width: 130,
          height: 50,
        ),
      ],
    );
  }

  void onNextQuestion(Question question) {
    setState(() {
      if (progressTimer != null && progressTimer!.isActive) {
        _remainingTime = 0;
        progressTimer!.cancel();
      }

      this.question = question;
      _remainingTime = question.duration;
      _optionSerial = {};
      for (var i = 0; i < question.options.length; i++) {
        _optionSerial[i] = OptionSelection(String.fromCharCode(65 + i), false);
      }
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime >= 0) {
        try {
          if (mounted) {
            setState(() {
              progressTimer = timer;
              _remainingTime--;
            });
          }
        } catch (ex) {
          timer.cancel();
          print(ex.toString());
        }
      }
    });
  }

  void onQuizComplete(Quiz quiz, double total, Duration takenTime) {
    if (mounted) {
      setState(() {
        _remainingTime = 0;
      });
    }
    progressTimer!.cancel();
    store.getCategoryAsync(quiz.categoryId).then((category) {
      store
          .saveQuizHistory(QuizHistory(quiz.id, quiz.title, category.id,
              "$total/${quiz.questions.length}", takenTime.format(), DateTime.now(), "Complete"))
          .then((value) {
        Navigator.pushReplacementNamed(context, QuizResultScreen.routeName,
            arguments: QuizResult(quiz, total));
      });
    });
  }

  void onStop(Quiz quiz) {
    _remainingTime = 0;
    progressTimer!.cancel();
  }
}
