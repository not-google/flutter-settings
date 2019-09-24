import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_menu_item.dart';
import 'settings.dart';

enum SettingsMenuType {
  column,
  listView
}

abstract class SettingsMenuEntry extends StatefulWidget {
  SettingsMenuEntry({
    Key key,
    @required this.type
  }) : super(key: key);

  final SettingsMenuType type;
}

class SettingsMenu extends SettingsMenuEntry {
  SettingsMenu({
    Key key,
    @required this.groupBuilder,
    this.itemBuilder,
  }) :
    assert(groupBuilder != null),
    super(
      key: key,
      type: SettingsMenuType.listView
    );

  SettingsMenu.column({
    Key key,
    @required this.groupBuilder,
    this.itemBuilder,
  }) :
    assert(groupBuilder != null),
    super(
      key: key,
      type: SettingsMenuType.column
    );

  final SettingsGroupBuilder groupBuilder;
  final SettingsGroupItemBuilder itemBuilder;

  bool get isListView => type == SettingsMenuType.listView;

  static bool needShowTopDivider({
    @required BuildContext context,
    @required SettingsMenuItem item,
    @required List<SettingsMenuItem> group,
    bool hideWhenFirst = false
  }) {
    bool isNotSection = item.pattern != SettingsPattern.section;
    if (isNotSection) return false;

    bool isFirst = item == group.first;
    if (hideWhenFirst && isFirst) return false;

    int itemIndex = group.indexOf(item);
    SettingsMenuItem previous = itemIndex > 0 ? group[itemIndex - 1] : null;

    bool isSectionPrevious = previous?.pattern == SettingsPattern.section;
    if (isSectionPrevious) return false;

    bool isPageLinkPrevious = previous?.pageContentBuilder != null;
    if (isPageLinkPrevious) return true;

    bool isNotEmptyPrevious = previous?.groupBuilder != null;
    if (isNotEmptyPrevious) {
      List<SettingsMenuItem> previousGroup = previous.groupBuilder(context);
      bool isSectionLastPreviousItem = previousGroup?.last?.pattern == SettingsPattern.section;

      if (isSectionLastPreviousItem) return false;
    }

    return true;
  }

  static bool needShowBottomDivider({
    @required BuildContext context,
    @required SettingsMenuItem item,
    @required List<SettingsMenuItem> group,
    bool hideWhenLast = false
  }) {
    bool isNotSection = item.pattern != SettingsPattern.section;
    if (isNotSection) return false;

    bool isLast = item == group.last;
    if (hideWhenLast && isLast) return false;

    return true;
  }

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}
class _SettingsMenuState extends State<SettingsMenu> {

  SharedPreferences _preferences;
  bool _loadedPreferences = false;

  @override
  void initState() {
    super.initState();
    getInstance();
  }

  void getInstance() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() => _loadedPreferences = true);
  }

  dynamic getPreferenceValue(Key key) {
    return Settings.getWithInstance(key.toString(), _preferences);
  }

  Widget _buildMenuItem(
      BuildContext context,
      SettingsMenuItem item,
      List<SettingsMenuItem> group
  ) {
    void _handleChanged(newValue) {
      Settings.setWithInstance(
        item.key.toString(),
        newValue,
        _preferences
      ).then(
        (saved) => (saved && item.onChanged != null)
          ? item.onChanged(newValue)
          : null
      );
    };

    SettingsMenuItemBuilder menuItem = item.copyWith(
        value: getPreferenceValue(item.key),
        onChanged: _handleChanged,
        showTopDivider: SettingsMenu.needShowTopDivider(
            context: context,
            item: item,
            group: group,
            hideWhenFirst: widget.isListView
        ),
        showBottomDivider: SettingsMenu.needShowBottomDivider(
            context: context,
            item: item,
            group: group,
            hideWhenLast: widget.isListView
        )
    ).makeStateful();

    return widget.itemBuilder != null
        ? widget.itemBuilder(menuItem)
        : menuItem;
  }

  Widget _buildColumn(BuildContext context) {
    List<SettingsMenuItem> group = widget.groupBuilder(context);
    return Column(
      children: group.map((item) => _buildMenuItem(context, item, group)).toList(),
    );
  }

  Widget _buildListView(BuildContext context) {
    List<SettingsMenuItem> group = widget.groupBuilder(context);
    return ListView.builder(
        itemCount: group.length,
        itemBuilder: (context, index) {
          SettingsMenuItem item = group[index];
          return _buildMenuItem(context, item, group);
        }
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadedPreferences) return _buildLoading(context);

    return widget.isListView ? _buildListView(context) : _buildColumn(context);
  }
}