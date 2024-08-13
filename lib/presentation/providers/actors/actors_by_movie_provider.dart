
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String,List<Actor>>>((ref) {
  final fetchActors = ref.watch(actorsRepositoryProvider).getActorsByMovie;

  return ActorsByMovieNotifier(getActors: fetchActors);
});

/*
 {
    '123144': <Actor>[],
    '123145': <Actor>[],
    '123146': <Actor>[],
    '123148': <Actor>[],
 }
*/

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actor>>>{
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors
  }): super({});

  Future<void> loadActors(String movieId) async{
    if(state[movieId] != null) return;
    //print('Realizando Peticion HTTP');
    final List<Actor> actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}