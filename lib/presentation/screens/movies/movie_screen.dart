import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);

  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    //*Al no tener Scaffold la pantalla queda en negro
    if(movie == null){
      return const Scaffold(body: Center( child: CircularProgressIndicator(strokeWidth: 2)));
    }

    //* Para llamar Ref en StatelessWidget es en el Build
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1
          ))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {

  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Para hacer bordes redondeados
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(width: 10,),

              SizedBox(
                width: (size.width - 50) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleLarge),
                    const SizedBox(height: 5,),
                    Text(movie.overview)
                  ],
                ),
              )

            ],
          ),
        ),

        //* Generos

        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            children: [
              //* Recurso es Details y map es para convertir cada objeto de la lista a widget en este caso
              ...movie.genreIds.map((valor) => Container(
                margin: const EdgeInsets.only(left: 10),
                child: Chip(
                  label: Text(valor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),)
            ],
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString())

      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {

  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    final actorsByMovie = ref.watch(actorsByMovieProvider);
    //final size = MediaQuery.of(context).size;

    if(actorsByMovie[movieId] == null){
      return const CircularProgressIndicator(strokeWidth: 2,);
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 290,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actors2 = actors[index];

          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actors2.profilePath,
                    width: 135,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 10,),
                Text(actors2.name, maxLines: 2,),
                Text(
                  actors2.character ?? '',
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)
                )

              ],
            ),
          );
        },
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            await ref.watch(localStorageRepositoryProvider).toggleFavorite(movie);
            ref.invalidate(isFavoriteProvider(movie.id));
          }, 
          // icon: const Icon(Icons.favorite_border)
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite 
              ? const Icon(Icons.favorite_rounded, color: Colors.red)
              : const Icon(Icons.favorite_border),
            error: (error, stackTrace) => throw UnimplementedError(),
            loading: () => const CircularProgressIndicator(strokeWidth: 2,)
          )
          
          //const Icon(Icons.favorite_rounded, color: Colors.red,)
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        /*title: Text(
          movie.title,
          style: const TextStyle(fontSize: 25,color: Colors.white),
          textAlign: TextAlign.start,
        ),*/
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null) return const SizedBox();

                  return FadeInRight(child: child);
                  //return FadeIn(child: child);
                },
              ),
            ),
            
            const _CustomGradient(
              begin: Alignment.topRight, 
              end: Alignment.bottomLeft, 
              stops: [0.0, 0.2], 
              colors: [Colors.black87, Colors.transparent],
            ),

            const _CustomGradient(
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
              stops: [0.8, 1.0], 
              colors: [Colors.transparent, Colors.black54],
            ),

            const _CustomGradient(  
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight, 
              stops: [0.0, 0.2], 
              colors: [Colors.black87, Colors.transparent],
            ),

          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  const _CustomGradient({required this.begin, required this.end, required this.stops, required this.colors});

  final AlignmentGeometry begin, end;
  final List<double> stops;
  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors
          )
        )
      ),
    );
  }
}
