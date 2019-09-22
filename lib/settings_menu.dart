import 'package:flutter/material.dart';
import 'settings_menu_item.dart';

class SettingsMenu extends StatelessWidget {
  SettingsMenu({
    Key key,
    @required this.groupBuilder,
    this.enabled = true,
    this.scrolled = true,
    this.selectedId,
    this.onSearch,
  }) :
    assert(groupBuilder != null),
    assert(enabled != null),
    assert(scrolled != null),
    super(key: key);

  final SettingsGroupBuilder groupBuilder;
  final String selectedId;
  final bool enabled;
  final bool scrolled;
  final VoidCallback onSearch;

  Widget _buildMenuItem(
    BuildContext context,
    SettingsMenuItem widget,
    List<SettingsMenuItem> group
  ) => widget.copyWith(
      dependencyEnabled: enabled,
      onSearch: onSearch,
      selectedId: selectedId,
      showTopDivider: needShowTopDivider(
          context: context,
          widget: widget,
          group: group,
          hideWhenFirst: scrolled
      ),
      showBottomDivider: needShowBottomDivider(
          context: context,
          widget: widget,
          group: group,
          hideWhenLast: scrolled
      )
  ).buildStateful(context);

  static bool needShowTopDivider({
    @required BuildContext context,
    @required SettingsMenuItem widget,
    @required List<SettingsMenuItem> group,
    bool hideWhenFirst = false
  }) {
    bool isNotSection = widget.pattern != SettingsMenuItemPattern.section;
    if (isNotSection) return false;

    bool isFirst = widget == group.first;
    if (hideWhenFirst && isFirst) return false;

    int itemIndex = group.indexOf(widget);
    SettingsMenuItem previous = itemIndex > 0 ? group[itemIndex - 1] : null;

    bool isSectionPrevious = previous?.pattern == SettingsMenuItemPattern.section;
    if (isSectionPrevious) return false;

    bool isPageLinkPrevious = previous?.pageBuilder != null;
    if (isPageLinkPrevious) return true;

    bool isNotEmptyPrevious = previous?.groupBuilder != null;
    if (isNotEmptyPrevious) {
      List<SettingsMenuItem> previousGroup = previous.groupBuilder(context);
      bool isSectionLastPreviousItem = previousGroup?.last?.pattern == SettingsMenuItemPattern.section;
      if (isSectionLastPreviousItem) return false;
    }

    return true;
  }

  static bool needShowBottomDivider({
    @required BuildContext context,
    @required SettingsMenuItem widget,
    @required List<SettingsMenuItem> group,
    bool hideWhenLast = false
  }) {
    bool isNotSection = widget.pattern != SettingsMenuItemPattern.section;
    if (isNotSection) return false;

    bool isLast = widget == group.last;
    if (hideWhenLast && isLast) return false;

    return true;
  }

  Widget _buildList(BuildContext context) {
    List<SettingsMenuItem> group = groupBuilder(context);
    return Column(
      children: group.map((widget) => _buildMenuItem(context, widget, group)).toList(),
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
    return scrolled ? _buildListView(context) : _buildList(context);
  }
}