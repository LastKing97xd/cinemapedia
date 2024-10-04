import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    
    //*Mantener el State-Preserving de parte de GoRoute
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeScreen(childView: navigationShell),
      branches: [
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (context, state) {
              return const HomeView();
            },
            routes: [
              GoRoute(
                  path: 'movie/:id',
                  name: MovieScreen.name,
                  builder: (context, state) {
                    final movieId = state.pathParameters['id'] ?? 'no-id';
                    return MovieScreen(movieId: movieId);
                  },
                ),
            ]
          )
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/favorites',
            builder: (context, state) {
              return const FavoritesView();
            },
          )
        ]),
      ]),


    // ShellRoute(
    //   builder: (context, state, child) {
    //     return HomeScreen(childView: child);
    //   },
    //   routes: [

    //     GoRoute(
    //       path: '/',
    //       builder: (context, state) {
    //         return const HomeView();
    //       },
    //       routes: [
    //         GoRoute(
    //           path: 'movie/:id',
    //           name: MovieScreen.name,
    //           builder: (context, state) {
    //             final movieId = state.pathParameters['id'] ?? 'no-id';

    //             return MovieScreen(movieId: movieId);
    //           },
    //         )
    //       ]
    //     ),

    //     GoRoute(
    //       path: '/favorites',
    //       builder: (context, state) {
    //         return const FavoritesView();
    //       },
    //     ),

    //   ]
    // )


    //*Rutas padre/hijo
    // GoRoute(
    //   path: '/',
    //   name: HomeScreen.name,
    //   builder: (context, state) => const HomeScreen( childView: FavoritesView(),),
    //   routes: [
    //     GoRoute(
    //     //Digo que voy a mandar este argumento id
    //     //* / da el padre
    //     path: 'movie/:id',
    //     name: MovieScreen.name,
    //     builder: (context, state) {
    //       final movieId = state.pathParameters['id'] ?? 'no-id';

    //       return MovieScreen(movieId: movieId);
    //     },
    //   )
    //   ]
    // ),

    // GoRoute(
    //   //Digo que voy a mandar este argumento id
    //   path: '/movie/:id',
    //   name: MovieScreen.name,
    //   builder: (context, state) {
    //     final movieId = state.pathParameters['id'] ?? 'no-id';

    //     return MovieScreen(movieId: movieId);
    //   },
    // )

  ]
);
