part of 'pokemons_bloc.dart';

sealed class PokemonsState {
  final List<PokemonDto> listOfPokemonsState;
  const PokemonsState({this.listOfPokemonsState = const []});
}

final class PokemonsInitialState extends PokemonsState {}

final class PokemonsLoadingState extends PokemonsState {}

final class PokemonsErrorState extends PokemonsState {}

final class PokemonsLoadedState extends PokemonsState {
  final List<PokemonDto> listOfPokemons;
  const PokemonsLoadedState({required this.listOfPokemons}) : super(listOfPokemonsState: listOfPokemons);
}
