

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>> ((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  //es la clase de abajo
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//* Nuevo provider para llamar populares

final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>> ((ref) {
  //getpopular sin () pasa la referencia  a la funcion
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;

  //es la clase de abajo
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//* Nuevo provider para llamar TopRated

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>> ((ref) {
  //getpopular sin () pasa la referencia  a la funcion
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;

  //es la clase de abajo
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//* Nuevo provider para llamar Upcoming

final upComingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>> ((ref) {
  //getpopular sin () pasa la referencia  a la funcion
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;

  //es la clase de abajo
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});



//lo uso mas que todo para especificar el tipo de funcion que espero, como una maqueta talvez
//es mas que todo para definir el caso de uso
typedef MovieCallBack = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {

  int currentPage = 0;
  bool isLoading = false;
  MovieCallBack fetchMoreMovies;
  //[] el punto es que esto proporcione un List<Movie>
  MoviesNotifier({
    required this.fetchMoreMovies
  }) : super ([]);

  Future<void> loadNextPage() async{
    if( isLoading ) return;

    isLoading = true;
    //print('Peticion peliculas');
    currentPage ++;
    //fetchMoreMovies iniciando va a recibir la 1 y eso hace referencia arriba para que consulte la primera pagina
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    //aqui esta el actual y se agrega lo de la siguiente pagina
    state = [...state,...movies];
    //esperar para que sea renderizado la nueva lista
    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }

}