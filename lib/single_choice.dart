import 'package:flutter/material.dart';
import 'choice.dart';

class SingleChoice extends StatelessWidget {
  SingleChoice({
    Key key,
    @required this.choices,
    @required this.value,
    this.enabled = true,
    this.loading = false,
    @required this.onChanged
  }) :
    assert(value != null),
    assert(enabled != null),
    assert(loading != null),
    assert(choices != null),
    super(key: key);

  final List<Choice> choices;
  final String value;
  final bool loading;
  final bool enabled;
  final ValueChanged<String> onChanged;

  Widget _buildRadioListTile(BuildContext context, int index) {
    Choice option = choices[index];
    return RadioListTile<String>(
      secondary: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: option.title,
      subtitle: option.subtitle,
      value: option.value,
      groupValue: value,
      onChanged: enabled ? onChanged : null,
      controlAffinity: ListTileControlAffinity.trailing
    );
  }

  Widget _buildLoading(BuildContext context) {
    if (loading) return LinearProgressIndicator();
    return Container();
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: choices.length,
      itemBuilder: _buildRadioListTile
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