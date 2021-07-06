import 'dart:math';
import 'package:flutter/material.dart';

class WorkoutCompletionRing extends StatelessWidget {
  const WorkoutCompletionRing({Key key,@required this.progress}) : super(key: key);
  final double progress;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // so hat das ParentWidget die gleiche Breite und Höhe => gut für Kriese
      child: CustomPaint(
        painter: RectPainter(
          progress: progress
        ),
      ),
    );
  }
}


class RectPainter extends CustomPainter {
  RectPainter({@required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final notCompleted = progress < 1.0;
    final strokeWidth = 20.0; // dynamische Widgetgröße möglich
    final rect = Rect.fromLTRB(20.0, 100.0, 20.0, 100.0);
    //final center = Offset(size.width/2, size.height/2);
    //final radius = notCompleted ? (size.width - strokeWidth) / 2 : size.width / 2;
    /*
    if (notCompleted) {
      final backgroundPaint = Paint()
        ..isAntiAlias = true // shape looks smoother
        ..strokeWidth = strokeWidth
        ..color = Colors.white
        ..style = PaintingStyle.stroke;
      canvas.drawRect(rect, backgroundPaint);
    }
    */

    final foregroundPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white
      ..style = PaintingStyle.fill;//notCompleted ? PaintingStyle.stroke : PaintingStyle.fill;
    canvas.drawRect(Offset(0.0, 0.0) & Size(progress*size.width, 20.0), foregroundPaint);

  }

  @override
  bool shouldRepaint(covariant RectPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

}


class RingPainter extends CustomPainter {
  RingPainter({@required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final notCompleted = progress < 1.0;
    final strokeWidth = size.width / 15.0; // dynamische Widgetgröße möglich
    final center = Offset(size.width/2, size.height/2);
    final radius = notCompleted ? (size.width - strokeWidth) / 2 : size.width / 2;

    if (notCompleted) {
      final backgroundPaint = Paint()
        ..isAntiAlias = true // shape looks smoother
        ..strokeWidth = strokeWidth
        ..color = Colors.black
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }


    final foregroundPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..color = Colors.red
      ..style = notCompleted ? PaintingStyle.stroke : PaintingStyle.fill;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi/2, 2 * pi * progress, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

}
