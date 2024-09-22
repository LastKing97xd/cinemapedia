import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10 
        ),
        child: SizedBox(
          //darle todo el ancho que se pueda
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              const SizedBox(width: 5,),
              Text('Cinemapedia',style: titleStyle,),

              const Spacer(),

              IconButton(
                onPressed: () {
                  //onPressed se asegura que el estado más reciente de los proveedores (movieRepository y searchQuery) 
                  //se obtenga justo antes de ejecutar la búsqueda, en lugar de cuando se construye el widget.
                  //final movieRepository = ref.read(movieRepositoryProvider); -> 238
                  final searchQuery = ref.read(searchQueryProvider);

                  final searchedMovies = ref.read(searchedMoviesProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    //*Contexto de toda la aplicacion
                    context: context, 
                    //*Encargado de trabajar la busqueda
                    delegate: SearchMovieDelegate(
                      //searchMovies: movieRepository.searchMovies
                      
                      searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesQuery,
                      initialMovies: searchedMovies

                      //searchMovies: (query) {
                        //guarda la query en es state
                        //ref.read(searchQueryProvider.notifier).update((state) => query); -> 238
                        //*Es como si la función anónima actuara como un intermediario: hace algo extra (actualizar el estado) y 
                        //*luego retorna el resultado de la búsqueda para que el delegado lo use.
                        //return movieRepository.searchMovies(query);
                      //}


                    )
                    //* .then permite ejecutar lógica después de que el Future de showSearch se complete.
                  ).then((value) {
                    if(value == null) return;
                    context.push('/movie/${value.id}');
                  });
                }, 
                icon: const Icon(Icons.search) 
              )
            ],
          ),
        ),
      ),
    );
  }
}