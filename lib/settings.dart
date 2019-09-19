import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const String activeLabel = 'On';
const String inactiveLabel = 'Off';
const double _kListTileHeight = 56.0;
const double _kSecondaryWidth = 50.0;
const double _kDividerHeight = 1.0;

typedef SettingsPageBuilder<T> = Widget Function(
  BuildContext context,
  Widget title,
  Widget body,
  VoidCallback onSearch,
);
typedef SettingsItemBuilder<T> = List<SettingsMenuItem<T>> Function(BuildContext context);
typedef ValueBuilder<T> = Widget Function(BuildContext context, T value);
typedef SettingsStateBuilder = Widget Function(BuildContext context, SettingsMenuItemState state);

enum SettingsMenuItemType {
  toggleSwitch,
  section,
  // Selection Patterns
  singleChoice,
  multipleChoice,
  slider,
  dateTime,
  listSubpage,
  masterSwitch,
  individualSwitch,
  dependency
}

class Choice<T> {
  Choice({
    @required this.label,
    this.secondaryText,
    @required this.value
  });

  final Text label;
  final Widget secondaryText;
  final T value;
}

abstract class SettingsMenuEntry<T> extends StatelessWidget {
  SettingsMenuEntry({
    Key key,
    this.id,
    @required this.label,
    @required this.enabled,
    @required this.initialValue,
    @required this.builder,
    this.onChanged,
    this.controlBuilder,
    this.pageBuilder,
    this.pageContentBuilder,
    this.groupBuilder,
    this.needUpdateOnChanged = false,
    @required this.type,
  });

  final String id;
  final Text label;
  final bool enabled;
  final initialValue;
  final onChanged;
  final SettingsStateBuilder builder;
  final SettingsStateBuilder controlBuilder;
  final SettingsStateBuilder pageContentBuilder;
  final SettingsPageBuilder pageBuilder;
  final SettingsItemBuilder groupBuilder;
  final bool needUpdateOnChanged;
  final SettingsMenuItemType type;
}

class SettingsMenuItemState {
  SettingsMenuItemState({
    this.selected,
    this.enabled,
    this.showTopDivider,
    this.showBottomDivider,
    this.value,
    this.onChanged,
    this.pageBuilder,
    this.controlBuilder,
    this.pageContentBuilder,
    this.onSearch,
    this.selectedId
  });

  final bool selected;
  final bool enabled;
  final bool showTopDivider;
  final bool showBottomDivider;
  final value;
  final onChanged;
  final VoidCallback onSearch;
  final SettingsStateBuilder pageBuilder;
  final SettingsStateBuilder controlBuilder;
  final SettingsStateBuilder pageContentBuilder;
  final String selectedId;

  SettingsMenuItemState copyWith({
    bool selected,
    bool enabled,
    bool showTopDivider,
    bool showBottomDivider,
    VoidCallback onSearch,
    onChanged,
    value,
    SettingsStateBuilder pageBuilder,
    SettingsStateBuilder controlBuilder,
    SettingsStateBuilder pageContentBuilder,
    String selectedId
  }) {
    return SettingsMenuItemState(
      selected: selected ?? this.selected,
      enabled: enabled ?? this.enabled,
      showTopDivider: showTopDivider ?? this.showTopDivider,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      onChanged: onChanged ?? this.onChanged,
      onSearch: onSearch ?? this.onSearch,
      value: value ?? this.value,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      controlBuilder: controlBuilder ?? this.controlBuilder,
      pageContentBuilder: pageBuilder ?? this.pageContentBuilder,
      selectedId: selectedId ?? this.selectedId
    );
  }

  SettingsMenuItemState copyFrom(SettingsMenuItemState state) {
    return SettingsMenuItemState(
      selected: state.selected ?? this.selected,
      enabled: state.enabled ?? this.enabled,
      showTopDivider: state.showTopDivider ?? this.showTopDivider,
      showBottomDivider: state.showBottomDivider ?? this.showBottomDivider,
      onChanged: state.onChanged ?? this.onChanged,
      onSearch: state.onSearch ?? this.onSearch,
      value: state.value ?? this.value,
      pageBuilder: state.pageBuilder ?? this.pageBuilder,
      controlBuilder: state.controlBuilder ?? this.controlBuilder,
      pageContentBuilder: state.pageBuilder ?? this.pageContentBuilder,
      selectedId: state.selectedId ?? this.selectedId
    );
  }
}

