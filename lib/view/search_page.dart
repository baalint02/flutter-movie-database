import 'package:film_database/view/film_details.dart';
import 'package:film_database/view/film_list.dart';
import 'package:film_database/film_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();

  String _searchQuery = "";

  final FilmRepository repository = FilmRepository();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showResults = _searchQuery.length > 2;
    return Stack(
      children: [
        if (showResults) _buildResults(context),

        SafeArea(
          child: AnimatedAlign(
            alignment: _focusNode.hasFocus || showResults
                ? .topCenter
                : .center,
            duration: Durations.medium1,
            curve: Easing.standard,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSearchBar(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      focusNode: _focusNode,
      hintText: "Search for films",
      leading: Icon(Icons.search),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
      onChanged: (value) => setState(() => _searchQuery = value),
      onSubmitted: (value) => setState(() {
        _searchQuery = value;
        _focusNode.unfocus();
      }),
      onTapOutside: (event) => _focusNode.unfocus(),
    );
  }

  Widget _buildResults(BuildContext context) {
    return FutureBuilder(
      future: repository.searchFilms(query: _searchQuery),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final filmList = snapshot.data!;
          if (filmList.isEmpty) {
            return Center(child: Text('No results for "$_searchQuery"'));
          }
          return FilmListWidget(
            films: filmList,
            onTapCallback: (film) {
              openFilmDetailsPage(film.id, context);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error"));
        } else {
          return Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void openFilmDetailsPage(int filmId, BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => FilmDetailsPage(filmId: filmId),
      ),
    );
  }
}
