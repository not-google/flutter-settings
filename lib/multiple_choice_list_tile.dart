import 'package:flutter/material.dart';
import 'settings_localizations.dart';
import 'types.dart';
import 'choice.dart';

const double _kListTileHeight = 56.0;

class MultipleChoiceListTile<T> extends StatelessWidget {
  MultipleChoiceListTile({
    Key key,
    this.leading,
    @required this.label,
    this.statusTextBuilder,
    @required this.controlBuilder,
    @required this.choices,
    @required this.value,
    this.enabled = true,
    this.selected = false,
  }) : super(key: key);

  final Widget leading;
  final Text label;
  final ValueBuilder<List<Choice<T>>> statusTextBuilder;
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

  Widget _buildSecondaryText(BuildContext context) {
    List<Choice<T>> checkedChoices = choices.where(
      (choice) => value.contains(choice.value)
    ).toList();

    if (statusTextBuilder != null) {
      return statusTextBuilder(context, checkedChoices);
    } else {
      String secondaryText = checkedChoices.map(
              (choice) => choice.label.data
      ).join(', ');
      return Text(secondaryText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: label,
      subtitle: _buildSecondaryText(context),
      onTap: () => showDialog(
        context: context,
        builder: _buildDialog
      ),
      selected: selected,
      enabled: enabled,
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  ConfirmationDialog({
    this.title,
    this.content,
    this.contentPadding = const EdgeInsets.only(top: 16.0),
    this.onConfirm
  });

  final Widget title;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
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
          child: Text(SettingsLocalizations.done)
        )
      ]
    );
  }
}