// // Import the required package for Animation
// import 'package:flutter/animation.dart';

// Animation<double> createAnimation(double intervalIndex, int totalCount) {
//   return Tween<double>(begin: 0.0, end: 1.0).animate(
//     CurvedAnimation(
//       parent: animationController!,
//       curve: Interval(
//         (1 / totalCount) * intervalIndex,
//         1.0,
//         curve: Curves.fastOutSlowIn,
//       ),
//     ),
//   );
// }
