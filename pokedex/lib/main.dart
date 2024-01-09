import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Pokemon {
  final int id;
  final String name;
  final String img;
  final List<String> type;

  Pokemon({
    required this.id,
    required this.name,
    required this.img,
    required this.type,
  });
}

class MyApp extends StatelessWidget {
  final List<Pokemon> pokemonList = [
    Pokemon(
      id: 1,
      name: "Bulbasaur",
      img: "assets/1.jpg",
      type: ["Grass", "Poison"],
    ),
    Pokemon(
      id: 2,
      name: "Ivysaur",
      img: "assets/2.png",
      type: ["Grass", "Poison"],
    ),
    Pokemon(
      id: 3,
      name: "Venusaur",
      img: "assets/3.png",
      type: ["Grass", "Poison"],
    ),
    Pokemon(
      id: 4,
      name: "Charmander",
      img: "assets/4.png",
      type: ["Fire"],
    ),
     Pokemon(
      id: 5,
      name: "Charmeleon",
      img: "assets/5.png",
      type: ["Fire"],
    ),
    Pokemon(
      id: 6,
      name: "Charizard",
      img: "assets/6.png",
      type: ["Fire", "Flying"],
    ),
    Pokemon(
      id: 7,
      name: "Squirtle",
      img: "assets/7.png",
      type: ["Water"],
    ),
    Pokemon(
      id: 8,
      name: "Wartortle",
      img: "assets/8.png",
      type: ["Water"],
    ),
    Pokemon(
      id: 9,
      name: "Blastoise",
      img: "assets/9.png",
      type: ["Water"],
    ),
    Pokemon(
      id: 10,
      name: "Caterpie",
      img: "assets/10.png",
      type: ["Bug"],
    ),



  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pokedex'),
        ),
        body: PokemonListView(pokemonList: pokemonList),
      ),
    );
  }
}

class PokemonListView extends StatelessWidget {
  final List<Pokemon> pokemonList;

  PokemonListView({required this.pokemonList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        return PokemonCard(pokemon: pokemonList[index]);
      },
    );
  }
}

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          pokemon.img,
          width: 50,
          height: 50,
        ),
        title: Text(
          "${pokemon.id}. ${pokemon.name}",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Type: ${pokemon.type.join(', ')}"),
        onTap: () {
        },
      ),
    );
  }
}

