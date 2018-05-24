import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'dart:ui' show lerpDouble;
import 'dart:math';
import 'package:flutter/material.dart';

class Bezier extends StatelessWidget {
  Color color;
  double scale;
  double blur;
  double delay;

  Bezier(this.color, this.scale, {this.blur = 0.0, this.delay = 0.0});

  List<PathDetail> _getLogoPath() {
    List<PathDetail> paths = [];

    var path = new Path();
    path.moveTo(100.0, 97.0);
    path.cubicTo(100.0, 97.0, 142.0, 59.0, 169.91, 41.22);
    path.cubicTo(197.82, 23.44, 249.24, 5.52, 204.67, 85.84);

    paths.add(new PathDetail(path));

    // Path 2
    var bezier2Path = new Path();
    bezier2Path.moveTo(0.0, 70.55);
    bezier2Path.cubicTo(0.0, 70.55, 42.0, 31.55, 69.91, 14.77);
    bezier2Path.cubicTo(97.82, -2.01, 149.24, -20.93, 104.37, 59.39);

    paths.add(new PathDetail(bezier2Path,
        translate: [29.45, 151.0], rotation: -1.5708));

    // Path 3
    var bezier3Path = new Path();
    bezier3Path.moveTo(0.0, 69.48);
    bezier3Path.cubicTo(0.0, 69.48, 44.82, 27.92, 69.91, 13.7);
    bezier3Path.cubicTo(95.0, -0.52, 149.24, -22.0, 104.37, 58.32);

    paths.add(new PathDetail(bezier3Path,
        translate: [53.0, 200.48], rotation: -3.14159));

    // Path 4
    var bezier4Path = new Path();
    bezier4Path.moveTo(0.0, 69.48);
    bezier4Path.cubicTo(0.0, 69.48, 43.82, 27.92, 69.91, 13.7);
    bezier4Path.cubicTo(96.0, -0.52, 149.24, -22.0, 104.37, 58.32);

    paths.add(new PathDetail(bezier4Path,
        translate: [122.48, 77.0], rotation: -4.71239));

    return paths;
  }

  @override
  Widget build(BuildContext ctx) {
    return Stack(children: <Widget>[
      CustomPaint(
        foregroundPainter:
            BezierPainter(Colors.grey, 0.0, _getLogoPath(), false),
        size: new Size(100.0, 100.0),
      ),
      AnimatedBezier(color, scale, blur: blur, delay: this.delay),
    ]);
  }
}

class PathDetail {
  Path path;
  List<double> translate = [];
  double rotation;

  PathDetail(this.path, {this.translate, this.rotation});
}

class AnimatedBezier extends StatefulWidget {
  Color color;
  double scale;
  double blur;
  double delay;

  AnimatedBezier(this.color, this.scale, {this.blur = 0.0, this.delay});

  @override
  State createState() => new AnimatedBezierState();
}

class Point {
  double x;
  double y;

  Point(this.x, this.y);
}

