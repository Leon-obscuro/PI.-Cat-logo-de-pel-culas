import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(movie['image']),
            const SizedBox(height: 16),
            Text(
              movie['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Año: ${movie['year']}'),
            Text('Director: ${movie['director']}'),
            Text('Género: ${movie['genre']}'),
            const SizedBox(height: 16),
            Text(movie['synopsis']),
          ],
        ),
      ),
    );
  }
}
