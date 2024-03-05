part of 'captured_pokemons_bloc.dart';

sealed class CapturedPokemonsState {
  final List<PokemonDto> listOfPokemonsState;
  const CapturedPokemonsState({this.listOfPokemonsState = const []});

  void logger();
}

final class PokemonsInitialState extends CapturedPokemonsState {
  @override
  void logger() => log('CapturedPokemonsState -> PokemonsInitialState');
}

final class PokemonsLoadingState extends CapturedPokemonsState {
  @override
  void logger() => log('CapturedPokemonsState -> PokemonsLoadingState');
}

final class PokemonsErrorState extends CapturedPokemonsState {
  @override
  void logger() => log('CapturedPokemonsState -> PokemonsErrorState');
}

final class PokemonsLoadedState extends CapturedPokemonsState {
  final List<PokemonDto> listOfPokemons;
  const PokemonsLoadedState({required this.listOfPokemons}) : super(listOfPokemonsState: listOfPokemons);

  @override
  void logger() => log('CapturedPokemonsState -> PokemonsLoadedState');
}
