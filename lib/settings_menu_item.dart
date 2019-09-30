//import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'settings_localizations.dart';
import 'types.dart';
import 'choice.dart';
import 'settings_page_route.dart';
import 'settings_menu.dart';
import 'section.dart';
import 'single_choice.dart';
import 'multiple_choice.dart';
import 'multiple_choice_list_tile.dart';
import 'slider_list_tile.dart';
import 'date_picker_list_tile.dart';
import 'time_picker_list_tile.dart';
import 'date_time_picker_list_tile.dart';
import 'master_switch.dart';
import 'master_switch_list_tile.dart';
import 'individual_switch.dart';
import 'dependency.dart';

typedef SettingsGroupBuilder = List<SettingsMenuItemBuilder> Function(BuildContext context);
typedef SettingsGroupItemBuilder = SettingsMenuItemBuilder Function(
  BuildContext context,
  SettingsMenuItemBuilder item
);
typedef WidgetStateBuilder<T> = Widget Function(BuildContext context, T widget);
typedef SettingsMenuItemStateBuilder = Widget Function(
    BuildContext context,
    SettingsMenuItemBuilder widget
);
// return value
typedef ValueGetter<T> = FutureOr<T> Function();
// return bool of success or failed saved
typedef ValueSetter<T> = FutureOr<bool> Function(T value);

enum SettingsPattern {
  custom,
  simpleSwitch,
  section,
  // Selection Patterns
  singleChoice,
  multipleChoice,
  slider,
  date,
  time,
  dateTime,
  listSubpage,
  masterSwitch,
  individualSwitch,
  dependency
}

const List<SettingsPattern> patternsWithSeparatedControls = [
  SettingsPattern.multipleChoice,
  SettingsPattern.singleChoice,
  SettingsPattern.masterSwitch,
  SettingsPattern.individualSwitch
];

class SettingsMenuItemBuilder extends StatelessWidget {
  SettingsMenuItemBuilder({
    @required this.key,
    this.title,
    @required this.builder,
    @required this.defaultValue,
    this.value,
    this.enabled = true,
    this.onShowSearch,
    //this.onGetInitialValue,
    this.onGetValue,
    this.onSetValue,
    this.controlBuilder,
    this.pageBuilder = SettingsPageRoute.pageBuilder,
    this.pageContentBuilder,
    this.groupBuilder,
    this.itemBuilder,
    this.selectedKey,
    this.showTopDivider = true,
    this.showBottomDivider = true,
    this.loading = false,
    this.pattern,
  }) :
    assert(key != null),
    assert(builder != null),
    assert(pageBuilder != null),
    super(key: key);

  final Key key;
  final Text title;
  final bool enabled;
  final defaultValue;
  final value;
  final VoidCallback onShowSearch;
  //final OnGetInitialValue onGetInitialValue;
  final ValueGetter onGetValue;
  final ValueSetter onSetValue;
  final SettingsMenuItemStateBuilder builder;
  final SettingsMenuItemStateBuilder controlBuilder;
  final SettingsMenuItemStateBuilder pageContentBuilder;
  final SettingsPageRouteBuilder pageBuilder;
  final SettingsGroupBuilder groupBuilder;
  final SettingsGroupItemBuilder itemBuilder;
  final Key selectedKey;
  final bool showTopDivider;
  final bool showBottomDivider;
  final bool loading;
  final SettingsPattern pattern;

  bool get selected => selectedKey != null && selectedKey == key;
  // Whether the widget control is separated from the menu item and requires
  // a separated rebuild (example: widget is part of subpage)
  bool get separated => patternsWithSeparatedControls.contains(pattern);

