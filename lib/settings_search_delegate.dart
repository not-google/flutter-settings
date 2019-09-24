import 'package:flutter/material.dart';
import 'settings_menu_item.dart';
import 'settings_menu.dart';
import 'settings_page.dart';

class SettingsSearchSuggestion {
  SettingsSearchSuggestion({
    @required this.item,
    this.page,
    this.pathSegments,
  }) :
    assert(item != null);

  final SettingsMenuItem item;
  final SettingsMenuItem page;
  final List<String> pathSegments;
}

class SettingsSearchDelegate extends SearchDelegate<SettingsMenuItem> {
  SettingsSearchDelegate({
    @required this.groupBuilder,
    @required this.title,
    this.pageBuilder = SettingsPageRoute.pageBuilder,
    @required this.onShowSearch
  }) :
    assert(groupBuilder != null);

  final SettingsGroupBuilder groupBuilder;
  final SettingsPageRouteBuilder pageBuilder;
  final Widget title;
  final VoidCallback onShowSearch;
  final Iterable<SettingsSearchSuggestion> _history = [];

  List<SettingsSearchSuggestion> _getSuggestions(BuildContext context, {
    SettingsMenuItem page,
    SettingsMenuItem parent,
    List<SettingsSearchSuggestion> suggestions,
    List<String> pathSegments
  }) {
    List<SettingsMenuItem> data = parent != null
        ? parent.groupBuilder(context)
        : this.groupBuilder(context);
    pathSegments = pathSegments ?? [];
    suggestions = suggestions ?? [];

    data.forEach((item) {
      List<String> itemPathSegments;
      bool isPage = item.pageContentBuilder != null;
      bool hasMatch = _HighlightedText.hasMatch(item.title?.data, query);
      if (hasMatch) {
        suggestions.add(
            SettingsSearchSuggestion(
                page: page,
                item: item,
                pathSegments: pathSegments
            )
        );
      }

      if (item.groupBuilder != null) {
        if (isPage) {
          itemPathSegments = []
            ..addAll(pathSegments)
            ..add(item.title.data);
        }

        _getSuggestions(
            context,
            parent: item,
            page: isPage ? item : page,
            suggestions: suggestions,
            pathSegments: itemPathSegments
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

  Widget _buildPage(BuildContext context, SettingsSearchSuggestion suggestion) {
    bool hasPage = suggestion.page != null;

    if (hasPage) {
      return suggestion.page
        .copyWith(
          selectedKey: suggestion.item.key,
          onShowSearch: onShowSearch
        )
        .makeStateful()
        .buildPage(context);
    } else {
      return pageBuilder(
        context,
        title,
        SettingsMenu(
          groupBuilder: groupBuilder,
          itemBuilder: (item) => item.copyWith(
            selectedKey: suggestion.item.key,
            onShowSearch: onShowSearch
          )
        ),
        onShowSearch
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<SettingsSearchSuggestion> suggestions = query.isEmpty
        ? _history
        : _getSuggestions(context);

    return _SettingsSearchSuggestionList(
      query: query,
      suggestions: suggestions,
      onSelected: (SettingsSearchSuggestion suggestion) {
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

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  Widget _buildClearHistoryAction(BuildContext context) {
    if (_history.isEmpty) return Container();

    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: ListTile(
            title: Text('Clear history'),
          ),
        )
      ],
    );
  }

  Widget _buildClearAction(BuildContext context) {
    if (query.isEmpty) return Container();

    return IconButton(
      tooltip: 'Clear',
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
        showSuggestions(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      _buildClearAction(context),
      _buildClearHistoryAction(context)
    ];
  }
}

class _SettingsSearchSuggestionList extends StatelessWidget {
  const _SettingsSearchSuggestionList({
    this.suggestions,
    this.query,
    this.onSelected
  });

  final Iterable<SettingsSearchSuggestion> suggestions;
  final String query;
  final ValueChanged<SettingsSearchSuggestion> onSelected;

  Widget _buildItem(BuildContext context, int index) {
    final SettingsSearchSuggestion suggestion = suggestions.elementAt(index);
    final String title = suggestion.item.title.data;
    return ListTile(
      leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
      title: _HighlightedText(
        text: title,
        highlight: query,
      ),
      subtitle: Text(suggestion.pathSegments.join(' > ')),
      onTap: () => onSelected(suggestion),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: _buildItem,
    );
  }
}

class _HighlightedText extends StatelessWidget {
  _HighlightedText({
    Key key,
    this.text,
    this.highlight,
    this.style,
    this.highlightStyle
  }) :
    assert(text != null),
    assert(highlight != null),
    super(key: key);

  final String text;
  final TextStyle style;
  final String highlight;
  final TextStyle highlightStyle;

  TextSpan _buildMatch(BuildContext context, String text) {
    return TextSpan(
      text: text,
      style: highlightStyle ?? TextStyle(
        fontWeight: FontWeight.bold
      )
    );
  }

  TextSpan _buildNonMatch(BuildContext context, String text) {
    return TextSpan(text: text);
  }

  TextStyle _getStyle(context) {
    return style ?? Theme.of(context).textTheme.subhead;
  }

  static bool get _caseSensitive => false;
  static bool get _multiLine => true;

  RegExp get _regExp => RegExp(
      highlight,
      caseSensitive: _caseSensitive,
      multiLine: _multiLine
  );

  static bool hasMatch(String text, String query) {
    if (text == null || query == null) return false;

    return RegExp(
        query,
        caseSensitive: _caseSensitive,
        multiLine: _multiLine
    ).hasMatch(text);
  }

  TextSpan _buildHighlighted(BuildContext context) {
    if (highlight == null) return TextSpan(
      text: text,
      style: _getStyle(context)
    );

    RegExp splitter = _regExp;
    List<TextSpan> children = [];

    text.splitMapJoin(
        splitter,
        onMatch: (match) {
          String matchText = match.group(0);
          children.add(
              _buildMatch(context, matchText)
          );
          return matchText;
        },
        onNonMatch: (nonMatchText) {
          children.add(
              _buildNonMatch(context, nonMatchText)
          );
          return nonMatchText;
        }
    );

    return TextSpan(
      children: children,
      style: _getStyle(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildHighlighted(context),
    );
  }
}