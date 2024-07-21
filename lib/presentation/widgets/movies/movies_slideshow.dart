
import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesSlideShow extends StatelessWidget {

  final List<Movie> movies;

  const MoviesSlideShow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 210,
      //Toma todo el ancho posible
      width: double.infinity,
      child: Swiper(
        //Recorte el tamano del Slider
        viewportFraction: 0.8,
        scale: 0.85,
        //va uno por uno
        autoplay: true,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary
          ),
          margin: EdgeInsets.only(top: 0)
        ),

        itemCount: movies.length ,
        itemBuilder: (context, index) {
          final movieV= movies[index];
          return _Slide(movie: movieV);
        },
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black54,
          //espacio de difuminado
          blurRadius: 10,
          //hacia donde va la sombra
          offset: Offset(0, 10)
        )
      ]
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        //Permita colocar bordes redondeados
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,
            //mejora la posicion de la imagen la acomoda bien
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              //si el progreso de carga tiene valor lo mostrara gris
              if(loadingProgress != null){
                return const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12)
                );
              }
              return FadeIn(child: child);
            },
          ))
        ),
      );
  }
}