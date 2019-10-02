import 'package:flutter/material.dart';
import 'settings_localizations.dart';
import 'status_switch.dart';
import 'types.dart';

class MasterSwitchListTile extends StatelessWidget {
  MasterSwitchListTile({
    Key key,
    this.leading,
    @required this.title,
    this.statusTextBuilder,
    this.showSwitch = true,
    @required this.value,
    this.enabled = true,
    this.selected = false,
    this.loading = false,
    @required this.onChanged,
    this.onTap
  }) :
    assert(title != null),
    assert(showSwitch != null),
    assert(value != null),
    assert(loading != null),
    assert(enabled != null),
    assert(selected != null),
    super(key: key);

  final Widget leading;
  final Widget title;
  final ValueBuilder<bool> statusTextBuilder;
  final bool showSwitch;
  final bool value;
  final bool loading;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;

  Widget _buildSwitch(BuildContext context) {
    if (!showSwitch) return Container();

    return Container(
      child: StatusSwitch(
        value: value,
        onChanged: onChanged,
        loading: loading,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0
          )
        )
      ),
    );
  }

  Widget _buildStatusText(BuildContext context) {
    return statusTextBuilder != null
        ? statusTextBuilder(context, value)
        : Text(
          value
            ? SettingsLocalizations.activeLabel
            : SettingsLocalizations.inactiveLabel
        );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: _buildStatusText(context),
      onTap: onTap,
      selected: selected,
      enabled: enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildListTile(context),
        ),
        _buildSwitch(context)
      ],
    );
  }
}