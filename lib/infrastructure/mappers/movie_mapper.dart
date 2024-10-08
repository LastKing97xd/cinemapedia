import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: moviedb.backdropPath != '' ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath}' : 
    'https://i.pinimg.com/originals/cf/4c/f0/cf4cf01d1b3f7c2da8f5bf94c89bf2f4.jpg',
    //'https://previews.123rf.com/images/yoginta/yoginta2301/yoginta230100567/196853824-imagen-no-encontrada-ilustraci%C3%B3n-vectorial.jpg',
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: moviedb.posterPath != '' ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath}' : 
    'https://i.pinimg.com/originals/cf/4c/f0/cf4cf01d1b3f7c2da8f5bf94c89bf2f4.jpg',
    //'https://previews.123rf.com/images/yoginta/yoginta2301/yoginta230100567/196853824-imagen-no-encontrada-ilustraci%C3%B3n-vectorial.jpg',
    releaseDate: moviedb.releaseDate,
    title: moviedb.title,
    video: moviedb.video, 
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount);


  static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: moviedb.backdropPath != '' ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath}' : 
    'https://i.pinimg.com/originals/cf/4c/f0/cf4cf01d1b3f7c2da8f5bf94c89bf2f4.jpg',
    //'https://previews.123rf.com/images/yoginta/yoginta2301/yoginta230100567/196853824-imagen-no-encontrada-ilustraci%C3%B3n-vectorial.jpg',
    genreIds: moviedb.genres.map((e) => e.name).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: moviedb.posterPath != '' ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath}' : 
    'https://i.pinimg.com/originals/cf/4c/f0/cf4cf01d1b3f7c2da8f5bf94c89bf2f4.jpg',
    //'https://previews.123rf.com/images/yoginta/yoginta2301/yoginta230100567/196853824-imagen-no-encontrada-ilustraci%C3%B3n-vectorial.jpg',
    releaseDate: moviedb.releaseDate,
    title: moviedb.title,
    video: moviedb.video, 
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount);
}