class SettingsMenuItem<T> extends SettingsMenuEntry<T> {
  SettingsMenuItem.toggleSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    Widget secondaryText,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged,
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context, state),
    controlBuilder: (context, state) => SwitchListTile(
        secondary: leading ?? Icon(null),
        title: label,
        subtitle: secondaryText,
        value: state.value,
        selected: state.selected,
        onChanged: state.enabled
          ? (state.onChanged ?? (value) => null) : null
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    type: SettingsMenuItemType.toggleSwitch
  );

  SettingsMenuItem.section({
    Key key,
    Widget title,
    @required SettingsItemBuilder groupBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, state) => Section(
      title: title,
      content: SettingsMenu(
        groupBuilder: groupBuilder,
        enabled: state.enabled,
        selectedId: state.selectedId,
        onSearch: state.onSearch,
        scrolled: false,
      ),
      enabled: state.enabled,
      showTopDivider: state.showTopDivider ?? true,
      showBottomDivider: state.showBottomDivider ?? true
    ),
    enabled: enabled,
    groupBuilder: groupBuilder,
    type: SettingsMenuItemType.section
  );

  SettingsMenuItem.singleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<Choice<T>> secondaryTextBuilder,
    @required List<Choice<T>> choices,
    @required T initialValue,
    SettingsPageBuilder pageBuilder,
    bool enabled = true,
    ValueChanged<T> onChanged
  }) : super(
    key: key,
    builder: (context, state) {
      T value = state.value;
      Choice<T> selectedChoice = choices.firstWhere((choice) => choice.value == value);
      Widget statusText = (secondaryTextBuilder != null)
          ? secondaryTextBuilder(context, selectedChoice)
          : selectedChoice.label;
      return ListTile(
        leading: leading ?? Icon(null),
        title: label,
        subtitle: statusText,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => state.pageBuilder(context, state)
          )
        ),
        selected: state.selected,
        enabled: state.enabled,
      );
    },
    controlBuilder: (context, state) => SingleChoiceControl<T>(
      choices: choices,
      value: state.value,
      onChanged: state.onChanged,
    ),
    pageContentBuilder: (context, state) => state.controlBuilder(context, state),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    needUpdateOnChanged: true,
    type: SettingsMenuItemType.singleChoice
  );

  SettingsMenuItem.multipleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<List<Choice<T>>> secondaryTextBuilder,
    @required List<Choice<T>> choices,
    @required List<T> initialValue,
    bool enabled = true,
    ValueChanged<List<T>> onChanged
  }) : super(
    key: key,
    builder: (context, state) => MultipleChoiceMenuItem<T>(
      leading: leading,
      label: label,
      secondaryTextBuilder: secondaryTextBuilder,
      controlBuilder: (context) => state.controlBuilder(context, state),
      choices: choices,
      value: state.value,
      enabled: state.enabled,
      selected: state.selected,
    ),
    controlBuilder: (context, state) =>  MultipleChoiceControl<T>(
      choices: choices,
      value: state.value,
      onChanged: state.onChanged
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    needUpdateOnChanged: true,
    type: SettingsMenuItemType.multipleChoice
  );

  SettingsMenuItem.slider({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    Widget secondaryText,
    @required double initialValue,
    double min = 0.0,
    double max = 1.0,
    int divisions,
    ValueChanged<double> onChanged,
    ValueChanged<double> onChangeStart,
    ValueChanged<double> onChangeEnd,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context, state),
    controlBuilder: (context, state) => SliderListTile(
      secondary: leading ?? Icon(null),
      title: label,
      value: state.value,
      selected: state.selected,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: state.enabled ? state.onChanged : null,
      onChangeStart: state.enabled ? onChangeStart : null,
      onChangeEnd: state.enabled ? onChangeEnd : null,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    type: SettingsMenuItemType.slider
  );

  SettingsMenuItem.dateTime({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<DateTime> secondaryTextBuilder,
    @required DateTime initialValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    bool enabled = true,
    ValueChanged<DateTime> onChanged
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context, state),
    controlBuilder: (context, state) => DatePickerListTile(
      leading: leading,
      label: label,
      secondaryTextBuilder: secondaryTextBuilder,
      value: state.value,
      firstDate: firstDate,
      lastDate: lastDate,
      enabled: state.enabled,
      selected: state.selected,
      onChanged: state.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    type: SettingsMenuItemType.dateTime
  );

  SettingsMenuItem.listSubpage({
    Key key,
    @required String id,
    @required Text label,
    Widget leading,
    Widget secondaryText,
    @required SettingsItemBuilder groupBuilder,
    @required SettingsPageBuilder pageBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, state) => ListTile(
      leading: leading ?? Icon(null),
      title: label,
      subtitle: secondaryText,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => state.pageBuilder(context, state)
        )
      ),
      selected: state.selected,
      enabled: state.enabled,
    ),
    pageContentBuilder: (context, state) {
      return SettingsMenu(
        groupBuilder: groupBuilder,
        onSearch: state.onSearch,
        selectedId: state.selectedId,
      );
    },
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    groupBuilder: groupBuilder,
    type: SettingsMenuItemType.listSubpage
  );

  SettingsMenuItem.masterSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    Text switchTitle,
    ValueBuilder<bool> secondaryTextBuilder,
    @required WidgetBuilder inactiveTextBuilder,
    bool showDuplicateSwitch = false,
    @required SettingsItemBuilder groupBuilder,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged,
    @required SettingsPageBuilder pageBuilder
  }) : super(
    key: key,
    builder: (context, state) {
      Widget secondaryText = secondaryTextBuilder != null
          ? secondaryTextBuilder(context, state.value)
          : Text(state.value ? activeLabel : inactiveLabel);
      return MasterSwitchListTile(
        leading: leading,
        title: label,
        subtitle: secondaryText,
        showSwitch: showDuplicateSwitch,
        value: state.value,
        enabled: state.enabled,
        selected: state.selected,
        onChanged: state.onChanged,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => state.pageBuilder(context, state)
          )
        ),
      );
    },
    controlBuilder: (context, state) => MasterSwitchControl(
      title: switchTitle ?? Text('Use ${label.data}'),
      value: state.value,
      onChanged: state.onChanged,
      activeContentBuilder: (context) => SettingsMenu(
        groupBuilder: groupBuilder,
        onSearch: state.onSearch,
        selectedId: state.selectedId
      ),
      inactiveContentBuilder: (context) => Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(16.0).copyWith(left: 72.0),
        child: inactiveTextBuilder(context),
      )
    ),
    pageContentBuilder: (context, state) {
      return state.controlBuilder(context, state);
    },
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    needUpdateOnChanged: true,
    type: SettingsMenuItemType.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    @required Widget description,
    @required bool initialValue,
    bool enabled = true,
    @required SettingsPageBuilder pageBuilder,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (context, state) => ListTile(
      leading: leading ?? Icon(null),
      title: label,
      subtitle: Text(state.value ? activeLabel : inactiveLabel),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => state.pageBuilder(context, state)
        )
      ),
      selected: state.selected,
      enabled: state.enabled,
    ),
    controlBuilder: (context, state) => IndividualSwitchControl(
      secondaryTextBuilder: (context, checked) =>
        Text(checked ? activeLabel : inactiveLabel),
      value: state.value,
      description: description,
      onChanged: state.onChanged,
    ),
    pageContentBuilder: (context, state) => state.controlBuilder(context, state),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    needUpdateOnChanged: true,
    type: SettingsMenuItemType.individualSwitch
  );

  SettingsMenuItem.dependency({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<bool> secondaryTextBuilder,
    @required SettingsItemBuilder groupBuilder,
    @required bool initialValue,
    ValueChanged<bool> onChanged,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context, state),
    controlBuilder: (context, state) => DependencyControl(
      leading: leading,
      title: label,
      secondaryTextBuilder: secondaryTextBuilder,
      dependentBuilder: (context, dependencyEnabled) => SettingsMenu(
        groupBuilder: groupBuilder,
        enabled: dependencyEnabled,
        selectedId: state.selectedId,
        onSearch: state.onSearch,
        scrolled: false
      ),
      dependencyEnabled: state.value,
      enabled: state.enabled,
      selected: state.selected,
      onChanged: state.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    type: SettingsMenuItemType.dependency
  );

  SettingsMenuItemState get initialState => SettingsMenuItemState(
    selected: false,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    onSearch: null,
    controlBuilder: buildControl,
    pageBuilder: buildPage,
    pageContentBuilder: buildPageContent
  );

  final ValueNotifier _valueNotifier = ValueNotifier(null);
  void _handleChanged(newValue) => _valueNotifier.value = newValue;

  Widget buildPageContent(BuildContext context, [SettingsMenuItemState state]) {
    return pageContentBuilder(context, state ?? initialState);
  }

  Widget buildControl(BuildContext context, [SettingsMenuItemState state]) {
    state = state ?? initialState;
    return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, value, _) => this.controlBuilder(
        context,
        state.copyWith(
          value: value,
          onChanged: _handleChanged
        )
      ),
    );
  }

  Widget buildPage(BuildContext context, [SettingsMenuItemState state]) {
    state = initialState.copyFrom(state);
    Widget title = label;
    Widget body = this.pageContentBuilder(context, state);
    return (this.pageBuilder ?? SettingsPage.pageBuilder)(
      context,
      title,
      body,
      state.onSearch
    );
  }

  Widget _build(BuildContext context, [SettingsMenuItemState state]) {
    state = initialState.copyFrom(state);

    if (needUpdateOnChanged) return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, value, _) => this.builder(
        context,
        state.copyWith(
          value: value,
          onChanged: _handleChanged
        )
      )
    );

    return this.builder(context, state);
  }

  Widget buildWith(BuildContext context, {
    bool selected,
    bool enabled,
    bool showTopDivider,
    bool showBottomDivider,
    VoidCallback onSearch,
    String selectedId
  }) {
    return _build(
      context,
      initialState.copyWith(
        enabled: enabled,
        selected: selected,
        showTopDivider: showTopDivider,
        showBottomDivider: showBottomDivider,
        onSearch: onSearch,
        selectedId: selectedId
      )
    );
  }

  @override
  Widget build(BuildContext context) => _build(context);
}

