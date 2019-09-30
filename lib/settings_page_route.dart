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

  copyWith({
    Widget title,
    SettingsMenu body,
    SettingsPageRouteBuilder builder,
    SettingsSearchDelegate searchDelegate
  }) {
    return SettingsPageRoute(
      title: title ?? this.title,
      body: body ?? this.body,
      builder: builder ?? this.builder,
      searchDelegate: searchDelegate ?? this.searchDelegate,
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

  Widget get _title => title ?? Text(SettingsPageRoute.routeTitle);
  SettingsMenu get _settingsMenu => body;
  SettingsGroupBuilder get _groupBuilder => _settingsMenu.groupBuilder;

  void _showSearch(context) {
    showSearch(
        context: context,
        delegate: searchDelegate ?? SettingsSearchDelegate(
          rootPageRoute: this
        )
    );
  }

  SettingsMenuItemBuilder buildItem(BuildContext context, SettingsMenuItemBuilder item) {
    return _settingsMenu.itemBuilder(context, item).copyWith(
      onShowSearch: () => _showSearch(context)
    ).makeStateful();
  }

  Widget _buildBody(BuildContext context) {
    return _settingsMenu.copyWith(
      itemBuilder: buildItem
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