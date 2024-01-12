import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class Pokemon {
  final int number;
  final String name;
  final List<String> type;
  final String imageUrl;

  Pokemon({
    required this.number,
    required this.name,
    required this.type,
    required this.imageUrl,
  });
}

class PokemonDetail {
  final double height;
  final double weight;
  final List<String> weaknesses;

  PokemonDetail({
    required this.height,
    required this.weight,
    required this.weaknesses,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late List<Pokemon> pokemonList;

  @override
  void initState() {
    super.initState();
    fetchPokemonList();
  }

  Future<void> fetchPokemonList() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json'));
    final jsonData = json.decode(response.body);
    final List<Pokemon> pokemonList = [];

    for (var pokemonData in jsonData['pokemon']) {
      pokemonList.add(Pokemon(
        number: int.parse(pokemonData['num']),
        name: pokemonData['name'],
        type: List<String>.from(pokemonData['type']),
        imageUrl: pokemonData['img'],
      ));
    }

    setState(() {
      this.pokemonList = pokemonList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex'),
      ),
      body: pokemonList == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailScreen(
                          pokemon: pokemonList[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: pokemonList[index].imageUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      title: Text(
                        '#${pokemonList[index].number.toString().padLeft(3, '0')} ${pokemonList[index].name}',
                      ),
                      subtitle: Text('Type: ${pokemonList[index].type.join(', ')}'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  PokemonDetailScreen({required this.pokemon});

  @override
  PokemonDetailScreenState createState() => PokemonDetailScreenState();
}

class PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late PokemonDetail pokemonDetail;

  @override
  void initState() {
    super.initState();
    pokemonDetail = PokemonDetail(
      height: 0.0,
      weight: 0.0,
      weaknesses: [],
    );
    fetchPokemonDetail();
  }

  Future<void> fetchPokemonDetail() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json'));
    final jsonData = json.decode(response.body);

    final List<dynamic> pokemonList = jsonData['pokemon'];

    final pokemonData = pokemonList.firstWhere(
      (pokemon) => pokemon['num'] == widget.pokemon.number.toString().padLeft(3, '0'),
      orElse: () => null,
    );

    if (pokemonData != null) {
      double parseHeight(String height) {
        try {
          return double.tryParse(height.replaceAll(' m', '')) ?? 0.0;
        } catch (e) {
          return 0.0;
        }
      }

      double parseWeight(String weight) {
        try {
          return double.tryParse(weight.replaceAll(' kg', '')) ?? 0.0;
        } catch (e) {
          return 0.0;
        }
      }

      setState(() {
        pokemonDetail = PokemonDetail(
          height: parseHeight(pokemonData['height'].toString()),
          weight: parseWeight(pokemonData['weight'].toString()),
          weaknesses: List<String>.from(pokemonData['weaknesses']),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name),
      ),
      body: Card(
        margin: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: CachedNetworkImage(
                imageUrl: widget.pokemon.imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            ListTile(
              title: Text(
                'Height',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${pokemonDetail.height} m'),
            ),
            ListTile(
              title: Text(
                'Weight',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${pokemonDetail.weight} kg'),
            ),
            ListTile(
              title: Text(
                'Weaknesses',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${pokemonDetail.weaknesses.join(', ')}'),
            ),
          ],
        ),
      ),
    );
  }
}

