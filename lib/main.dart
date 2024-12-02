import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Pelis',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MovieDetailScreen(),
    const AdminScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App-movies'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Administración',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a App-movies',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de registro
              },
              child: const Text('Registrarse'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarvelCharactersSection();
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Administrar películas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Año'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Director'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Género'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Sinopsis'),
              maxLines: 4,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'URL de la imagen'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar la película
              },
              child: const Text('Guardar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para eliminar una película
              },
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ),
    );
  }
}

class MarvelCharactersSection extends StatelessWidget {
  const MarvelCharactersSection({super.key});

  String generateMd5Hash(
      String timestamp, String privateKey, String publicKey) {
    final input = timestamp + privateKey + publicKey;
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  Future<List<dynamic>> fetchMarvelData() async {
    String publicKey = 'tu_public_key';
    String privateKey = 'tu_private_key';

    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    String hash = generateMd5Hash(timestamp, privateKey, publicKey);

    String url =
        'https://gateway.marvel.com/v1/public/characters?ts=$timestamp&apikey=$publicKey&hash=$hash';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data']['results'];
    } else {
      throw Exception('Error al obtener los personajes de Marvel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchMarvelData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var characters = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: characters?.length ?? 0,
            itemBuilder: (context, index) {
              var character = characters?[index];
              return ListTile(
                title: Text(character['name']),
                subtitle: Text(character['description'] ?? 'Sin descripción'),
                leading: Image.network(
                  '${character['thumbnail']['path']}.${character['thumbnail']['extension']}',
                  width: 50,
                  height: 50,
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No hay datos disponibles'));
        }
      },
    );
  }
}
