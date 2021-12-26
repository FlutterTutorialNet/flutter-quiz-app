import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  final String backBtnImagePath;
  final String headerText;

  const ScreenHeader(this.headerText, {Key? key, this.backBtnImagePath = "assets/icons/back.png"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            child: Image(
              image: AssetImage(backBtnImagePath),
              width: 40,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            headerText,
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
