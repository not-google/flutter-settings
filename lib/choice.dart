import 'package:flutter/material.dart';

class Choice {
  Choice({
    @required this.title,
    this.subtitle,
    @required this.value
  });

  final Text title;
  final Widget subtitle;
  final String value;
}