import 'package:film_database/data_model.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FilmListWidget extends StatelessWidget {
  final List<Film> films;
  final Function(Film film) onTapCallback;
  final EdgeInsetsGeometry? padding;

  const FilmListWidget({
    super.key,
    required this.films,
    required this.onTapCallback,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (films.isNotEmpty) {
      return ListView.separated(
        itemCount: films.length,
        itemBuilder: (context, index) =>
            _FilmItemWidget(films[index], onTapCallback),
        separatorBuilder: (context, index) => Divider(height: 0),
        padding: padding,
      );
    } else {
      return const SizedBox();
    }
  }
}

class FilmListDismissibleWidget extends StatelessWidget {
  final List<Film> films;
  final Function(Film film) onTapCallback;
  final Function(int index) onDismissedCallback;
  final EdgeInsetsGeometry? padding;

  const FilmListDismissibleWidget({
    super.key,
    required this.films,
    required this.onTapCallback,
    required this.onDismissedCallback,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (films.isNotEmpty) {
      return ListView.separated(
        itemCount: films.length,
        itemBuilder: (context, index) => Dismissible(
          key: Key(films[index].id.toString()),
          background: const _DismissibleBackground(alignment: .centerLeft),
          secondaryBackground: const _DismissibleBackground(
            alignment: .centerRight,
          ),
          onDismissed: (_) => onDismissedCallback(index),
          child: _FilmItemWidget(films[index], onTapCallback),
        ),
        separatorBuilder: (context, index) => Divider(height: 0),
        padding: padding,
      );
    } else {
      return const SizedBox();
    }
  }
}

class _DismissibleBackground extends StatelessWidget {
  final AlignmentGeometry alignment;

  const _DismissibleBackground({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.red),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Align(
          alignment: alignment,
          child: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}

class _FilmItemWidget extends StatelessWidget {
  final Film film;
  final Function(Film) onTapCallback;

  const _FilmItemWidget(this.film, this.onTapCallback);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapCallback(film),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        height: 92,
        child: Row(
          crossAxisAlignment: .center,
          children: [
            _buildPoster(),
            SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    film.title,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(height: 1.2),
                  ),
                  Text(
                    "${film.year ?? ""}",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    final posterUrl = film.posterUrl;

    if (posterUrl != null) {
      return FadeInImage(
        height: 80,
        width: 70,
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(posterUrl),
      );
    } else {
      return Image(height: 80, image: MemoryImage(kTransparentImage));
    }
  }
}
