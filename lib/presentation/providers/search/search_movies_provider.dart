

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

//Booleano 
//StateProvider para mantener una pieza de estado como un solo valor entre varios
final searchQueryProvider = StateProvider<String>((ref) => '',);

final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);
  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies, 
    ref: ref
  );
});

typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>>{

  final SearchMoviesCallBack searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }): super([]);

  //Aqui se recibe le query que se mandaba explicitamente en el customAppbar
  Future<List<Movie>> searchMoviesQuery(String query) async{ 
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query,);

    state = movies;
    return movies;
  }
}