class AnimatedBezierState extends State<AnimatedBezier>
    with SingleTickerProviderStateMixin {
  double scale;
  AnimationController controller;
  CurvedAnimation curve;
  bool isPlaying = false;
  List<List<Point>> pointList = new List()
    ..add(new List())
    ..add(new List())
    ..add(new List())
    ..add(new List());
  bool isReversed = false;

  List<PathDetail> _playForward() {
    List<PathDetail> paths = [];
    double t = curve.value;
    double b = controller.upperBound;
    double pX;
    double pY;

    var path = new Path();

    if (t < b / 2) {
      pX = _getCubicPoint(t * 2, 100.0, 100.0, 142.0, 169.91);
      pY = _getCubicPoint(t * 2, 97.0, 97.0, 59.0, 41.22);
      pointList[0].add(new Point(pX, pY));
    } else {
      pX = _getCubicPoint(t * 2 - b, 169.91, 197.80, 249.24, 204.67);
      pY = _getCubicPoint(t * 2 - b, 41.22, 23.44, 5.52, 85.84);
      pointList[0].add(new Point(pX, pY));
    }

    path.moveTo(100.0, 97.0);

    pointList[0].forEach((p) {
      path.lineTo(p.x, p.y);
    });

    paths.add(new PathDetail(path));

    // Path 2
    var bezier2Path = new Path();

    if (t <= b / 2) {
      double pX = _getCubicPoint(t * 2, 0.0, 0.0, 42.0, 69.91);
      double pY = _getCubicPoint(t * 2, 70.55, 70.55, 31.55, 14.77);
      pointList[1].add(new Point(pX, pY));
    } else {
      double pX = _getCubicPoint(t * 2 - b, 69.91, 97.82, 149.24, 104.37);
      double pY = _getCubicPoint(t * 2 - b, 14.77, -2.01, -20.93, 59.39);
      pointList[1].add(new Point(pX, pY));
    }

    bezier2Path.moveTo(0.0, 70.55);

    pointList[1].forEach((p) {
      bezier2Path.lineTo(p.x, p.y);
    });

    paths.add(new PathDetail(bezier2Path,
        translate: [29.45, 151.0], rotation: -1.5708));

    // Path 3
    var bezier3Path = new Path();
    if (t <= b / 2) {
      pX = _getCubicPoint(t * 2, 0.0, 0.0, 44.82, 69.91);
      pY = _getCubicPoint(t * 2, 69.48, 69.48, 27.92, 13.7);
      pointList[2].add(new Point(pX, pY));
    } else {
      pX = _getCubicPoint(t * 2 - b, 69.91, 95.0, 149.24, 104.37);
      pY = _getCubicPoint(t * 2 - b, 13.7, -0.52, -22.0, 58.32);
      pointList[2].add(new Point(pX, pY));
    }

    bezier3Path.moveTo(0.0, 69.48);

    pointList[2].forEach((p) {
      bezier3Path.lineTo(p.x, p.y);
    });

    paths.add(new PathDetail(bezier3Path,
        translate: [53.0, 200.48], rotation: -3.14159));

    // Path 4
    var bezier4Path = new Path();

    if (t < b / 2) {
      pX = _getCubicPoint(t * 2, 0.0, 0.0, 43.82, 69.91);
      pY = _getCubicPoint(t * 2, 69.48, 69.48, 27.92, 13.7);
      pointList[3].add(new Point(pX, pY));
    } else {
      pX = _getCubicPoint(t * 2 - b, 69.91, 96.0, 149.24, 104.37);
      pY = _getCubicPoint(t * 2 - b, 13.7, -0.52, -22.0, 58.32);
      pointList[3].add(new Point(pX, pY));
    }

    bezier4Path.moveTo(0.0, 69.48);

    pointList[3].forEach((p) {
      bezier4Path.lineTo(p.x, p.y);
    });

    paths.add(new PathDetail(bezier4Path,
        translate: [122.48, 77.0], rotation: -4.71239));

    return paths;
  }

  List<PathDetail> _playReversed() {
    pointList.forEach((list) {
      if (list.length == 0) {
        return;
      }

      list.removeLast();
    });

    var points = pointList[0];
    var path = new Path();

    path.moveTo(100.0, 97.0);

    points.forEach((point) {
      path.lineTo(point.x, point.y);
    });

    var bezier2Path = new Path();

    bezier2Path.moveTo(0.0, 70.55);

    pointList[1].forEach((p) {
      bezier2Path.lineTo(p.x, p.y);
    });

    var bezier3Path = new Path();
    bezier3Path.moveTo(0.0, 69.48);

    pointList[2].forEach((p) {
      bezier3Path.lineTo(p.x, p.y);
    });

    var bezier4Path = new Path();

    bezier4Path.moveTo(0.0, 69.48);

    pointList[3].forEach((p) {
      bezier4Path.lineTo(p.x, p.y);
    });

    return <PathDetail>[
      new PathDetail(path),
      new PathDetail(bezier2Path, translate: [29.45, 151.0], rotation: -1.5708),
      new PathDetail(bezier3Path,
          translate: [53.0, 200.48], rotation: -3.14159),
      new PathDetail(bezier4Path, translate: [122.48, 77.0], rotation: -4.71239)
    ];
  }

  List<PathDetail> _getLogoPath() {
    if (!isReversed) {
      return _playForward();
    }

    return _playReversed();
  }

  //From http://wiki.roblox.com/index.php?title=File:Beziereq4.png
  double _getCubicPoint(t, p0, p1, p2, p3) {
    return pow((1 - t), 3) * p0 +
        3 * pow(1 - t, 2) * t * p1 +
        3 * (1 - t) * pow(t, 2) * p2 +
        pow(t, 3) * p3;
  }

  void playAnimation() {
    this.isPlaying = true;
    isReversed = false;
    pointList.forEach((list) {
      list.clear();
    });
    controller.reset();
    controller.forward();
  }

  void stopAnimation() {
    this.isPlaying = false;
    controller.stop();
    pointList.forEach((list) {
      list.clear();
    });
  }

  void reverseAnimation() {
    isReversed = true;
    controller.reverse();
  }

  initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));
    curve = new CurvedAnimation(parent: controller, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          reverseAnimation();
        } else if (state == AnimationStatus.dismissed) {
          playAnimation();
        }
      });

    playAnimation();
  }

  @override
  Widget build(BuildContext ctx) {
    return CustomPaint(
        foregroundPainter: BezierPainter(widget.color,
            curve.value * widget.blur, _getLogoPath(), this.isPlaying),
        size: new Size(100.0, 100.0));
  }
}

class BezierPainter extends CustomPainter {
  Color color;
  final double blur;
  List<PathDetail> path;
  bool isPlaying;

  BezierPainter(this.color, this.blur, this.path, this.isPlaying);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.strokeWidth = 18.0;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.color = this.color;
    canvas.scale(0.5, 0.5);

    for (var i = 0; i < this.path.length; i++) {
      if (this.path[i].translate != null) {
        canvas.translate(this.path[i].translate[0], this.path[i].translate[1]);
      }

      if (this.path[i].rotation != null) {
        canvas.rotate(this.path[i].rotation);
      }

      if (this.blur > 0) {
        MaskFilter blur = new MaskFilter.blur(BlurStyle.normal, this.blur);
        paint.maskFilter = blur;
        canvas.drawPath(this.path[i].path, paint);
      }

      paint.maskFilter = null;
      canvas.drawPath(this.path[i].path, paint);
    }
  }

  @override
  bool shouldRepaint(BezierPainter oldDelegate) {
    return (oldDelegate.blur != this.blur);
  }

  @override
  bool shouldRebuildSemantics(BezierPainter oldDelegate) => false;
}
