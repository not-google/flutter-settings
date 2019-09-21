import 'package:flutter/material.dart';
import 'content_switch.dart';

class MasterSwitch extends StatelessWidget {
  MasterSwitch({
    Key key,
    @required this.title,
    @required this.value,
    @required this.activeContentBuilder,
    @required this.inactiveContentBuilder,
    @required this.onChanged
  }) : super(key: key);

  final Text title;
  final bool value;
  final WidgetBuilder activeContentBuilder;
  final WidgetBuilder inactiveContentBuilder;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ContentSwitch(
      title: title,
      value: value,
      pageContentBuilder: value ? activeContentBuilder : inactiveContentBuilder,
      onChanged: onChanged,
    );
  }
}