class SettingsMenu extends StatelessWidget {
  SettingsMenu({
    Key key,
    @required this.groupBuilder,
    this.enabled = true,
    this.scrolled = true,
    this.selectedId,
    this.onSearch,
  }) : super(key: key);

  final SettingsItemBuilder groupBuilder;
  final String selectedId;
  final bool enabled;
  final bool scrolled;
  final VoidCallback onSearch;

  Widget _buildItem(
    BuildContext context,
    SettingsMenuItem item,
    List<SettingsMenuItem> group
  ) {
    bool selected = selectedId == item.id;
    return item.buildWith(
      context,
      enabled: enabled,
      selected: selected,
      onSearch: onSearch,
      selectedId: selectedId,
      showTopDivider: Section.needShowTopDivider(
        context: context,
        item: item,
        group: group,
        hideWhenFirst: true
      ),
      showBottomDivider: Section.needShowBottomDivider(
        context: context,
        item: item,
        group: group,
        hideWhenLast: true
      )
    );
  }

  Widget _buildList(BuildContext context) {
    List<SettingsMenuItem> group = groupBuilder(context);
    return Column(
      children: group.map((item) => _buildItem(context, item, group)).toList(),
    );
  }

  Widget _buildListView(BuildContext context) {
    List<SettingsMenuItem> group = groupBuilder(context);
    return ListView.builder(
      itemCount: group.length,
      itemBuilder: (context, index) {
        SettingsMenuItem item = group[index];
        return _buildItem(context, item, group);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return scrolled ? _buildListView(context) : _buildList(context);
  }
}

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key key,
    this.title,
    @required this.groupBuilder,
    this.builder,
  }) : super(key: key);

  static String routeName = '/settings';
  static String routeTitle = 'Settings';

  final Widget title;
  final SettingsPageBuilder builder;
  final SettingsItemBuilder groupBuilder;

  void _showSearch(context) {
    showSearch(
      context: context,
      delegate: SettingsSearchDelegate(
        groupBuilder: groupBuilder
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return SettingsMenu(
      groupBuilder: groupBuilder,
      onSearch: () => _showSearch(context),
    );
  }

  static Widget pageBuilder(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onSearch
  ) {
    return Scaffold(
      appBar: AppBar(
        title: title ?? Text(routeTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: onSearch
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

class MultipleChoiceMenuItem<T> extends StatelessWidget {
  MultipleChoiceMenuItem({
    Key key,
    this.leading,
    @required this.label,
    this.secondaryTextBuilder,
    @required this.controlBuilder,
    @required this.choices,
    @required this.value,
    this.enabled = true,
    this.selected = false,
  }) : super(key: key);
  
  final Widget leading;
  final Text label;
  final ValueBuilder<List<Choice<T>>> secondaryTextBuilder;
  final WidgetBuilder controlBuilder;
  final List<Choice<T>> choices;
  final List<T> value;
  final bool enabled;
  final bool selected;
  
  Widget _buildDialog(BuildContext context) {
    return ConfirmationDialog(
      title: label,
      contentPadding: const EdgeInsets.only(top: 16.0),
      content: SizedBox(
        height: choices.length * _kListTileHeight,
        child: controlBuilder(context),
      ),
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildStatusText(BuildContext context) {
    List<Choice<T>> checkedChoices = choices.where(
      (choice) => value.contains(choice.value)
    ).toList();

    if (secondaryTextBuilder != null) {
      return secondaryTextBuilder(context, checkedChoices);
    } else {
      String statusText = checkedChoices.map(
        (choice) => choice.label.data
      ).join(', ');
      return Text(statusText);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: label,
      subtitle: _buildStatusText(context),
      onTap: () => showDialog(
        context: context,
        builder: _buildDialog
      ),
      selected: selected,
      enabled: enabled,
    );
  }
}

class Section extends StatelessWidget {
  Section({
    Key key,
    this.title,
    @required this.content,
    this.enabled = true,
    this.showTopDivider = true,
    this.showBottomDivider = true,
  }) : super(key: key);

  final Text title;
  final Widget content;
  final bool enabled;
  final bool showTopDivider;
  final bool showBottomDivider;
  Widget _buildTitle(BuildContext context) {
    if (title == null) return Container();

    return Container(
      alignment: Alignment.centerLeft,
      child: DefaultTextStyle(
        style: (title.style ?? Theme.of(context).textTheme.body1).copyWith(
          color: title.style?.color ?? Theme.of(context).primaryColor
        ),
        child: title,
      ),
      padding: const EdgeInsets.all(16.0).copyWith(
        left: 72.0,
        bottom: 8.0
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        showTopDivider ? Divider(height: _kDividerHeight) : Container(),
        _buildTitle(context),
        content,
        showBottomDivider ? Divider(height: _kDividerHeight) : Container(),
      ],
    );
  }

  static bool needShowTopDivider({
    @required BuildContext context,
    @required SettingsMenuItem item,
    @required List<SettingsMenuItem> group,
    bool hideWhenFirst = false
  }) {
    bool isNotSection = item.type != SettingsMenuItemType.section;
    if (isNotSection) return false;

    bool isFirst = item == group.first;
    if (hideWhenFirst && isFirst) return false;

    int itemIndex = group.indexOf(item);
    SettingsMenuItem previous = itemIndex > 0 ? group[itemIndex - 1] : null;

    bool isSectionPrevious = previous?.type == SettingsMenuItemType.section;
    if (isSectionPrevious) return false;

    bool isPageLinkPrevious = previous?.pageBuilder != null;
    if (isPageLinkPrevious) return true;

    bool isNotEmptyPrevious = previous?.groupBuilder != null;
    if (isNotEmptyPrevious) {
      List<SettingsMenuItem> previousGroup = previous.groupBuilder(context);
      bool isSectionLastPreviousItem = previousGroup?.last?.type == SettingsMenuItemType.section;
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
    bool isNotSection = item.type != SettingsMenuItemType.section;
    if (isNotSection) return false;

    bool isLast = item == group.last;
    if (hideWhenLast && isLast) return false;

    return true;
  }
}

class ConfirmationDialog extends StatelessWidget {
  ConfirmationDialog({
    this.title,
    this.content,
    this.contentPadding = const EdgeInsets.only(top: 16.0),
    this.confirmationText = 'Done',
    this.onConfirm
  });

  final Widget title;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final String confirmationText;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      contentPadding: contentPadding,
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(confirmationText)
        )
      ]
    );
  }
}

class SingleChoiceControl<T> extends StatelessWidget {
  SingleChoiceControl({
    Key key,
    @required this.choices,
    @required this.value,
    @required this.onChanged
  }) : super(key: key);

  final List<Choice<T>> choices;
  final T value;
  final ValueChanged<T> onChanged;

  Widget _buildRadioListTile(BuildContext context, int index) {
    Choice option = choices[index];
    return RadioListTile<T>(
      secondary: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: option.label,
      subtitle: option.secondaryText,
      value: option.value,
      groupValue: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.trailing
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: choices.length,
      itemBuilder: _buildRadioListTile
    );
  }
}

class MultipleChoiceControl<T> extends StatelessWidget {
  MultipleChoiceControl({
    Key key,
    @required this.choices,
    @required this.value,
    @required this.onChanged
  }) : super(key: key);

  final List<Choice<T>> choices;
  final List<T> value;
  final ValueChanged<List<T>> onChanged;

  Widget _buildCheckboxListTile(BuildContext context, int index) {
    Choice option = choices[index];
    bool checked = value.contains(option.value);
    return CheckboxListTile(
      title: option.label,
      subtitle: option.secondaryText,
      value: checked,
      onChanged: (bool checked) {
        List<T> _value = []..addAll(value);
        checked ? _value.add(option.value) : _value.remove(option.value);
        onChanged(_value);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: choices.length,
      itemBuilder: _buildCheckboxListTile
    );
  }
}

class SliderListTile extends StatelessWidget {
  const SliderListTile({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.title,
    this.trailing,
    this.dense,
    this.secondary,
    this.selected,
    this.semanticFormatterCallback
  }) : assert(value != null),
        assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(value >= min && value <= max),
        assert(divisions == null || divisions > 0),
        super(key: key);

  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final Color activeColor;
  final Color inactiveColor;
  final Widget title;
  final Widget trailing;
  final Widget secondary;
  final bool dense;
  final bool selected;
  final SemanticFormatterCallback semanticFormatterCallback;

  @override
  Widget build(BuildContext context) {
    bool enabled = onChanged != null || onChangeStart != null || onChangeEnd != null;
    return Stack(
      children: <Widget>[
        ListTile(
          leading: secondary,
          title: title,
          subtitle: Text(''),
          trailing: trailing,
          dense: dense,
          selected: selected,
          enabled: enabled,
        ),
        Positioned(
          top: title == null ? 12 : 24,
          left: secondary == null ? 0 : _kSecondaryWidth,
          right: trailing == null ? 0 : _kSecondaryWidth,
          child: Slider(
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
            semanticFormatterCallback: semanticFormatterCallback,
          )
        )
      ],
    );
  }
}

class DatePickerListTile extends StatelessWidget {
  DatePickerListTile({
    Key key,
    this.leading,
    @required this.label,
    this.secondaryTextBuilder,
    @required this.value,
    @required this.firstDate,
    @required this.lastDate,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final Widget leading;
  final Text label;
  final ValueBuilder<DateTime> secondaryTextBuilder;
  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool enabled;
  final bool selected;
  final ValueChanged<DateTime> onChanged;

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime newValue = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (newValue != null && newValue != value && onChanged != null) {
      onChanged(newValue);
    }
  }

  Widget _buildStatusText(BuildContext context) {
    if (secondaryTextBuilder != null)
      return secondaryTextBuilder(context, value);

    return Text(value.toLocal().toString());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: label,
      subtitle: _buildStatusText(context),
      onTap: () => _showDatePicker(context),
      selected: selected,
      enabled: enabled,
    );
  }
}

class DependencyControl extends StatelessWidget {
  DependencyControl({
    Key key,
    this.leading,
    @required this.title,
    this.secondaryTextBuilder,
    @required this.dependentBuilder,
    @required this.dependencyEnabled,
    this.enabled = true,
    this.selected = false,
    @required this.onChanged
  }) : super(key: key);

  final Widget leading;
  final Widget title;
  final ValueBuilder<bool> secondaryTextBuilder;
  final ValueBuilder<bool> dependentBuilder;
  final bool dependencyEnabled;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;

  Widget _buildSecondaryText(BuildContext context) {
    if (secondaryTextBuilder == null) return null;

    return secondaryTextBuilder(context, dependencyEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          secondary: leading ?? Icon(null),
          title: title,
          subtitle: _buildSecondaryText(context),
          value: dependencyEnabled,
          onChanged: enabled ? onChanged : null,
          selected: selected,
        ),
        dependentBuilder(context, dependencyEnabled)
      ],
    );
  }
}

class MasterSwitchListTile extends StatelessWidget {
  MasterSwitchListTile({
    Key key,
    this.leading,
    @required this.title,
    this.subtitle,
    this.showSwitch = true,
    @required this.value,
    this.enabled = true,
    this.selected = false,
    this.onChanged,
    this.onTap
  }) : super(key: key);
  
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final bool showSwitch;
  final bool value;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;

  Widget _buildSwitch(BuildContext context) {
    if (!showSwitch) return Container();

    return Container(
      child: Switch(
        value: value,
        onChanged: onChanged,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0
          )
        )
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      selected: selected,
      enabled: enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildListTile(context),
        ),
        _buildSwitch(context)
      ],
    );
  }
}

class MasterSwitchControl extends StatelessWidget {
  MasterSwitchControl({
    Key key,
    @required this.title,
    @required this.value,
    @required this.activeContentBuilder,
    @required this.inactiveContentBuilder,
    @required this.onChanged
  }) : super(key: key);

  final Text title;
  final bool value;
  final WidgetBuilder activeContentBuilder;
  final WidgetBuilder inactiveContentBuilder;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ContentSwitchControl(
      title: title,
      value: value,
      pageContentBuilder: value ? activeContentBuilder : inactiveContentBuilder,
      onChanged: onChanged,
    );
  }
}

