import 'package:flutter/material.dart';
import 'settings_menu.dart';
import 'settings_menu_item.dart';
import 'settings_search_delegate.dart';

typedef SettingsPageBuilder<T> = Widget Function(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onShowSearch,
);

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key key,
    @required this.title,
    @required this.body,
    this.builder,
    this.searchDelegate
  }) :
    assert(body != null),
    super(key: key);

  static String routeName = '/settings';
  static String routeTitle = 'Settings';

  final Widget title;
  final SettingsMenu body;
  final SettingsPageBuilder builder;
  final SettingsSearchDelegate searchDelegate;

  SettingsMenu get _settingsMenu => body;
  SettingsGroupBuilder get _groupBuilder => _settingsMenu.groupBuilder;

  void _showSearch(context) {
    showSearch(
      context: context,
      delegate: searchDelegate ?? SettingsSearchDelegate(
        groupBuilder: _groupBuilder,
        onShowSearch: () => _showSearch(context)
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return SettingsMenu(
      groupBuilder: _groupBuilder,
      itemBuilder: (item) {
        SettingsPatternBuilder _item = _settingsMenu.itemBuilder != null
          ? _settingsMenu.itemBuilder(item) : item;

        return _item.copyWith(
          onShowSearch: () => _showSearch(context)
        );
      }
    );
  }

  static Widget pageBuilder(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onShowSearch
  ) {
    return Scaffold(
      appBar: AppBar(
        title: title ?? Text(routeTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: onShowSearch
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