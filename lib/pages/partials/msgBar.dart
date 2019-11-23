import 'package:flutter/material.dart';

SnackBar msgBar(String text, Color color) {
  return SnackBar(
    content: Text(
      text,
      style: TextStyle(color: color),
      textAlign: TextAlign.center,
    ),
  );
}
