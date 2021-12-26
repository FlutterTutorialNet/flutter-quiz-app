import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/common/theme_helper.dart';
import 'package:flutter_quiz_app/models/quiz_history.dart';
import 'package:flutter_quiz_app/screens/quiz_screen.dart';
import 'package:flutter_quiz_app/stores/quiz_store.dart';
import 'package:flutter_quiz_app/widgets/disco_button.dart';
import 'package:flutter_quiz_app/widgets/screen_header.dart';

class QuizHistoryScreen extends StatefulWidget {
  static const routeName = '/quizHistory';
  const QuizHistoryScreen({Key? key}) : super(key: key);

  @override
  _QuizHistoryScreenState createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  List<QuizHistory> quizHistoryList = [];
  late QuizStore store;

  @override
  void initState() {
    store = QuizStore();
    store.loadQuizHistoryAsync().then((value) {
      setState(() {
        quizHistoryList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: Column(
            children: [
              ScreenHeader("Quiz History"),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List<QuizHistory>.from(quizHistoryList)
                        .map(
                          (e) => quizHistoryViewItem(e),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quizHistoryViewItem(QuizHistory quiz) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(10),
        decoration: ThemeHelper.roundBoxDeco(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 115,
                width: 10,
                child: Container(
                  decoration: ThemeHelper.roundBoxDeco(color: ThemeHelper.primaryColor, radius: 10),
                ),
              ),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  quiz.quizTitle.isEmpty ? "Question" : quiz.quizTitle,
                  style: TextStyle(fontSize: 24),
                ),
                Text("Score: ${quiz.score}",
                    style: TextStyle(color: ThemeHelper.accentColor, fontSize: 18)),
                Text("Time Taken: ${quiz.timeTaken}"),
                Text(
                    "Date: ${quiz.quizDate.year}-${quiz.quizDate.month}-${quiz.quizDate.day} ${quiz.quizDate.hour}:${quiz.quizDate.minute}"),
              ]),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                DiscoButton(
                    width: 100,
                    height: 50,
                    onPressed: () {
                      store.getQuizByIdAsync(quiz.quizId, quiz.categoryId).then((value) {
                        if (value != null) {
                          Navigator.pushReplacementNamed(context, QuizScreen.routeName,
                              arguments: value);
                        } else {}
                      });
                    },
                    child: Text("Start Again")),
              ],
            )
          ],
        ));
  }
}
