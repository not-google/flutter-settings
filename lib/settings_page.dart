import 'package:flutter/material.dart';
import 'settings_menu.dart';
import 'settings_menu_item.dart';
import 'settings_search_delegate.dart';

typedef SettingsPageRouteBuilder<T> = Widget Function(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onShowSearch,
);

class SettingsPageRoute extends StatelessWidget {
  SettingsPageRoute({
    Key key,
    @required this.title,
    @required this.body,
    this.builder = SettingsPageRoute.pageBuilder,
    this.searchDelegate
  }) :
    assert(body != null),
    super(key: key);

  static String routeName = '/settings';
  static String routeTitle = 'Settings';

  final Widget title;
  final SettingsMenu body;
  final SettingsPageRouteBuilder builder;
  final SettingsSearchDelegate searchDelegate;

  Widget get _title => title ?? Text(routeTitle);
  SettingsMenu get _settingsMenu => body;
  SettingsGroupBuilder get _groupBuilder => _settingsMenu.groupBuilder;

  void _showSearch(context) {
    showSearch(
      context: context,
      delegate: searchDelegate ?? SettingsSearchDelegate(
        groupBuilder: _groupBuilder,
        pageBuilder: pageBuilder,
        title: _title,
        onShowSearch: () => _showSearch(context)
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return SettingsMenu(
      groupBuilder: _groupBuilder,
      itemBuilder: (item) {
        SettingsMenuItemBuilder _item = _settingsMenu.itemBuilder != null
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
  Widget build(BuildContext context) => builder(
      context,
      _title,
      _buildBody(context),
      () => _showSearch(context)
  );
}