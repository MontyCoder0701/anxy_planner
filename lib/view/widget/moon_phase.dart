import 'dart:math' as math;

import 'package:flutter/material.dart';

class MoonPhaseWidget extends StatelessWidget {
  const MoonPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final int dayOfCycle = DateTime.now().day % 29;
    IconData icon;

    if (dayOfCycle == 0 || dayOfCycle == 28) {
      icon = Icons.brightness_3_rounded;
    } else if (dayOfCycle < 7) {
      icon = Icons.brightness_2_rounded;
    } else if (dayOfCycle < 14) {
      icon = Icons.circle;
    } else if (dayOfCycle < 21) {
      icon = Icons.brightness_2_rounded;
    } else {
      icon = Icons.brightness_3_rounded;
    }

    return dayOfCycle > 14
        ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(icon),
          )
        : Icon(icon);
  }
}
