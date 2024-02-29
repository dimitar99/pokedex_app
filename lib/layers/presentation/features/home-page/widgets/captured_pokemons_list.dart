import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/bloc/pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/pokemon-detail/view/pokemon_detail_page.dart';

class CapturedPokemonsList extends StatefulWidget {
  const CapturedPokemonsList({super.key});

  @override
  State<CapturedPokemonsList> createState() => _CapturedPokemonsListState();
}

class _CapturedPokemonsListState extends State<CapturedPokemonsList> {
  bool loading = false, error = false;

  @override
  void initState() {
    // context.read<PokemonsBloc>().add(const LoadPokemonsUseCaseAction());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    return BlocConsumer<PokemonsBloc, PokemonsState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case PokemonsLoadingState:
            setState(() => {loading = true, error = false});
            break;
          case PokemonsLoadedState:
            setState(() => {loading = false, error = false});
            break;
          case PokemonsErrorState:
            setState(() => {loading = false, error = true});
            break;
        }
      },
      builder: (context, state) {
        if (loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if(error){
          return const Center(child: Text('An error ocurred'));
        }
        return _list();
      },
    );
  }

  ListView _list() {
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
