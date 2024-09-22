

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate <Movie?>{

  final SearchMovieCallback searchMovies;
  List<Movie> initialMovies;
  //broascast es para escuchar multiples listeners
  //StreamController es lo que te permite manejar y controlar el flujo de datos dentro de un Stream es como el "centro de control" del flujo de datos
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();

  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies
    });

  //cada ves que cierro el streams creado sigue existiendo
  //cierro el stream creado
  void clearStreams(){
    debouncedMovies.close();
  }

  void _onQueryChanged(String query) {
    //print('QueryStream cambio');

    //emitir el valor cuando la persona deja de escribir por un tiempo
    //la primera evalucion sera null osea false, y se creara el tiempo
    // en la segunda isActive sera true, y cancelara el tiempo, para asignar de nuevo 500
    if( _debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      
      isLoadingStream.add(true);
      //*se ejecuta cuando pasa el tiempo
      //busca las peliculas y emite al stream
      //si el query es vacio devuelve lista vacia
      //Al detectar el query vacio no llegaba al searchMovies que es el que actualiza el ultimo estado del query
      /*if( query.isEmpty ){
        debouncedMovies.add([]);
        return;
      }*/
      //si el query tiene informacion, busca y lo inserta en el stream para su construccion.
      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      //print('Buscando pelas');
      isLoadingStream.add(false);
    },);
  }
  
  Widget buildResultsAndSuggestions(){
    
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {

        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {         
            final movie = movies[index];
            return _MovieItem(
              movie: movie, 
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );

  }


  @override
  String? get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {

    //print('Query: $query');
    return [
      
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream, 
        builder: (context, snapshot) {

          if(snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 1),
              spins: 20,
              infinite: true,
              child: IconButton(
                //query es el valor de la busqueda
                onPressed: () => query = '', 
                icon: const Icon(Icons.refresh_rounded)
              ),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '', 
              icon: const Icon(Icons.clear)
            ),
          );
        },
      )

      


      //if(query.isNotEmpty)
      // FadeIn(
      //   //es como la validacion
      //   animate: query.isNotEmpty,
      //   child: IconButton(
      //     //query es el valor de la busqueda
      //     onPressed: () => query = '', 
      //     icon: const Icon(Icons.clear)
      //   ),
      // )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },      
      icon: const Icon(Icons.arrow_back_ios_new_rounded)
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //return FutureBuilder(
    _onQueryChanged(query);


    //*return buildResultsAndSuggestions(); 


    //Escucha los valores emitidos por el stream
    return StreamBuilder(
      initialData: initialMovies,
      //cada vez que se toque una tecla dispararia el future
      //future: searchMovies(query), 
      //*stream es la parte que los oyentes (como StreamBuilder) usan para suscribirse y recibir los datos que se están emitiendo
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {

        //print('Peticion');
        final movies = snapshot.data ?? [];
        //* luego de 500ms sin cambios, el StreamBuilder reconstruye la lista de sugerencias ListView.builder
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            
            final movie = movies[index];
            return _MovieItem(
              movie: movie, 
              //* close funcion global en el Search Delegate, cierra el search
              //* aqui se define la funcion que se pasa al widget hijo, el ontap de abajo solo ejecuta la funcion aqui definida

              onMovieSelected: (context, movie) {
                clearStreams();
                //* cierra los streams, llama al close para cerrar el search delegate y devuele el movie al showSearch del padre.
                close(context, movie);
              },
            );

          },
        );
      },
    );
  }

}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(

      onTap: () {
        //* aqui llama a la funcion onMovieSelected nada mas
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
      
            //Image
            SizedBox(
              width: size.width * 0.2,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  fit: BoxFit.cover,
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) {
                    return FadeIn(child: child);
                  },
                ),
              ),
            ),
      
            const SizedBox( width: 10,),
      
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium,),
      
                  movie.overview.length >180 ? Text('${movie.overview.substring(0,180)}...') : Text(movie.overview),
      
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                      const SizedBox(width: 5,),
                      Text(
                        HumanFormats.number(movie.voteAverage, 2),
                        style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade800),
                      )
                    ],
                  )
      
                ],
              ),
            )
      
          ],
        ),
      ),
    );
  }
}

//*onMovieSelected es un callback porque es una función pasada a otro componente (en este caso, al widget _MovieItem) que se llama en respuesta a un evento (como un toque en el widget).
//*El callback permite que el componente que lo recibe (_MovieItem) ejecute una función específica (onMovieSelected) en el momento adecuado (cuando el usuario toca el widget).