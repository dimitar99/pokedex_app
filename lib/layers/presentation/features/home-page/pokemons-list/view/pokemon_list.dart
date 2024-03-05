import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/pokemons-list/bloc/pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/pokemon-detail/view/pokemon_detail_page.dart';

class PokemonsList extends StatefulWidget {
  const PokemonsList({super.key});

  @override
  State<PokemonsList> createState() => _PokemonsListState();
}

class _PokemonsListState extends State<PokemonsList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Bloc instace
  late PokemonsBloc _pokemonsBloc;

  // Text field controller
  final TextEditingController _searchFieldController = TextEditingController();

  @override
  void initState() {
    _pokemonsBloc = context.read<PokemonsBloc>();
    _pokemonsBloc.add(const LoadPokemonsUseCaseAction());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<PokemonsBloc, PokemonsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is PokemonsLoadingState) {
          return _onLoadingState();
        }
        if (state is PokemonsErrorState) {
          return _onErrorState();
        }
        // state is PokemonsLoadedState
        return _onLoadedState();
      },
    );
  }

  Center _onLoadingState() => const Center(child: CircularProgressIndicator());

  Column _onErrorState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('An error ocurred'),
        ElevatedButton(
          onPressed: () => _pokemonsBloc.add(const LoadPokemonsUseCaseAction()),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _onLoadedState() {
    return Column(
      children: [
        _searchField(),
        _pokemonsList(),
      ],
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: _searchFieldController,
        decoration: InputDecoration(
          label: const Text('Busca un pokemon...'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        onChanged: (value) => _pokemonsBloc.add(FilterPokemonsUseCaseAction(name: value)),
      ),
    );
  }

  Expanded _pokemonsList() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _pokemonsBloc.listOfPokemons.length,
        itemBuilder: (context, index) {
          PokemonDto pokemon = _pokemonsBloc.listOfPokemons[index];
          return ListTile(
            title: Text(pokemon.name.isEmpty ? 'Sin nombre' : pokemon.name),
            onTap: () {
              log(pokemon.toRawJson());
              if (pokemon.url.isNotEmpty) {
                int pokemonId = _getPokemonId(pokemon.url);
                if (pokemonId != 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetail(pokemonId: pokemonId, pokemonUrl: pokemon.url)));
                }
              }
            },
          );
        },
      ),
    );
  }

  int _getPokemonId(String pokemonUrl) {
    String id = pokemonUrl.isNotEmpty ? (pokemonUrl.endsWith('/') ? pokemonUrl.substring(0, pokemonUrl.length - 1) : pokemonUrl).split('/').last : "";
    return int.tryParse(id) ?? 0;
  }
}
