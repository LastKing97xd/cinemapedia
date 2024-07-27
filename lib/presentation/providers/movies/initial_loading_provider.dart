
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  //Si esta vacio, is empty convierte a bool
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(popularMoviesProvider).isEmpty;
  final step3 = ref.watch(topRatedMoviesProvider).isEmpty;
  final step4 = ref.watch(upComingMoviesProvider).isEmpty;

  //si cualquiera isEmpty regresa True
  if( step1 || step2 || step3 || step4 ) return true;

  return false;
  
});