import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/captured-pokemons-list/bloc/captured_pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/pokemon-detail/view/pokemon_detail_page.dart';

class CapturedPokemonsList extends StatefulWidget {
  const CapturedPokemonsList({super.key});

  @override
  State<CapturedPokemonsList> createState() => _CapturedPokemonsListState();
}

class _CapturedPokemonsListState extends State<CapturedPokemonsList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Bloc instace
  late CapturedPokemonsBloc _capturedPokemonsBloc;

  // DropDown value
  String dropDownValue = '';

  // Switch value
  bool switchValue = false;

  @override
  void initState() {
    _capturedPokemonsBloc = context.read<CapturedPokemonsBloc>();
    _capturedPokemonsBloc.add(const LoadCapturedPokemonsUseCaseAction());
    dropDownValue = _capturedPokemonsBloc.pokemonTypes.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<CapturedPokemonsBloc, CapturedPokemonsState>(
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
          onPressed: () => _capturedPokemonsBloc.add(const LoadCapturedPokemonsUseCaseAction()),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _onLoadedState() {
    return Column(
      children: [
        _filters(),
        _pokemonsList(),
      ],
    );
  }

  Row _filters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _typesDropDown(),
        _alphabeticalSwitch(),
      ],
    );
  }

  DropdownButton _typesDropDown() {
    return DropdownButton(
      selectedItemBuilder: (context) => _capturedPokemonsBloc.pokemonTypes.map((e) => Text(e)).toList(),
      hint: Text(dropDownValue),
      items: List<DropdownMenuItem>.from(_capturedPokemonsBloc.pokemonTypes.map((e) => DropdownMenuItem(value: e, child: Text(e)))),
      onChanged: (Object? value) {
        setState(() => dropDownValue = value as String);
        _capturedPokemonsBloc.add(FilterCapturedPokemonsUseCaseAction(type: dropDownValue, alphabetical: switchValue));
      },
    );
  }

  Row _alphabeticalSwitch() {
    return Row(
      children: [
        const Icon(Icons.abc),
        Switch.adaptive(
          value: switchValue,
          onChanged: (value) {
            setState(() => switchValue = value);
            _capturedPokemonsBloc.add(FilterCapturedPokemonsUseCaseAction(type: dropDownValue, alphabetical: switchValue));
          },
        ),
      ],
    );
  }

  Expanded _pokemonsList() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _capturedPokemonsBloc.listOfPokemons.length,
        itemBuilder: (context, index) {
          PokemonDto pokemon = _capturedPokemonsBloc.listOfPokemons[index];
          return ListTile(
            title: Text(pokemon.name.isEmpty ? 'Without name' : pokemon.name),
            onTap: () {
              log(pokemon.toRawJson());
              if (pokemon.url.isNotEmpty) {
                int pokemonId = _getPokemonId(pokemon.url);
                if (pokemonId != 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetail(pokemonId: pokemonId)));
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
