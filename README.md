# FilmDatabase

Homework for Flutter course [VIAUAV45](https://github.com/bmeaut/VIAUAV45) at Budapest University of Economy and Technology (BME).

## Used technologies

- REST HTTP fetching from [The Movie Database API](https://developer.themoviedb.org/docs/getting-started) with the [`dio`](https://pub.dev/packages/dio) package
- JSON deserialization using the package [`json_serializable`](https://pub.dev/packages/json_serializable)
- Persistence in SQLite database with the package [`sqflite`](https://pub.dev/packages/sqflite)
- Dependency Injection with [`provider`](https://pub.dev/packages/provider)

## Screenshots

<table>
	<tr>
		<td><img src="https://github.com/baalint02/flutter-movie-database/raw/main/screenshots/list_screen.png" width="400" /></td>
		<td><img src="https://github.com/baalint02/flutter-movie-database/raw/main/screenshots/details_screen.png" width="400" /></td>
        <td><img src="https://github.com/baalint02/flutter-movie-database/raw/main/screenshots/watchlist.png" width="400" /></td>
	</tr>
</table>

## Build

You need to inject the TMDB API key when building the app:

```bash
$ flutter run --dart-define=TMDB_API_KEY=YOUR_API_KEY
```

The API key can be obtained from TMDB:

https://developer.themoviedb.org/docs/getting-started
