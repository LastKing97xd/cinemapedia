import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream <String> getLoadingMessages(){
    final messages = <String>[
      'Cargando peliculas',
      'Friendo canchita',
      'Cargando populares',
      'Llamando a mi novia',
      'Ahoritita...',
      'Esto esta tardando mas de lo esperado :c'
    ];

    return Stream.periodic(const Duration(milliseconds: 1200), (indice){
      return messages[indice];
      //lo terminara en la cantidad de registros de la lista
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          const SizedBox(height: 10,),
          const CircularProgressIndicator(strokeWidth: 2,),
          const SizedBox(height: 10,),

          //construye basado en un Stream ademas cuando se destruye limpia el stream ya no llamaria a closed
          StreamBuilder(
            stream: getLoadingMessages(), 
            builder: (context, snapshot) {
              
              if(!snapshot.hasData) return const Text('Cargando...');

              return Text(snapshot.data!);
            },
          )
        ],
    ));
  }
}