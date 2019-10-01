import 'package:flutter/material.dart';
import 'settings_localizations.dart';
import 'content_switch.dart';

class IndividualSwitch extends StatelessWidget {
  IndividualSwitch({
    Key key,
    @required this.value,
    @required this.onChanged,
    @required this.description,
    this.loading = false
  }) :
    assert(value != null),
    assert(loading != null),
    super(key: key);

  final bool value;
  final bool loading;
  final Widget description;
  final ValueChanged<bool> onChanged;

  Widget _buildTitle(BuildContext context) {
    return Text(
      value
        ? SettingsLocalizations.activeLabel
        : SettingsLocalizations.inactiveLabel
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentSwitch(
      title: _buildTitle(context),
      value: value,
      loading: loading,
      contentBuilder: (context) => Container(
        padding: const EdgeInsets.only(
          left: 72,
          right: 16.0,
          top: 16.0,
          bottom: 16.0
        ),
        child: description,
      ),
      onChanged: onChanged,
    );
  }
}