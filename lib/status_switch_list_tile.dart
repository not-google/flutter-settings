import 'dart:math';

import 'package:flutter/material.dart';
import 'status_switch.dart';

enum _SwitchListTileType { material, adaptive }

class StatusSwitchListTile extends StatelessWidget {
  const StatusSwitchListTile({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.loading = false,
    this.enabled = true,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
  }) : _switchListTileType = _SwitchListTileType.material,
        assert(loading != null),
        assert(value != null),
        assert(isThreeLine != null),
        assert(!isThreeLine || subtitle != null),
        assert(selected != null),
        super(key: key);

  const StatusSwitchListTile.adaptive({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.loading = false,
    this.enabled = true,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
  }) : _switchListTileType = _SwitchListTileType.adaptive,
        assert(loading != null),
        assert(value != null),
        assert(isThreeLine != null),
        assert(!isThreeLine || subtitle != null),
        assert(selected != null),
        super(key: key);

  final bool value;
  final bool enabled;
  final bool loading;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color activeTrackColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;
  final ImageProvider activeThumbImage;
  final ImageProvider inactiveThumbImage;
  final Widget title;
  final Widget subtitle;
  final Widget secondary;
  final bool isThreeLine;
  final bool dense;
  final bool selected;

  /// If adaptive, creates the switch with [Switch.adaptive].
  final _SwitchListTileType _switchListTileType;

  @override
  Widget build(BuildContext context) {
    Widget control;
    switch (_switchListTileType) {
      case _SwitchListTileType.adaptive:
        control = StatusSwitch.adaptive(
          value: value,
          onChanged: onChanged,
          loading: loading,
          activeColor: activeColor,
          activeThumbImage: activeThumbImage,
          inactiveThumbImage: inactiveThumbImage,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeTrackColor: activeTrackColor,
          inactiveTrackColor: inactiveTrackColor,
          inactiveThumbColor: inactiveThumbColor,
        );
        break;

      case _SwitchListTileType.material:
        control = StatusSwitch(
          value: value,
          loading: loading,
          enabled: enabled,
          onChanged: onChanged,
          activeColor: activeColor,
          activeThumbImage: activeThumbImage,
          inactiveThumbImage: inactiveThumbImage,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeTrackColor: activeTrackColor,
          inactiveTrackColor: inactiveTrackColor,
          inactiveThumbColor: inactiveThumbColor,
        );
    }
    return MergeSemantics(
      child: ListTileTheme.merge(
        selectedColor: activeColor ?? Theme.of(context).accentColor,
        child: IgnorePointer(
          ignoring: !enabled || loading,
          child: ListTile(
            leading: secondary,
            title: title,
            subtitle: subtitle,
            trailing: control,
            isThreeLine: isThreeLine,
            dense: dense,
            enabled: enabled,
            onTap: onChanged != null ? () { onChanged(!value); } : null,
            selected: selected,
          ),
        ),
      ),
    );
  }
}
