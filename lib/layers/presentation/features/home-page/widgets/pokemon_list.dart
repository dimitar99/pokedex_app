import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/data/dto/pokemon_dto.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/bloc/pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/pokemon-detail/view/pokemon_detail_page.dart';

class PokemonsList extends StatefulWidget {
  const PokemonsList({super.key});

  @override
  State<PokemonsList> createState() => _PokemonsListState();
}

class _PokemonsListState extends State<PokemonsList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Variables to control the state of the page
  bool loading = false, error = false;

  late PokemonsBloc _pokemonsBloc;

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
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PokemonsErrorState) {
          return const Center(child: Text('An error ocurred'));
        }
        // state is PokemonsLoadedState
        return _list(state.listOfPokemonsState);
      },
    );
  }

  Widget _list(List<PokemonDto> listOfPokemons) {
    if (listOfPokemons.isEmpty) return const Center(child: Text('Empty'));

    return RefreshIndicator.adaptive(
      onRefresh: () async => _pokemonsBloc.add(const LoadPokemonsUseCaseAction()),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: listOfPokemons.length,
        itemBuilder: (context, index) {
          PokemonDto pokemon = listOfPokemons[index];
          return ListTile(
            title: Text(pokemon.name ?? ''),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PokemonDetail())),
          );
        },
      ),
    );
  }
}
