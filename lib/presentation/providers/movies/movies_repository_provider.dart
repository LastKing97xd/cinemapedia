
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Este provider es solo de lectura o inmutable
final movieRepositoryProvider = Provider((ref) => MovieRepositoryImpl( MovieDBDatasource() ));