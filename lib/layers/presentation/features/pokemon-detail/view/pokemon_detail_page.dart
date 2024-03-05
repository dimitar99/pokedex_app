import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/core/providers/theme_provider/theme_provider.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/captured-pokemons-list/bloc/captured_pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/pokemon-detail/bloc/pokemon_detail_bloc.dart';

class PokemonDetail extends StatefulWidget {
  final int pokemonId;
  final String pokemonUrl;
  const PokemonDetail({super.key, required this.pokemonId, this.pokemonUrl = ''});

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  // Bloc instaces
  late PokemonDetailBloc _pokemonDetailBloc;
  late CapturedPokemonsBloc _capturedPokemonsBloc;

  // Pokemon Dto instance
  late PokemonDto _pokemon;

  // Theme Provider instance
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    _pokemonDetailBloc = context.read<PokemonDetailBloc>();
    _pokemonDetailBloc.add(LoadPokemonUseCaseAction(id: widget.pokemonId));
    _capturedPokemonsBloc = context.read<CapturedPokemonsBloc>();
    _pokemon = _pokemonDetailBloc.pokemon;
    _themeProvider = context.read<ThemeProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail page'), centerTitle: true),
      body: BlocConsumer<PokemonDetailBloc, PokemonDetailState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PokemonDetailLoadingState) {
            return _onLoadingState();
          }
          if (state is PokemonDetailErrorState) {
            return _onErrorState();
          }
          _pokemon = _pokemonDetailBloc.pokemon;
          // state is PokemonDetailLoadedState
          return _onLoadedState();
        },
      ),
    );
  }

  Center _onLoadingState() => const Center(child: CircularProgressIndicator());

  Center _onErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('An error ocurred'),
          ElevatedButton(
            onPressed: () => _pokemonDetailBloc.add(LoadPokemonUseCaseAction(id: widget.pokemonId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _onLoadedState() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image(_pokemon),
            _label('ID:'),
            Text('${_pokemon.id}'),
            _label('Name:'),
            Text(_pokemon.name),
            _label('Height:'),
            Text('${_pokemon.height}'),
            _label('Name:'),
            Text('${_pokemon.weight}'),
            _label('Types:'),
            for (var element in _pokemon.types)
              if (element.type?.name != null) Text('- ${element.type!.name}'),
            _capturePokemonBtn(),
          ],
        ),
      ),
    );
  }

  Image _image(PokemonDto pokemon) {
    return Image.network(
      pokemon.sprites?.frontDefault ?? '',
      width: 100,
      errorBuilder: (context, error, stackTrace) => const Text('Something went wrong while loading the image'),
    );
  }

  Container _label(String label) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Text(label, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Container _capturePokemonBtn() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 24.0),
      child: ElevatedButton(
        onPressed: () => _pokemonDetailBloc.add(
          CaptureOrReleasePokemonUseCaseAction(
            url: widget.pokemonUrl,
            capturedPokemonsBloc: _capturedPokemonsBloc,
            themeProvider: _themeProvider,
          ),
        ),
        child: Text('${_pokemonDetailBloc.isCaptured ? 'Release' : 'Capture'} pokemon'),
      ),
    );
  }
}
