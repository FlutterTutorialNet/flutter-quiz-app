import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/common/theme_helper.dart';

class TimeIndicator extends StatelessWidget {
  final int duration;
  final VoidCallback onComplete;
  final double width;
  final double height;
  final int progress;
  double borderWidth = 4;

  TimeIndicator(this.duration, this.progress, this.onComplete,
      {Key? key, this.width = 300, this.height = 25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var percent = ((progress / duration) * 100) / 100;
    var innerWidth = ((width * percent) - borderWidth * 2);
    var innerHeight = height - borderWidth * 2;
    if (innerWidth < 0) {
      innerWidth = 0;
    }
    if (innerHeight < 0) {
      innerHeight = 0;
    }
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(height * 0.50)),
            border:
                Border.all(width: borderWidth, color: ThemeHelper.primaryColor),
          ),
        ),
        Container(
          width: innerWidth,
          height: innerHeight,
          margin: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(height * 0.50)),
              border: Border.all(width: 5, color: ThemeHelper.accentColor),
              color: ThemeHelper.accentColor),
        ),
      ],
    );
  }
}

/*
class _TimeIndicatorState extends State<TimeIndicator> {
  int duration;
  VoidCallback onComplete;
  double width;
  double height;
  double borderWidth = 4;
  int progress;

  _TimeIndicatorState(
      this.duration, this.progress, this.onComplete, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    var percent = (duration * progress) / 100;
    print(percent);
    var innerWidth = (width - borderWidth) * (percent);
    var innerHeight = height - borderWidth * 2;

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(height * 0.50)),
            border:
                Border.all(width: borderWidth, color: ThemeHelper.primaryColor),
          ),
        ),
        Container(
          width: innerWidth,
          height: innerHeight,
          margin: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(height * 0.50)),
              border: Border.all(width: 5, color: ThemeHelper.accentColor),
              color: ThemeHelper.accentColor),
        ),
      ],
    );
  }
}
*/
