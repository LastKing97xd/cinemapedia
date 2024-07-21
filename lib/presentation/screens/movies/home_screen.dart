import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    
    super.initState();
    //llamo al notifier(Clase que cree en el provider) para que se llene el metodo loadNextPage
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    //Aqui veo cada state del provider
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);

    return Column(
      children: [

        CustomAppbar(),

        MoviesSlideShow(movies: nowPlayingMovies)

        //expande todo lo posible del padre, ya tendria un alto y ancho estimado para que funcione el listview
        // Expanded(
        //   child: ListView.builder(
        //     padding: EdgeInsets.symmetric(),
        //     itemCount: nowPlayingMovies.length,
        //     itemBuilder: (context, index) {
        //       final movie = nowPlayingMovies[index];
        //       return ListTile(
        //         title: Text(movie.title),
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }
}