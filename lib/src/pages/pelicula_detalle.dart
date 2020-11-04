import 'package:flutter/material.dart';

import 'package:movies_app/src/models/actores_model.dart';
import 'package:movies_app/src/models/pelicula_model.dart';
import 'package:movies_app/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
       slivers: [
         _crearAppBar(pelicula),
         SliverList(
           delegate: SliverChildListDelegate(
             [
               SizedBox(height: 10.0,),
               _posterTitulo(context, pelicula),
               _descripcion(pelicula),
               _descripcion(pelicula),
               _crearCasting(pelicula.id.toString())
             ]
           ),
         )
       ],
      )
    );
  }

  Widget _crearAppBar(Pelicula pelicula){
    print( pelicula.getBackgroundImg());
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
            pelicula.title,
            style: TextStyle(color: Colors.white, fontSize: 16.0)
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pelicula.title, style: Theme.of(context).textTheme.headline3, overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    Text( pelicula.voteAverage.toString(),  style: Theme.of(context).textTheme.subtitle1)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(String idMovie){
    final movieProvider = new PeliculasProvider();
    return FutureBuilder(
      future: movieProvider.getCast(idMovie),
      builder: (BuildContext ctx, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores){
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorCard(actores[i]),
      ),
    );
  }

  Widget _actorCard(Actor actor){
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
