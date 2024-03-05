part of 'pokemons_bloc.dart';

sealed class PokemonsEvent {
  const PokemonsEvent();
}

class LoadPokemonsUseCaseAction extends PokemonsEvent {
  const LoadPokemonsUseCaseAction();
}

class FilterPokemonsUseCaseAction extends PokemonsEvent {
  final String? name;
  const FilterPokemonsUseCaseAction({this.name = ''});
}