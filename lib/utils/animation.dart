import 'package:flutter/animation.dart';

Animation<double> createAnimation(AnimationController animationController, double startInterval, double endInterval, int count) {
  return Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Interval((1 / count) * startInterval, endInterval, curve: Curves.fastOutSlowIn),
    ),
  );
}