class IndividualSwitchControl extends StatelessWidget {
  IndividualSwitchControl({
    Key key,
    @required this.secondaryTextBuilder,
    @required this.value,
    @required this.onChanged,
    @required this.description
  }) : super(key: key);

  final ValueBuilder secondaryTextBuilder;
  final bool value;
  final Widget description;
  final ValueChanged<bool> onChanged;

  Widget _buildTitle(BuildContext context) {
    return secondaryTextBuilder(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return ContentSwitchControl(
      title: _buildTitle(context),
      value: value,
      pageContentBuilder: (context) => Container(
        padding: const EdgeInsets.only(
          left: 72,
          right: 16.0,
          top: 16.0,
          bottom: 16.0
        ),
        child: description,
      ),
      onChanged: onChanged,
    );
  }
}

class ContentSwitchControl extends StatelessWidget {
  ContentSwitchControl({
    Key key,
    @required this.title,
    @required this.value,
    @required this.pageContentBuilder,
    @required this.onChanged
  }) : super(key: key);

  final Text title;
  final bool value;
  final WidgetBuilder pageContentBuilder;
  final ValueChanged<bool> onChanged;

  Widget _buildControl(BuildContext context) {
    return Container(
      child: SwitchListTile(
        secondary: Visibility(
          visible: false,
          child: CircleAvatar()
        ),
        title: DefaultTextStyle(
          style: (title.style ?? Theme.of(context).textTheme.subhead).copyWith(
            color: title.style?.color ?? Theme.of(context).colorScheme.onBackground,
            fontWeight: title.style?.fontWeight ?? FontWeight.w500
          ),
          child: title,
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.onBackground,
        inactiveThumbColor: Theme.of(context).colorScheme.onBackground,
      ),
      decoration: BoxDecoration(
        color: value
          ? Theme.of(context).indicatorColor
          : Theme.of(context).disabledColor
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: pageContentBuilder(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildControl(context),
        _buildContent(context)
      ],
    );
  }
}












class Suggestion {
  Suggestion({
    @required this.item,
    this.pageBuilder,
    this.parentsTitles,
  });

  final SettingsMenuItem item;
  final SettingsStateBuilder pageBuilder;
  final List<String> parentsTitles;
}

class SettingsSearchDelegate extends SearchDelegate<SettingsMenuItem> {
  SettingsSearchDelegate({
    @required this.groupBuilder
  });

  final SettingsItemBuilder groupBuilder;
  final Iterable<Suggestion> _history = [];

  void _showSearch(context) {
    showSearch(
      context: context,
      delegate: SettingsSearchDelegate(
        groupBuilder: groupBuilder
      )
    );
  }

  Iterable<SettingsMenuItem> _getResults(BuildContext context) {
    return groupBuilder(context).where(
      (item) => item.label != null && item.label.data.contains(query)
    ).toList();
  }

  List<Suggestion> _getSuggestions(BuildContext context, {
    SettingsStateBuilder pageBuilder,
    SettingsMenuItem parent,
    List<Suggestion> suggestions,
    List<String> parentsTitles
  }) {
    List<SettingsMenuItem> data = parent != null ? parent.groupBuilder(context) : this.groupBuilder(context);
    parentsTitles = parentsTitles ?? [];
    suggestions = suggestions ?? [];

    data.forEach((item) {
      List<String> itemParentsTitles;
      bool isPage = item.pageContentBuilder != null;

      if ((item.label?.data ?? '').startsWith(query)) {
        suggestions.add(
          Suggestion(
            pageBuilder: pageBuilder,
            item: item,
            parentsTitles: parentsTitles
          )
        );
      }

      if (item.groupBuilder != null) {
        if (isPage) {
          itemParentsTitles = []
            ..addAll(parentsTitles)
            ..add(item.label.data);
        }

        _getSuggestions(
          context,
          parent: item,
          pageBuilder: isPage ? item.buildPage : pageBuilder,
          suggestions: suggestions,
          parentsTitles: itemParentsTitles
        );
      }
    });

    return suggestions;
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget _buildPage(BuildContext context, Suggestion suggestion) {
    VoidCallback showSearch = () => _showSearch(context);

    if (suggestion.pageBuilder != null) {
      return suggestion.pageBuilder(
          context,
          SettingsMenuItemState(
            selectedId: suggestion.item.id,
            onSearch: showSearch
          )
      );
    }

    return SettingsPage.pageBuilder(
      context,
      null,
      SettingsMenu(
        groupBuilder: this.groupBuilder,
        selectedId: suggestion.item.id,
        onSearch: showSearch,
      ),
      showSearch
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final Iterable<Suggestion> suggestions = query.isEmpty
        ? _history
        : _getSuggestions(context);

    return _SuggestionList(
      query: query,
      suggestions: suggestions,
      onSelected: (Suggestion suggestion) {
        close(context, null);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _buildPage(context, suggestion)
          )
        );
        //showResults(context);
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Text(
        '"$query"\n has no results',
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Iterable<SettingsMenuItem> results = _getResults(context);

    if (query == null || results.isEmpty) return _buildEmpty(context);

    return ListView(
      children: results.map((item) => _ResultCard(
        item: item,
        searchDelegate: this,
      )).toList()
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? Container()
          : IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
      PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: ListTile(
              title: Text('Clear history'),
            ),
          )
        ],
      )
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.item, this.searchDelegate});

  final SettingsMenuItem item;
  final SearchDelegate<SettingsMenuItem> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, item);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${item.label}',
            style: theme.textTheme.headline.copyWith(fontSize: 72.0),
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final Iterable<Suggestion> suggestions;
  final String query;
  final ValueChanged<Suggestion> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final Suggestion suggestion = suggestions.elementAt(i);
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.item.label.data.substring(0, query.length),
              style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.item.label.data.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          subtitle: Text(suggestion.parentsTitles.join(' > ')),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}