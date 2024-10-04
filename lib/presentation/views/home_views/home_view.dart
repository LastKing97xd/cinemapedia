import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
    
    super.initState();
    //llamo al notifier(Clase que cree en el provider) para que se llene el metodo loadNextPage
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();

  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);

    if(initialLoading) return const FullScreenLoader();

    //Aqui veo cada state del provider o el valor del provider
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upComingMovies = ref.watch(upComingMoviesProvider);

    final moviesSlideShow = ref.watch(moviesSlideShowProvider);

    //para que sea invisible hasta que cargue
    // return Visibility(
    //   visible: !initialLoading,
    //   child: CustomScrollView());

    
    //El appbar sera interactivo al hacer scroll
    return CustomScrollView(
      slivers: [
        
        const SliverAppBar(
          floating: true,
          centerTitle: false,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
            //*quita el padding molesto
            titlePadding: EdgeInsets.zero,
          ),
        ),

        SliverList(delegate: 
          SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
            
                //const CustomAppbar(),
            
                MoviesSlideShow(movies: moviesSlideShow),
            
                MoviesHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En Cines',
                  subTitle: 'Sabado 20',
                  //* El read se utiliza dentro de funciones o CallBacks - IMPORTANTE
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
                ),
            
                MoviesHorizontalListview(
                  movies: upComingMovies,
                  title: 'Proximamente',
                  subTitle: 'En este mes',
                  //* El read se utiliza dentro de funciones o CallBacks - IMPORTANTE
                  loadNextPage: () => ref.read(upComingMoviesProvider.notifier).loadNextPage()
                ),
            
                MoviesHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  //subTitle: 'Sabado 20',
                  //* El read se utiliza dentro de funciones o CallBacks - IMPORTANTE
                  loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage()
                ),
            
                MoviesHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor Calificadas',
                  subTitle: 'De todos los tiempos',
                  //* El read se utiliza dentro de funciones o CallBacks - IMPORTANTE
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage()
                ),
              ]
            );
          },
          childCount: 1
        ))
      ],

    );


    //* Se desbordan los widget, me permite hacer el scroll
    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
      
    //       const CustomAppbar(),
      
    //       MoviesSlideShow(movies: moviesSlideShow),
      
    //       MoviesHorizontalListview(
    //         movies: nowPlayingMovies,
    //         title: 'En Cines',
    //         subTitle: 'Sabado 20',
    //         //* El read se utiliza dentro de funciones o CallBacks - IMPORTANTE
    //         loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
    //       ),
      
    //       MoviesHorizontalListview(
    //         movies: nowPlayingMovies,
    //         title: 'Proximamente',
    //         subTitle: 'En este mes',
    //         //* El read se utiliza dentro de funciones o CallBacks - IMPORTANTE
    //         loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
    //       ),
      
    //       MoviesHorizontalListview(
    //         movies: nowPlayingMovies,
    //         title: 'Populares',
    //         //subTitle: 'Sabado 20',
    //         //* El read se utiliza dentro de funciones o CallBacks - IMPORTANTE
    //         loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
    //       ),
      
    //       MoviesHorizontalListview(
    //         movies: nowPlayingMovies,
    //         title: 'Mejor Calificadas',
    //         subTitle: 'De todos los tiempos',
    //         //* El read se utiliza dentro de funciones o CallBacks - IMPORTANTE
    //         loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
    //       ),
      
    //       //expande todo lo posible del padre, ya tendria un alto y ancho estimado para que funcione el listview
    //       // Expanded(
    //       //   child: ListView.builder(
    //       //     padding: EdgeInsets.symmetric(),
    //       //     itemCount: nowPlayingMovies.length,
    //       //     itemBuilder: (context, index) {
    //       //       final movie = nowPlayingMovies[index];
    //       //       return ListTile(
    //       //         title: Text(movie.title),
    //       //       );
    //       //     },
    //       //   ),
    //       // )
    //     ],
    //   ),
    // );
  }
}