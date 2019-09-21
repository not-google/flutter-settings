import 'package:flutter/material.dart';

class Choice<T> {
  Choice({
    @required this.label,
    this.secondaryText,
    @required this.value
  });

  final Text label;
  final Widget secondaryText;
  final T value;
}