  SettingsMenuItemBuilder copyWith({
    Key key,
    Text title,
    bool enabled,
    defaultValue,
    value,
    //OnGetInitialValue onGetInitialValue,
    ValueGetter onGetValue,
    ValueSetter onSetValue,
    VoidCallback onShowSearch,
    SettingsMenuItemStateBuilder builder,
    SettingsMenuItemStateBuilder controlBuilder,
    SettingsMenuItemStateBuilder pageContentBuilder,
    SettingsPageRouteBuilder pageBuilder,
    SettingsGroupBuilder groupBuilder,
    SettingsGroupItemBuilder itemBuilder,
    Key selectedKey,
    bool showTopDivider,
    bool showBottomDivider,
    bool loading,
    SettingsPattern pattern
  }) => SettingsMenuItemBuilder(
      key: key ?? this.key,
      title: title ?? this.title,
      enabled: enabled ?? this.enabled,
      defaultValue: defaultValue ?? this.defaultValue,
      value: value ?? this.value,
      //onGetInitialValue: onGetInitialValue ?? this.onGetInitialValue,
      onGetValue: onGetValue ?? this.onGetValue,
      onSetValue: onSetValue ?? this.onSetValue,
      builder: builder ?? this.builder,
      controlBuilder: controlBuilder ?? this.controlBuilder,
      pageContentBuilder: pageContentBuilder ?? this.pageContentBuilder,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      groupBuilder: groupBuilder ?? this.groupBuilder,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      selectedKey: selectedKey ?? this.selectedKey,
      onShowSearch: onShowSearch ?? this.onShowSearch,
      showTopDivider: showTopDivider ?? this.showTopDivider,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      loading: loading ?? this.loading,
      pattern: pattern ?? this.pattern
  );

  //dynamic getInitialValue() => onGetInitialValue != null ? onGetInitialValue() : value;
  ValueGetter get getValue => onGetValue;
  ValueSetter get setValue => onSetValue;

  SettingsMenuItemBuilder buildItem(BuildContext context, SettingsMenuItemBuilder item) {
    return itemBuilder != null ? itemBuilder(context, item) : item;
  }

  SettingsMenuItemBuilder makeStateful() {
    var _loadingValue = getValue == null ? null : getValue();
    var initialValue = _loadingValue is Future ? defaultValue : _loadingValue;
    ValueNotifier _notifier = ValueNotifier(initialValue);

    if (_loadingValue is Future)
      _loadingValue.then((value) => _notifier.value = value);

    Future<bool> handleSetValue(newValue) async {
      if (setValue == null) return false;

      bool saved = await setValue(newValue);

      if (!saved) return false;
      //if (onSetValue != null) onSetValue(newValue);
      _notifier.value = newValue;
      return saved;
    }

    statefulBuilder(SettingsMenuItemStateBuilder builder)
      => (BuildContext context, SettingsMenuItemBuilder widget)
      => ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (context, newValue, _) => builder(
            context,
            widget.copyWith(
              value: newValue
            )
          )
        );

    return this.copyWith(
        builder: statefulBuilder(builder),
        controlBuilder: separated ? statefulBuilder(controlBuilder) : controlBuilder,
        //onSetValue: handleChangeSaved,
        onSetValue: handleSetValue,
        loading: true
    );
  }

  Widget buildControl(BuildContext context) {
    return controlBuilder(context, this.copyWith(
      value: value ?? defaultValue
    ));
  }

  Widget buildPage(BuildContext context) {
    return pageBuilder(
        context,
        title,
        pageContentBuilder(context, this),
        onShowSearch
    );
  }

  @override
  Widget build(BuildContext context) => builder(context, this);
}

class SettingsMenuItem extends SettingsMenuItemBuilder {
  SettingsMenuItem.custom({
    @required Key key,
    @required SettingsMenuItemStateBuilder builder,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
    SettingsMenuItemStateBuilder controlBuilder,
    SettingsMenuItemStateBuilder pageContentBuilder,
    SettingsGroupBuilder groupBuilder,
    Text title,
    @required String defaultValue,
    bool enabled = true,
    ValueSetter<String> onSetValue,
  }) : super(
    key: key,
    title: title,
    defaultValue: defaultValue,
    enabled: enabled,
    onSetValue: onSetValue,
    groupBuilder: groupBuilder,
    builder: builder,
    controlBuilder: controlBuilder,
    pageBuilder: pageBuilder,
    pageContentBuilder: pageContentBuilder
  );

