import 'package:flutter/material.dart';

const double _kSecondaryWidth = 50.0;

class SliderListTile extends StatelessWidget {
  const SliderListTile({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.title,
    this.trailing,
    this.dense,
    this.secondary,
    this.selected,
    this.semanticFormatterCallback
  }) :
    assert(value != null),
    assert(min != null),
    assert(max != null),
    assert(min <= max),
    assert(value >= min && value <= max),
    assert(divisions == null || divisions > 0),
    super(key: key);

  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final Color activeColor;
  final Color inactiveColor;
  final Widget title;
  final Widget trailing;
  final Widget secondary;
  final bool dense;
  final bool selected;
  final SemanticFormatterCallback semanticFormatterCallback;

  @override
  Widget build(BuildContext context) {
    bool enabled = onChanged != null || onChangeStart != null || onChangeEnd != null;
    return Stack(
      children: <Widget>[
        ListTile(
          leading: secondary,
          title: title,
          subtitle: Text(''),
          trailing: trailing,
          dense: dense,
          selected: selected,
          enabled: enabled,
        ),
        Positioned(
            top: title == null ? 12 : 24,
            left: secondary == null ? 0 : _kSecondaryWidth,
            right: trailing == null ? 0 : _kSecondaryWidth,
            child: Slider(
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
              onChangeStart: onChangeStart,
              onChangeEnd: onChangeEnd,
              semanticFormatterCallback: semanticFormatterCallback,
            )
        )
      ],
    );
  }
}