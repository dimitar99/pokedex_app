import 'package:flutter/material.dart';
import 'package:pokedex_app/layers/presentation/features/pokemon-detail/view/pokemon_detail_page.dart';

class PokemonList extends StatefulWidget {
  final String title;
  const PokemonList({super.key, required this.title});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Pokemon $index'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PokemonDetail())),
        );
      },
    );
  }
}
