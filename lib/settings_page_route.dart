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
    this.builder = SettingsPageRoute.defaultPageBuilder,
  }) :
    assert(body != null),
    super(key: key);

  static String routeName = '/settings';

  final Widget title;
  final SettingsMenu body;
  final SettingsPageRouteBuilder builder;

  copyWith({
    Widget title,
    SettingsMenu body,
    SettingsPageRouteBuilder builder
  }) {
    return SettingsPageRoute(
      title: title ?? this.title,
      body: body ?? this.body,
      builder: builder ?? this.builder
    );
  }

  static Widget defaultPageBuilder(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onShowSearch
  ) {
    return Scaffold(
      appBar: AppBar(
        title: title,
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

  Widget _buildSettingsMenu(BuildContext context) {
    return this.body.copyWith(
      searchDelegate: SettingsSearchDelegate(
          rootSettingsMenu: body,
          rootPageRoute: this
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingsMenu _settingsMenu = _buildSettingsMenu(context);
    return builder(
        context,
        title,
        _settingsMenu,
        () => _settingsMenu.showSettingsSearch(context)
    );
  }
}