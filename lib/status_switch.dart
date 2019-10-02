import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

NetworkImage Function() kCircularProgressIndicatorImage = ()
=> NetworkImage('https://raw.githubusercontent.com/not-google/material-design-progress-indicators/master/circular-progress-indicator-with-padding.gif');

enum _SwitchType { material, adaptive }

class StatusSwitch extends StatelessWidget {
  const StatusSwitch({
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
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : _switchType = _SwitchType.material,
    assert(loading != null),
    assert(dragStartBehavior != null),
    super(key: key);

  const StatusSwitch.adaptive({
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
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : _switchType = _SwitchType.adaptive,
    assert(loading != null),
    assert(dragStartBehavior != null),
    super(key: key);

  final bool value;
  final bool loading;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color activeTrackColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;
  final ImageProvider activeThumbImage;
  final ImageProvider inactiveThumbImage;
  final MaterialTapTargetSize materialTapTargetSize;
  final _SwitchType _switchType;
  final DragStartBehavior dragStartBehavior;

  bool _isDarkTheme(ThemeData theme) => theme.brightness == Brightness.dark;
  ImageProvider _getInactiveThumbImage(ThemeData theme) => loading
      ? kCircularProgressIndicatorImage()
      : inactiveThumbImage;
  ImageProvider _getActiveThumbImage(ThemeData theme) => loading
      ? kCircularProgressIndicatorImage()
      : activeThumbImage;
  Color _getActiveTrackColor(ThemeData theme) => !loading
      ? activeTrackColor
      : inactiveTrackColor != null
      ? inactiveTrackColor
      : _isDarkTheme(theme)
      ? Colors.white30
      : Color(0x52000000);
  Color _getActiveColor(ThemeData theme) => !loading
      ? activeColor
      : _isDarkTheme(theme)
      ? Colors.grey.shade400
      : Colors.grey.shade50;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return IgnorePointer(
      ignoring: loading,
      child: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: _getActiveColor(theme),
        activeTrackColor: _getActiveTrackColor(theme),
        inactiveThumbColor: inactiveThumbColor,
        inactiveTrackColor: inactiveTrackColor,
        activeThumbImage: _getActiveThumbImage(theme),
        inactiveThumbImage: _getInactiveThumbImage(theme),
        materialTapTargetSize: materialTapTargetSize,
        dragStartBehavior: dragStartBehavior,
      ),
    );
  }
}