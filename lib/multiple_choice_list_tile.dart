import 'package:flutter/material.dart';
import 'settings_localizations.dart';
import 'types.dart';
import 'choice.dart';

const double _kListTileHeight = 56.0;

class MultipleChoiceListTile extends StatelessWidget {
  MultipleChoiceListTile({
    Key key,
    this.leading,
    @required this.title,
    this.statusTextBuilder,
    @required this.controlBuilder,
    @required this.choices,
    @required this.value,
    this.enabled = true,
    this.selected = false,
  }) :
    assert(title != null),
    assert(controlBuilder != null),
    assert(choices != null),
    assert(value != null),
    assert(enabled != null),
    assert(selected != null),
    super(key: key);

  final Widget leading;
  final Widget title;
  final ValueBuilder<List<Choice>> statusTextBuilder;
  final WidgetBuilder controlBuilder;
  final List<Choice> choices;
  final List<String> value;
  final bool enabled;
  final bool selected;

  Widget _buildDialog(BuildContext context) {
    return _ConfirmationDialog(
      title: title,
      contentPadding: const EdgeInsets.only(top: 16.0),
      content: SizedBox(
        height: choices.length * _kListTileHeight,
        child: controlBuilder(context),
      )
    );
  }

  Widget _buildStatusText(BuildContext context) {
    List<Choice> checkedChoices = choices.where(
      (choice) => value.contains(choice.value)
    ).toList();

    if (statusTextBuilder != null) {
      return statusTextBuilder(context, checkedChoices);
    } else {
      String subtitle = checkedChoices.map(
        (choice) => choice.title.data
      ).join(', ');
      return Text(subtitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
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

class _ConfirmationDialog extends StatelessWidget {
  _ConfirmationDialog({
    Key key,
    @required this.title,
    @required this.content,
    this.contentPadding = const EdgeInsets.only(top: 16.0),
  }) : 
    assert(title != null),
    assert(content != null),
    super(key: key);

  final Widget title;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      contentPadding: contentPadding,
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(SettingsLocalizations.done)
        )
      ]
    );
  }
}