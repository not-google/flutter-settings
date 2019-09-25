import 'package:flutter/material.dart';
import 'settings_menu.dart';
import 'settings_menu_item.dart';
import 'settings_search_delegate.dart';

typedef SettingsPageRouteSelectedBuilder = Widget Function(
  BuildContext context,
  Key selectedKey
);
typedef SettingsPageRouteBuilder<T> = Widget Function(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onShowSearch,
);

class SettingsPageRoute extends StatefulWidget {
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

  @override
  _SettingsPageRouteState createState() => _SettingsPageRouteState();
}

class _SettingsPageRouteState extends State<SettingsPageRoute> {
//  Settings _settings;
//  bool _loaded = false;

  Widget get _title => widget.title ?? Text(SettingsPageRoute.routeTitle);
  SettingsMenu get _settingsMenu => widget.body;
  SettingsGroupBuilder get _groupBuilder => _settingsMenu.groupBuilder;

//  @override
//  void initState() {
//    super.initState();
//    _loadSettings();
//  }
//
//  void _loadSettings() async {
//    _settings = await Settings.getInstance();
//    setState(() => _loaded = true);
//  }

  void _showSearch(context) {
    showSearch(
        context: context,
        delegate: widget.searchDelegate ?? SettingsSearchDelegate(
            groupBuilder: _groupBuilder,
            pageWithSelectedBuilder: this.buildWithSelected,
            onShowSearch: () => _showSearch(context)
        )
    );
  }

  Widget _buildBody(BuildContext context, [selectedKey]) {
    return SettingsMenu(
        groupBuilder: _groupBuilder,
        itemBuilder: (item) {
          item = _settingsMenu.itemBuilder != null
              ? _settingsMenu.itemBuilder(item)
              : item;
          item = item.copyWith(
            selectedKey: selectedKey,
//            value: _settings.getLoaded(item.key.toString()),
//            valueLoaded: _loaded,
//            onGetValue: _settings.get,
//            onSetValue: _settings.set,
            onShowSearch: () => _showSearch(context)
          );
          return item;
        }
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildWithSelected(BuildContext context, [selectedKey]) {
    return widget.builder(
        context,
        _title,
        _buildBody(context, selectedKey),
        () => _showSearch(context)
    );
  }

  @override
  Widget build(BuildContext context) => buildWithSelected(context);
}