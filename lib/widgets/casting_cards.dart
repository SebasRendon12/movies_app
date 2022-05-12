import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({Key? key, required this.movieId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Casting',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        FutureBuilder(
          future: moviesProvider.getMovieCast(movieId),
          builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                width: double.infinity,
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final cast = snapshot.data!;
            return Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cast.length,
                itemBuilder: (_, int index) => _CastCard(cast: cast[index]),
              ),
            );
          },
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;

  const _CastCard({Key? key, required this.cast}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(cast.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
