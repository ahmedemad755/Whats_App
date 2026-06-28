import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get width => screenSize.width;

  double get height => screenSize.height;

  double w(double percent) => width * percent;

  double h(double percent) => height * percent;
}