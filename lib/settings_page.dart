import 'package:flutter/material.dart';
import 'settings_menu.dart';
import 'settings_menu_item.dart' show SettingsGroupBuilder;
import 'settings_search_delegate.dart';

typedef SettingsPageBuilder<T> = Widget Function(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onSearch,
);

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key key,
    @required this.title,
    @required this.groupBuilder,
    this.builder,
  }) :
    assert(groupBuilder != null),
    super(key: key);

  static String routeName = '/settings';
  static String routeTitle = 'Settings';

  final Widget title;
  final SettingsPageBuilder builder;
  final SettingsGroupBuilder groupBuilder;

  void _showSearch(context) {
    showSearch(
      context: context,
      delegate: SettingsSearchDelegate(
        groupBuilder: groupBuilder
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return SettingsMenu(
      groupBuilder: groupBuilder,
      onSearch: () => _showSearch(context),
    );
  }

  static Widget pageBuilder(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onSearch
  ) {
    return Scaffold(
      appBar: AppBar(
        title: title ?? Text(routeTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: onSearch
          ),
        ],
      ),
      body: body
    );
  }

  @override
  Widget build(BuildContext context) => (builder ?? pageBuilder)(
      context,
      title ?? Text(routeTitle),
      _buildBody(context),
          () => _showSearch(context)
  );
}