import 'package:flutter/material.dart';
import 'choice.dart';

class MultipleChoice extends StatelessWidget {
  MultipleChoice({
    Key key,
    @required this.choices,
    @required this.value,
    @required this.onChanged,
    this.enabled = true,
    this.loading = false
  }) :
    assert(value != null),
    assert(choices != null),
    assert(enabled != null),
    assert(enabled != null),
    super(key: key);

  final List<Choice> choices;
  final List<String> value;
  final bool loading;
  final bool enabled;
  final ValueChanged<List<String>> onChanged;

  void _checkedChange(Choice option, bool checked) {
    List<String> _value = []..addAll(value);
    checked ? _value.add(option.value) : _value.remove(option.value);
    if (onChanged != null) onChanged(_value);
  }

  Widget _buildCheckboxListTile(BuildContext context, int index) {
    Choice option = choices[index];
    bool checked = value.contains(option.value);
    return CheckboxListTile(
        title: option.title,
        subtitle: option.subtitle,
        value: checked,
        onChanged: enabled
            ? (bool checked) => _checkedChange(option, checked)
            : null
    );
  }

  Widget _buildLoading(BuildContext context) {
    if (loading) return LinearProgressIndicator();
    return Container();
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
        itemCount: choices.length,
        itemBuilder: _buildCheckboxListTile
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: loading,
        child: Stack(
          children: <Widget>[
            _buildLoading(context),
            _buildListView(context)
          ],
        )
    );
  }
}