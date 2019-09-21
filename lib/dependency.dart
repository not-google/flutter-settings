import 'package:flutter/material.dart';
import 'types.dart';

class Dependency extends StatelessWidget {
  Dependency({
    Key key,
    this.leading,
    @required this.title,
    this.statusTextBuilder,
    @required this.dependentBuilder,
    @required this.dependencyEnabled,
    this.enabled = true,
    this.selected = false,
    @required this.onChanged
  }) : super(key: key);

  final Widget leading;
  final Widget title;
  final ValueBuilder<bool> statusTextBuilder;
  final ValueBuilder<bool> dependentBuilder;
  final bool dependencyEnabled;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;

  Widget _buildSecondaryText(BuildContext context) {
    if (statusTextBuilder == null) return null;

    return statusTextBuilder(context, dependencyEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          secondary: leading ?? Icon(null),
          title: title,
          subtitle: _buildSecondaryText(context),
          value: dependencyEnabled,
          onChanged: enabled ? onChanged : null,
          selected: selected,
        ),
        dependentBuilder(context, dependencyEnabled)
      ],
    );
  }
}