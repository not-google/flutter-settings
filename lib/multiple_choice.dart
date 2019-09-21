import 'package:flutter/material.dart';
import 'choice.dart';

class MultipleChoice<T> extends StatelessWidget {
  MultipleChoice({
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