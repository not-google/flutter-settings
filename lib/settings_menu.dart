import 'dart:async';
import 'package:flutter/material.dart';
import 'settings_menu_item.dart';
import 'settings.dart';

//typedef SettingValueGetter<T> = FutureOr<T> Function(Key key);
//typedef SettingValueSetter<T> = FutureOr<bool> Function(Key key, T value);

enum SettingsMenuType {
  column,
  listView
}

class SettingsMenu extends StatelessWidget {
  SettingsMenu({
    Key key,
    @required this.groupBuilder,
    this.itemBuilder = SettingsMenu.defaultItemBuilder,
    this.searchDelegate,
    this.type = SettingsMenuType.listView,
  }) :
    assert(groupBuilder != null),
    super(key: key);

  final SettingsMenuType type;
  final SettingsGroupBuilder groupBuilder;
  final SettingsGroupItemBuilder itemBuilder;
  final SearchDelegate searchDelegate;

  SettingsMenu copyWith({
    SettingsGroupBuilder groupBuilder,
    SettingsGroupItemBuilder itemBuilder,
    SearchDelegate searchDelegate,
    SettingsMenuType type
  }) {
    return SettingsMenu(
        groupBuilder: groupBuilder ?? this.groupBuilder,
        itemBuilder: itemBuilder ?? this.itemBuilder,
        searchDelegate: searchDelegate ?? this.searchDelegate,
        type: type ?? this.type
    );
  }

  static SettingsMenuItemBuilder defaultItemBuilder(
      BuildContext context,
      SettingsMenuItemBuilder item
  ) => item;

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

  SettingsMenuItemBuilder buildItem(BuildContext context, SettingsMenuItemBuilder item) {
    SettingsMenuItemBuilder _item = itemBuilder(context, item);

    return _item.copyWith(
      itemBuilder: buildItem,
      onShowSearch: _item.onShowSearch ?? () => showSettingsSearch(context)
    ).makeStateful();
  }

  void showSettingsSearch(BuildContext context) {
    showSearch(
        context: context,
        delegate: searchDelegate ?? SettingsSearchDelegate(
            rootSettingsMenu: this
        )
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      SettingsMenuItem item,
      List<SettingsMenuItem> group
  ) {
    return buildItem(context, item).copyWith(
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
    );
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