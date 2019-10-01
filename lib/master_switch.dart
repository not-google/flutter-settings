import 'package:flutter/material.dart';
import 'content_switch.dart';

class MasterSwitch extends StatelessWidget {
  MasterSwitch({
    Key key,
    @required this.title,
    @required this.value,
    @required this.activeContentBuilder,
    @required this.inactiveContentBuilder,
    @required this.onChanged,
    this.loading = false
  }) :
    assert(title != null),
    assert(value != null),
    assert(loading != null),
    assert(activeContentBuilder != null),
    assert(inactiveContentBuilder != null),
    super(key: key);

  final Text title;
  final bool value;
  final bool loading;
  final WidgetBuilder activeContentBuilder;
  final WidgetBuilder inactiveContentBuilder;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ContentSwitch(
      title: title,
      value: value,
      loading: loading,
      contentBuilder: value ? activeContentBuilder : inactiveContentBuilder,
      onChanged: onChanged,
    );
  }
}