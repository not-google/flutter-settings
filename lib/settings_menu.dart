import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_menu_item.dart';
import 'settings.dart';

enum SettingsMenuType {
  column,
  listView
}

abstract class SettingsMenuEntry extends StatelessWidget {
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

  Widget _buildMenuItem(
      BuildContext context,
      SettingsMenuItem item,
      List<SettingsMenuItem> group
  ) {
    return (itemBuilder != null ? itemBuilder(item) : item).copyWith(
        showTopDivider: SettingsMenu.needShowTopDivider(
            context: context,
            item: item,
            group: group,
            hideWhenFirst: isListView
        ),
        showBottomDivider: SettingsMenu.needShowBottomDivider(
            context: context,
            item: item,
            group: group,
            hideWhenLast: isListView
        )
    ).makeStateful();
  }

  Widget _buildColumn(BuildContext context) {
    List<SettingsMenuItem> group = groupBuilder(context);
    return Column(
      children: group.map((item) => _buildMenuItem(context, item, group)).toList(),
    );
  }

  Widget _buildListView(BuildContext context) {
    List<SettingsMenuItem> group = groupBuilder(context);
    return ListView.builder(
        itemCount: group.length,
        itemBuilder: (context, index) {
          SettingsMenuItem item = group[index];
          return _buildMenuItem(context, item, group);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return isListView
        ? _buildListView(context)
        : _buildColumn(context);
  }
}