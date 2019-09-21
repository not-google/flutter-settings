import 'package:flutter/material.dart';
import 'settings_localizations.dart';
import 'types.dart';
import 'choice.dart';
import 'settings_page.dart';
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

typedef SettingsGroupBuilder<T> = List<SettingsMenuItem<T>> Function(BuildContext context);
typedef SettingsStateBuilder = Widget Function(BuildContext context, SettingsMenuItemState state);

enum SettingsMenuItemPattern {
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

abstract class SettingsMenuEntry<T> extends StatelessWidget {
  SettingsMenuEntry({
    Key key,
    this.id,
    @required this.label,
    @required this.enabled,
    @required this.initialValue,
    @required this.builder,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.controlBuilder,
    this.pageBuilder,
    this.pageContentBuilder,
    this.groupBuilder,
    this.controlSeparated = false,
    @required this.pattern,
  });

  final String id;
  final Text label;
  final bool enabled;
  final initialValue;
  final onChanged;
  final onChangeStart;
  final onChangeEnd;
  final SettingsStateBuilder builder;
  final SettingsStateBuilder controlBuilder;
  final SettingsStateBuilder pageContentBuilder;
  final SettingsPageBuilder pageBuilder;
  final SettingsGroupBuilder groupBuilder;
  final bool controlSeparated;
  final SettingsMenuItemPattern pattern;
}

class SettingsMenuItemState {
  SettingsMenuItemState({
    this.selected,
    this.enabled,
    this.showTopDivider,
    this.showBottomDivider,
    this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
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
  final onChangeStart;
  final onChangeEnd;
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
    onChangeStart,
    onChangeEnd,
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
      onChangeStart: onChangeStart ?? this.onChangeStart,
      onChangeEnd: onChangeEnd ?? this.onChangeEnd,
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
      onChanged: onChanged ?? this.onChanged,
      onChangeStart: onChangeStart ?? this.onChangeStart,
      onChangeEnd: onChangeEnd ?? this.onChangeEnd,
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
  SettingsMenuItem.simpleSwitch({
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
        ? (state.onChanged ?? (value) => null)
        : null
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsMenuItemPattern.simpleSwitch
  );

  SettingsMenuItem.section({
    Key key,
    Widget title,
    @required SettingsGroupBuilder groupBuilder,
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
    pattern: SettingsMenuItemPattern.section
  );

  SettingsMenuItem.singleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<Choice<T>> statusTextBuilder,
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
      Widget secondaryText = (statusTextBuilder != null)
        ? statusTextBuilder(context, selectedChoice)
        : selectedChoice.label;
      return ListTile(
        leading: leading ?? Icon(null),
        title: label,
        subtitle: secondaryText,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => state.pageBuilder(context, state)
          )
        ),
        selected: state.selected,
        enabled: state.enabled,
      );
    },
    controlBuilder: (context, state) => SingleChoice<T>(
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
    controlSeparated: true,
    pattern: SettingsMenuItemPattern.singleChoice
  );

  SettingsMenuItem.multipleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<List<Choice<T>>> statusTextBuilder,
    @required List<Choice<T>> choices,
    @required List<T> initialValue,
    bool enabled = true,
    ValueChanged<List<T>> onChanged
  }) : super(
    key: key,
    builder: (context, state) => MultipleChoiceListTile<T>(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      controlBuilder: (context) => state.controlBuilder(context, state),
      choices: choices,
      value: state.value,
      enabled: state.enabled,
      selected: state.selected,
    ),
    controlBuilder: (context, state) =>  MultipleChoice<T>(
      choices: choices,
      value: state.value,
      onChanged: state.onChanged
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    controlSeparated: true,
    pattern: SettingsMenuItemPattern.multipleChoice
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
    Color activeColor,
    Color inactiveColor,
    SemanticFormatterCallback semanticFormatterCallback,
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
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      semanticFormatterCallback: semanticFormatterCallback,
      onChanged: state.enabled ? state.onChanged : null,
      onChangeStart: state.enabled ? state.onChangeStart : null,
      onChangeEnd: state.enabled ? state.onChangeEnd : null,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    onChangeStart: onChangeStart,
    onChangeEnd: onChangeEnd,
    pattern: SettingsMenuItemPattern.slider
  );

  SettingsMenuItem.date({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<DateTime> statusTextBuilder,
    @required DateTime initialValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    SelectableDayPredicate selectableDayPredicate,
    Locale locale,
    TextDirection textDirection,
    TransitionBuilder builder,
    bool enabled = true,
    ValueChanged<DateTime> onChanged
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context, state),
    controlBuilder: (context, state) => DatePickerListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      value: state.value,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: initialDatePickerMode,
      selectableDayPredicate: selectableDayPredicate,
      locale: locale,
      textDirection: textDirection,
      builder: builder,
      enabled: state.enabled,
      selected: state.selected,
      onChanged: state.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsMenuItemPattern.date
  );

  SettingsMenuItem.time({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<TimeOfDay> statusTextBuilder,
    @required TimeOfDay initialValue,
    TransitionBuilder builder,
    bool enabled = true,
    ValueChanged<TimeOfDay> onChanged
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context, state),
    controlBuilder: (context, state) => TimePickerListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      value: state.value,
      builder: builder,
      enabled: state.enabled,
      selected: state.selected,
      onChanged: state.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsMenuItemPattern.time
  );

  SettingsMenuItem.dateTime({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<DateTime> statusTextBuilder,
    @required DateTime initialValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    SelectableDayPredicate selectableDayPredicate,
    Locale locale,
    TextDirection textDirection,
    TransitionBuilder builder,
    bool enabled = true,
    ValueChanged<DateTime> onChanged
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context, state),
    controlBuilder: (context, state) => DateTimePickerListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      value: state.value,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: initialDatePickerMode,
      selectableDayPredicate: selectableDayPredicate,
      locale: locale,
      textDirection: textDirection,
      builder: builder,
      enabled: state.enabled,
      selected: state.selected,
      onChanged: state.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsMenuItemPattern.dateTime
  );

  SettingsMenuItem.listSubpage({
    Key key,
    @required String id,
    @required Text label,
    Widget leading,
    Widget secondaryText,
    @required SettingsGroupBuilder groupBuilder,
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
    pageContentBuilder: (context, state) => SettingsMenu(
      groupBuilder: groupBuilder,
      onSearch: state.onSearch,
      selectedId: state.selectedId,
    ),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    groupBuilder: groupBuilder,
    pattern: SettingsMenuItemPattern.listSubpage
  );

  SettingsMenuItem.masterSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    Text switchTitle,
    ValueBuilder<bool> statusTextBuilder,
    @required WidgetBuilder inactiveBuilder,
    bool duplicateSwitch = false,
    @required SettingsGroupBuilder groupBuilder,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged,
    @required SettingsPageBuilder pageBuilder
  }) : super(
    key: key,
    builder: (context, state) => MasterSwitchListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      showSwitch: duplicateSwitch,
      value: state.value,
      enabled: state.enabled,
      selected: state.selected,
      onChanged: state.onChanged,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => state.pageBuilder(context, state)
        )
      ),
    ),
    controlBuilder: (context, state) => MasterSwitch(
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
        child: inactiveBuilder(context),
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
    controlSeparated: true,
    pattern: SettingsMenuItemPattern.masterSwitch
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
      subtitle: Text(
        state.value
          ? SettingsLocalizations.activeLabel
          : SettingsLocalizations.inactiveLabel
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => state.pageBuilder(context, state)
        )
      ),
      selected: state.selected,
      enabled: state.enabled,
    ),
    controlBuilder: (context, state) => IndividualSwitch(
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
    controlSeparated: true,
    pattern: SettingsMenuItemPattern.individualSwitch
  );

  SettingsMenuItem.dependency({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<bool> statusTextBuilder,
    @required SettingsGroupBuilder groupBuilder,
    @required bool initialValue,
    ValueChanged<bool> onChanged,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context, state),
    controlBuilder: (context, state) => Dependency(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
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
    pattern: SettingsMenuItemPattern.dependency
  );

  SettingsMenuItemState get initialState => SettingsMenuItemState(
    selected: false,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    onChangeStart: onChangeStart,
    onChangeEnd: onChangeEnd,
    controlBuilder: buildControl,
    pageBuilder: buildPage,
    pageContentBuilder: buildPageContent
  );

  final ValueNotifier _valueNotifier = ValueNotifier(null);
  void _handleChanged(newValue) {
    if (onChanged != null) onChanged(newValue);
    _valueNotifier.value = newValue;
  }

  Widget _buildValueListenable(
    BuildContext context,
    SettingsStateBuilder builder,
    [SettingsMenuItemState state]
  ) => ValueListenableBuilder(
    valueListenable: _valueNotifier,
    builder: (context, value, _) => builder(
      context,
      initialState.copyFrom(state).copyWith(
        value: value,
        onChanged: _handleChanged,
      )
    )
  );

  Widget buildPageContent(BuildContext context, [SettingsMenuItemState state])
    => pageContentBuilder(context, initialState.copyFrom(state));

  Widget buildControl(BuildContext context, [SettingsMenuItemState state])
    => _buildValueListenable(
    context,
    this.controlBuilder,
    initialState.copyFrom(state)
  );

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

  Widget buildWith(BuildContext context, {
    bool dependencyEnabled,
    bool showTopDivider,
    bool showBottomDivider,
    VoidCallback onSearch,
    String selectedId
  }) {
    return _build(
      context,
      initialState.copyWith(
        enabled: enabled == false ? false : dependencyEnabled,
        selected: id == selectedId,
        showTopDivider: showTopDivider,
        showBottomDivider: showBottomDivider,
        onSearch: onSearch,
        selectedId: selectedId
      )
    );
  }

  Widget _build(BuildContext context, [SettingsMenuItemState state]) {
    return controlSeparated
      ? _buildValueListenable(context, this.builder, initialState.copyFrom(state))
      : this.builder(context, initialState.copyFrom(state));
  }

  @override
  Widget build(BuildContext context) => _build(context);
}