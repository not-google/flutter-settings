import 'package:flutter/material.dart';
import 'types.dart';
import 'status_switch_list_tile.dart';

class Dependency extends StatelessWidget {
  Dependency({
    Key key,
    this.leading,
    @required this.title,
    this.statusTextBuilder,
    @required this.dependentBuilder,
    this.dependencyEnabled = true,
    this.enabled = true,
    this.selected = false,
    this.loading = false,
    @required this.onChanged
  }) :
    assert(title != null),
    assert(dependentBuilder != null),
    assert(dependencyEnabled != null),
    assert(loading != null),
    assert(enabled != null),
    assert(selected != null),
    super(key: key);

  final Widget leading;
  final Widget title;
  final ValueBuilder<bool> statusTextBuilder;
  final ValueBuilder<bool> dependentBuilder;
  final bool dependencyEnabled;
  final bool enabled;
  final bool loading;
  final bool selected;
  final ValueChanged<bool> onChanged;

  Widget _buildStatusText(BuildContext context) {
    if (statusTextBuilder == null) return null;

    return statusTextBuilder(context, dependencyEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StatusSwitchListTile(
          secondary: leading,
          title: title,
          subtitle: _buildStatusText(context),
          value: dependencyEnabled,
          enabled: enabled,
          loading: loading,
          onChanged: onChanged,
          selected: selected,
        ),
        dependentBuilder(context, dependencyEnabled)
      ],
    );
  }
}