  SettingsMenuItem.simpleSwitch({
    @required Key key,
    Widget leading,
    @required Text title,
    Widget subtitle,
    @required bool defaultValue,
    bool enabled = true,
    ValueSetter<bool> onSetValue,
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => SwitchListTile(
      secondary: leading ?? Icon(null),
      title: title,
      subtitle: subtitle,
      value: widget.value,
      selected: widget.selected,
      onChanged: widget.enabled
        ? (widget.onSetValue ?? (value) => null)
        : null
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    onSetValue: onSetValue,
    pattern: SettingsPattern.simpleSwitch
  );

  SettingsMenuItem.section({
    @required Key key,
    Text title,
    @required SettingsGroupBuilder groupBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => Section(
      title: title,
      content: SettingsMenu(
        type: SettingsMenuType.column,
        groupBuilder: groupBuilder,
        itemBuilder: (context, item) => widget.buildItem(context, item).copyWith(
          enabled: widget.enabled
        )
      ),
      enabled: widget.enabled,
      showTopDivider: widget.showTopDivider,
      showBottomDivider: widget.showBottomDivider
    ),
    enabled: enabled,
    defaultValue: null,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.section
  );

  SettingsMenuItem.singleChoice({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<Choice> statusTextBuilder,
    @required List<Choice> choices,
    @required String defaultValue,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
    bool enabled = true,
    ValueSetter<String> onSetValue
  }) : super(
    key: key,
    builder: (context, widget) {
      String value = widget.value;
      Choice selectedChoice = choices.firstWhere((choice) => choice.value == value);
      Widget subtitle = (statusTextBuilder != null)
        ? statusTextBuilder(context, selectedChoice)
        : selectedChoice.title;
      return ListTile(
        leading: leading ?? Icon(null),
        title: title,
        subtitle: subtitle,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: widget.buildPage
          )
        ),
        selected: widget.selected,
        enabled: widget.enabled,
      );
    },
    controlBuilder: (context, widget) => SingleChoice(
      choices: choices,
      value: widget.value,
      onChanged: widget.onSetValue,
    ),
    pageContentBuilder: (context, widget) => widget.buildControl(context),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    pattern: SettingsPattern.singleChoice
  );

  SettingsMenuItem.multipleChoice({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<List<Choice>> statusTextBuilder,
    @required List<Choice> choices,
    @required List<String> defaultValue,
    bool enabled = true,
    ValueSetter<List<String>> onSetValue
  }) : super(
    key: key,
    builder: (context, widget) => MultipleChoiceListTile(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      controlBuilder: (context) => widget.buildControl(context),
      choices: choices,
      value: widget.value,
      enabled: widget.enabled,
      selected: widget.selected,
    ),
    controlBuilder: (context, widget) =>  MultipleChoice(
      choices: choices,
      value: widget.value,
      onChanged: widget.onSetValue
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    pattern: SettingsPattern.multipleChoice
  );

  SettingsMenuItem.slider({
    @required Key key,
    Widget leading,
    @required Text title,
    Widget subtitle,
    @required double defaultValue,
    double min = 0.0,
    double max = 1.0,
    int divisions,
    Color activeColor,
    Color inactiveColor,
    SemanticFormatterCallback semanticFormatterCallback,
    ValueSetter<double> onSetValue,
    ValueSetter<double> onChangeStart,
    ValueSetter<double> onChangeEnd,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => SliderListTile(
      secondary: leading ?? Icon(null),
      title: title,
      value: widget.value,
      selected: widget.selected,
      min: min,
      max: max,
      divisions: divisions,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      semanticFormatterCallback: semanticFormatterCallback,
      onChanged: widget.enabled ? widget.onSetValue : null,
      onChangeStart: widget.enabled ? onChangeStart : null,
      onChangeEnd: widget.enabled ? onChangeEnd : null,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    pattern: SettingsPattern.slider
  );

  SettingsMenuItem.date({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<DateTime> statusTextBuilder,
    @required DateTime defaultValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    SelectableDayPredicate selectableDayPredicate,
    Locale locale,
    TextDirection textDirection,
    TransitionBuilder builder,
    bool enabled = true,
    ValueSetter<DateTime> onSetValue
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => DatePickerListTile(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      value: widget.value,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: initialDatePickerMode,
      selectableDayPredicate: selectableDayPredicate,
      locale: locale,
      textDirection: textDirection,
      builder: builder,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onSetValue,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    pattern: SettingsPattern.date
  );

  SettingsMenuItem.time({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<TimeOfDay> statusTextBuilder,
    @required TimeOfDay defaultValue,
    TransitionBuilder builder,
    bool enabled = true,
    ValueSetter<TimeOfDay> onSetValue
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => TimePickerListTile(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      value: widget.value,
      builder: builder,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onSetValue,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    pattern: SettingsPattern.time
  );

  SettingsMenuItem.dateTime({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<DateTime> statusTextBuilder,
    @required DateTime defaultValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    SelectableDayPredicate selectableDayPredicate,
    Locale locale,
    TextDirection textDirection,
    TransitionBuilder builder,
    bool enabled = true,
    ValueSetter<DateTime> onSetValue
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => DateTimePickerListTile(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      value: widget.value,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: initialDatePickerMode,
      selectableDayPredicate: selectableDayPredicate,
      locale: locale,
      textDirection: textDirection,
      builder: builder,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onSetValue,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    pattern: SettingsPattern.dateTime
  );

  SettingsMenuItem.listSubpage({
    @required Key key,
    @required Text title,
    Widget leading,
    Widget subtitle,
    @required SettingsGroupBuilder groupBuilder,
    SettingsPageRouteBuilder pageBuilder  = SettingsPageRoute.pageBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => ListTile(
      leading: leading ?? Icon(null),
      title: title,
      subtitle: subtitle,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: widget.buildPage
        )
      ),
      selected: widget.selected,
      enabled: widget.enabled,
    ),
    pageContentBuilder: (context, widget) => SettingsMenu(
      groupBuilder: groupBuilder,
      itemBuilder: widget.buildItem
    ),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: null,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.listSubpage
  );

  SettingsMenuItem.masterSwitch({
    @required Key key,
    Widget leading,
    @required Text title,
    Text switchTitle,
    ValueBuilder<bool> statusTextBuilder,
    @required WidgetBuilder inactiveBuilder,
    bool duplicateSwitch = false,
    @required SettingsGroupBuilder groupBuilder,
    @required bool defaultValue,
    bool enabled = true,
    ValueSetter<bool> onSetValue,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder
  }) : super(
    key: key,
    builder: (context, widget) => MasterSwitchListTile(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      showSwitch: duplicateSwitch,
      value: widget.value,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onSetValue,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: widget.buildPage
        )
      ),
    ),
    controlBuilder: (context, widget) => MasterSwitch(
      title: switchTitle ?? Text('Use ${title.data}'),
      value: widget.value,
      onChanged: widget.onSetValue,
      activeContentBuilder: (context) => SettingsMenu(
        groupBuilder: groupBuilder,
        itemBuilder: widget.buildItem,
      ),
      inactiveContentBuilder: (context) => Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(16.0).copyWith(left: 72.0),
        child: inactiveBuilder(context),
      )
    ),
    pageContentBuilder: (context, widget)
      => widget.buildControl(context),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    @required Key key,
    Widget leading,
    @required Text title,
    @required Widget description,
    @required bool defaultValue,
    bool enabled = true,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
    ValueSetter<bool> onSetValue
  }) : super(
    key: key,
    builder: (context, widget) => ListTile(
      leading: leading ?? Icon(null),
      title: title,
      subtitle: Text(
        widget.value
          ? SettingsLocalizations.activeLabel
          : SettingsLocalizations.inactiveLabel
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: widget.buildPage
        )
      ),
      selected: widget.selected,
      enabled: widget.enabled,
    ),
    controlBuilder: (context, widget) => IndividualSwitch(
      value: widget.value,
      description: description,
      onChanged: widget.onSetValue,
    ),
    pageContentBuilder: (context, widget) => widget.buildControl(context),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    pattern: SettingsPattern.individualSwitch
  );

  SettingsMenuItem.dependency({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<bool> statusTextBuilder,
    @required SettingsGroupBuilder groupBuilder,
    @required bool defaultValue,
    ValueSetter<bool> onSetValue,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => Dependency(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      dependentBuilder: (context, dependencyEnabled) => SettingsMenu(
        type: SettingsMenuType.column,
        groupBuilder: groupBuilder,
        itemBuilder: (context, item)
          => widget.buildItem(context, item).copyWith(
            enabled: item.enabled == false ? false : dependencyEnabled,
          )
      ),
      dependencyEnabled: widget.value,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onSetValue,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onSetValue: onSetValue,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.dependency
  );
}