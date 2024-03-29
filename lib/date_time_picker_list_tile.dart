import 'package:flutter/material.dart';
import 'types.dart';

class DateTimePickerListTile extends StatelessWidget {
  DateTimePickerListTile({
    Key key,
    this.leading,
    @required this.title,
    this.statusTextBuilder,
    @required this.value,
    @required this.firstDate,
    @required this.lastDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.selectableDayPredicate,
    this.locale,
    this.textDirection,
    this.builder,
    this.enabled = true,
    this.selected = false,
    @required this.onChanged
  }) :
    assert(title != null),
    assert(enabled != null),
    assert(selected != null),
    assert(value != null),
    assert(firstDate != null),
    assert(lastDate != null),
    assert(!value.isBefore(firstDate), 'value must be on or after firstDate'),
    assert(!value.isAfter(lastDate), 'value must be on or before lastDate'),
    assert(!firstDate.isAfter(lastDate), 'lastDate must be on or after firstDate'),
    assert(selectableDayPredicate == null || selectableDayPredicate(value),
    'Provided value must satisfy provided selectableDayPredicate'),
    assert(initialDatePickerMode != null, 'initialDatePickerMode must not be null'),
    super(key: key);

  final Widget leading;
  final Widget title;
  final ValueBuilder<DateTime> statusTextBuilder;
  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final DatePickerMode initialDatePickerMode;
  final SelectableDayPredicate selectableDayPredicate;
  final Locale locale;
  final TextDirection textDirection;
  final TransitionBuilder builder;
  final bool enabled;
  final bool selected;
  final ValueChanged<DateTime> onChanged;

  Future<DateTime> _showDatePicker(BuildContext context) async {
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: value,
        firstDate: firstDate,
        lastDate: lastDate,
        selectableDayPredicate: selectableDayPredicate,
        initialDatePickerMode: initialDatePickerMode,
        locale: locale,
        textDirection: textDirection,
        builder: builder
    );

    if (newDate == null) return null;

    return DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        value.hour,
        value.minute,
        value.second,
        value.millisecond,
        value.microsecond
    );
  }

  Future<DateTime> _showTimePicker(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.fromDateTime(value);
    TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: builder
    );

    if (newTime == null) return null;

    return DateTime(
        value.year,
        value.month,
        value.day,
        newTime.hour,
        newTime.minute,
        value.second,
        value.millisecond,
        value.microsecond
    );
  }

  Future<DateTime> _showDateTimePicker(BuildContext context) async {
    DateTime newDate = await _showDatePicker(context);

    if (newDate == null) return null;

    DateTime newTime = await _showTimePicker(context) ?? value;

    return DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        newTime.hour,
        newTime.minute,
        value.second,
        value.millisecond,
        value.microsecond
    );
  }

  void _handleChanged(DateTime newValue) {
    if (onChanged != null && newValue != null && newValue != value)
      onChanged(newValue);
  }

  Widget _buildStatusText(BuildContext context) {
    if (statusTextBuilder != null)
      return statusTextBuilder(context, value);

    RegExp millisecondsRegExp = RegExp('\.[0-9]{3}\$');
    String subtitle = value.toLocal()
        .toString()
        .replaceAll(millisecondsRegExp, '');
    return Text(
        subtitle,
        softWrap: false,
        overflow: TextOverflow.ellipsis
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: _buildStatusText(context),
      onTap: () async => _handleChanged(await _showDateTimePicker(context)),
      selected: selected,
      enabled: enabled,
    );
  }

  Widget _buildActions(BuildContext context) {
    Color color = enabled
        ? Theme.of(context).indicatorColor
        : Theme.of(context).disabledColor;
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.calendar_today, color: color),
          onPressed: enabled
              ? () async => _handleChanged(await _showDatePicker(context))
              : null,
        ),
        IconButton(
          icon: Icon(Icons.access_time, color: color),
          onPressed: enabled
              ? () async => _handleChanged(await _showTimePicker(context))
              : null,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildListTile(context),
        ),
        Container(
          child: _buildActions(context),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1.0
                  )
              )
          ),
        )
      ],
    );
  }
}