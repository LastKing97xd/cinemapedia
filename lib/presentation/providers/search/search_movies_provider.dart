

import 'package:flutter_riverpod/flutter_riverpod.dart';

//Booleano 
//StateProvider para mantener una pieza de estado como un solo valor entre varios
final searchQueryProvider = StateProvider<String>((ref) => '',);