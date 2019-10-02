import 'package:flutter/material.dart';
import 'status_switch_list_tile.dart';

class ContentSwitch extends StatelessWidget {
  ContentSwitch({
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

  Widget _buildSecondary(BuildContext context) {
    return Visibility(
        visible: false,
        child: CircleAvatar()
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return DefaultTextStyle(
      style: (title.style ?? theme.textTheme.subhead).copyWith(
        color: title.style?.color ?? theme.colorScheme.onBackground,
        fontWeight: title.style?.fontWeight ?? FontWeight.w500
      ),
      child: title,
    );
  }

  Widget _buildControl(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        child: StatusSwitchListTile(
          secondary: _buildSecondary(context),
          title: _buildTitle(context, theme),
          value: value,
          loading: loading,
          onChanged: onChanged,
          activeColor: theme.colorScheme.onBackground,
          inactiveThumbColor: theme.colorScheme.onBackground,
        ),
        decoration: BoxDecoration(
          color: value
            ? theme.indicatorColor
            : theme.disabledColor
        ),
    );
  }

  bool get _active => value;

  Widget _buildContent(BuildContext context) {
    WidgetBuilder contentBuilder;

    if (loading) {
      contentBuilder = _active
          ? inactiveContentBuilder
          : activeContentBuilder;
    } else {
      contentBuilder = _active
          ? activeContentBuilder
          : inactiveContentBuilder;
    }

    return Expanded(
      child: contentBuilder(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildControl(context),
        _buildContent(context)
      ],
    );
  }
}