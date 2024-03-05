part of 'pokemon_detail_bloc.dart';

sealed class PokemonDetailState {
  final PokemonDto? pokemonState;
  const PokemonDetailState({this.pokemonState});

  void logger();
}

final class PokemonDetailInitialState extends PokemonDetailState {
  @override
  void logger() => log('PokemonDetailState -> PokemonDetailInitialState');
}

final class PokemonDetailLoadingState extends PokemonDetailState {
  @override
  void logger() => log('PokemonDetailState -> PokemonDetailLoadingState');
}

final class PokemonDetailErrorState extends PokemonDetailState {
  @override
  void logger() => log('PokemonDetailState -> PokemonDetailErrorState');
}

final class PokemonDetailLoadedState extends PokemonDetailState {
  final PokemonDto pokemon;
  const PokemonDetailLoadedState({required this.pokemon}) : super(pokemonState: pokemon);

  @override
  void logger() => log('PokemonDetailState -> PokemonDetailLoadedState');
}
