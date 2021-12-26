import 'package:flutter/material.dart';

typedef OnButtonPressed = void Function();

class DiscoButton extends StatelessWidget {
  final OnButtonPressed onPressed;
  final Widget child;
  final Color buttonColor;
  late final PaintingStyle paintStyle;
  final bool isActive;
  double width;
  double height;

  DiscoButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.width = 250.0,
      this.height = 100.0,
      this.buttonColor = const Color(0xff6758C0),
      this.isActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: CustomPaint(
          painter: DiscoPainter(buttonColor, isActive),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: height * 0.15),
            child: child,
          ),
        ),
      ),
    );
  }
}

class DiscoPainter extends CustomPainter {
  final Color color;
  final bool isActive;

  DiscoPainter(this.color, this.isActive);

  @override
  void paint(Canvas canvas, Size size) {
    var paintStyle = isActive ? PaintingStyle.fill : PaintingStyle.stroke;
    Paint paint = Paint()
      ..color = color
      ..style = paintStyle
      ..strokeWidth = 4.0;

    Path path = Path();
    path.moveTo(size.width * 0.1230000, size.height * 0.9820000);
    path.cubicTo(
        size.width * 0.0247500,
        size.height * 0.9872000,
        size.width * -0.0152500,
        size.height * 0.7960000,
        size.width * 0.0130000,
        size.height * 0.6140000);
    path.cubicTo(
        size.width * 0.0745200,
        size.height * 0.1936600,
        size.width * 0.0645000,
        size.height * -0.0162000,
        size.width * 0.1940000,
        size.height * 0.0400000);
    path.cubicTo(
        size.width * 0.3775000,
        size.height * 0.1120000,
        size.width * 0.6961800,
        size.height * 0.2413000,
        size.width * 0.8866800,
        size.height * 0.3113000);
    path.cubicTo(
        size.width * 0.9756800,
        size.height * 0.3491000,
        size.width * 1.0134700,
        size.height * 0.3731600,
        size.width * 0.9948700,
        size.height * 0.6933600);
    path.cubicTo(
        size.width * 0.9963200,
        size.height * 0.9812600,
        size.width * 0.9665500,
        size.height * 0.9809000,
        size.width * 0.9140000,
        size.height * 0.9800000);
    path.cubicTo(
        size.width * 0.7215000,
        size.height * 0.9805000,
        size.width * 0.7005000,
        size.height * 0.9805000,
        size.width * 0.1230000,
        size.height * 0.9820000);
    path.close();

    if (isActive) {
      canvas.drawShadow(path, color, 8, true);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
