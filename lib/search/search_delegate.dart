import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart' show Movie;
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Bucar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
      IconButton(
        onPressed: () => {},
        icon: const Icon(Icons.search_outlined),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  Widget _EmptyContainer() {
    return const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.black38,
        size: 130,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _EmptyContainer();
    }
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        print(snapshot.data);
        if (!snapshot.hasData) return _EmptyContainer();
        final movies = snapshot.data!;
        return ListView.builder(
          itemBuilder: (_, int index) => _MovieItem(movie: movies[index]),
          itemCount: movies.length,
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Hero(
          tag: movie.heroId!,
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterUrl),
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(movie.title),
        subtitle: Row(
          children: [
            const Icon(
              Icons.star_border_outlined,
              size: 15,
            ),
            Text(movie.voteAverage.toString()),
            const SizedBox(
              width: 20,
            ),
            Text(movie.releaseDate.toString()),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: movie);
        },
      ),
    );
  }
}
