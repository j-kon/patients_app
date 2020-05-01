import 'dart:ui';
import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFF6a0dad);
  static const Color loginGradientEnd = const Color(0xFF550a8a);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}