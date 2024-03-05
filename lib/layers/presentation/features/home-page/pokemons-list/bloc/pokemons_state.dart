part of 'pokemons_bloc.dart';

sealed class PokemonsState {
  final List<PokemonDto> listOfPokemonsState;
  const PokemonsState({this.listOfPokemonsState = const []});

  void logger();
}

final class PokemonsInitialState extends PokemonsState {
  @override
  void logger() => log('PokemonsState -> PokemonsInitialState');
}

final class PokemonsLoadingState extends PokemonsState {
  @override
  void logger() => log('PokemonsState -> PokemonsLoadingState');
}

final class PokemonsErrorState extends PokemonsState {
  @override
  void logger() => log('PokemonsState -> PokemonsErrorState');
}

final class PokemonsLoadedState extends PokemonsState {
  final List<PokemonDto> listOfPokemons;
  const PokemonsLoadedState({required this.listOfPokemons}) : super(listOfPokemonsState: listOfPokemons);

  @override
  void logger() => log('PokemonsState -> PokemonsLoadedState');
}
