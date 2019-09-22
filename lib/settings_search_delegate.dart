import 'package:flutter/material.dart';
import 'settings_menu_item.dart';
import 'settings_menu.dart';
import 'settings_page.dart';

class SettingsSearchSuggestion {
  SettingsSearchSuggestion({
    @required this.item,
    this.parentWithPage,
    this.parentsTitles,
  }) :
    assert(item != null);

  final SettingsMenuItem item;
  final SettingsMenuItem parentWithPage;
  final List<String> parentsTitles;
}

class SettingsSearchDelegate extends SearchDelegate<SettingsMenuItem> {
  SettingsSearchDelegate({
    @required this.groupBuilder,
    this.onSearch
  }) :
    assert(groupBuilder != null);

  final SettingsGroupBuilder groupBuilder;
  final VoidCallback onSearch;
  final Iterable<SettingsSearchSuggestion> _history = [];

  List<SettingsSearchSuggestion> _getSuggestions(BuildContext context, {
    SettingsMenuItem parentWithPage,
    SettingsMenuItem parent,
    List<SettingsSearchSuggestion> suggestions,
    List<String> parentsTitles
  }) {
    List<SettingsMenuItem> data = parent != null
        ? parent.groupBuilder(context)
        : this.groupBuilder(context);
    parentsTitles = parentsTitles ?? [];
    suggestions = suggestions ?? [];

    data.forEach((item) {
      List<String> itemParentsTitles;
      bool isPage = item.pageContentBuilder != null;

      if ((item.label?.data ?? '').startsWith(query)) {
        suggestions.add(
            SettingsSearchSuggestion(
                parentWithPage: parentWithPage,
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
            parentWithPage: isPage ? item : parentWithPage,
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

  Widget _buildPage(BuildContext context, SettingsSearchSuggestion suggestion) {
    SettingsMenuItem parent = suggestion.parentWithPage;
    bool hasParentPage = parent?.pageContentBuilder != null;
    SettingsPageBuilder pageBuilder = hasParentPage
        ? suggestion.parentWithPage.pageBuilder
        : SettingsPage.pageBuilder;

    return pageBuilder(
      context,
      hasParentPage ? parent.label : null,
      SettingsMenu(
        groupBuilder: hasParentPage
          ? parent.groupBuilder
          : groupBuilder,
        itemBuilder: (item) => item.copyWith(
          selectedId: suggestion.item.id,
          onSearch: onSearch
        )
      ),
      onSearch
    );
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
  Widget buildResults(BuildContext context) => null;

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
    final String label = suggestion.item.label.data;
    final ThemeData theme = Theme.of(context);
    return ListTile(
      leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
      title: RichText(
        text: TextSpan(
          text: label.substring(0, query.length),
          style: theme.textTheme.subhead.copyWith(
              fontWeight: FontWeight.bold
          ),
          children: <TextSpan>[
            TextSpan(
              text: label.substring(query.length),
              style: theme.textTheme.subhead,
            ),
          ],
        ),
      ),
      subtitle: Text(suggestion.parentsTitles.join(' > ')),
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