import 'package:flutter/material.dart';
import 'settings_menu.dart';
import 'settings_menu_item.dart';
import 'settings_search_delegate.dart';

typedef SettingsPageRouteWithItemBuilder = Widget Function(
  BuildContext context,
  SettingsGroupItemBuilder itemBuilder
);
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

  Widget get _title => title ?? Text(SettingsPageRoute.routeTitle);
  SettingsMenu get _settingsMenu => body;
  SettingsGroupBuilder get _groupBuilder => _settingsMenu.groupBuilder;

  void _showSearch(context) {
    showSearch(
        context: context,
        delegate: searchDelegate ?? SettingsSearchDelegate(
            groupBuilder: _groupBuilder,
            itemBuilder: _buildItem,
            pageBuilder: this.buildWithItemBuilder,
        )
    );
  }

  SettingsMenuItemBuilder _buildItem(BuildContext context, SettingsMenuItemBuilder item) {
    return (_settingsMenu.itemBuilder != null
        ? _settingsMenu.itemBuilder(context, item)
        : item
    ).copyWith(
      onShowSearch: () => _showSearch(context)
    );
  }

  Widget _buildBody(BuildContext context, [SettingsGroupItemBuilder itemBuilder]) {
    return _settingsMenu.copyWith(
      itemBuilder: itemBuilder ?? _buildItem
    );
  }

  Widget buildWithItemBuilder(BuildContext context, [SettingsGroupItemBuilder itemBuilder]) {
    return builder(
        context,
        _title,
        _buildBody(context, itemBuilder),
        () => _showSearch(context)
    );
  }

  @override
  Widget build(BuildContext context) => buildWithItemBuilder(context);
}