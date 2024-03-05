part of 'captured_pokemons_bloc.dart';

sealed class CapturedPokemonsEvent {
  const CapturedPokemonsEvent();
}

class LoadCapturedPokemonsUseCaseAction extends CapturedPokemonsEvent {
  const LoadCapturedPokemonsUseCaseAction();
}

class FilterCapturedPokemonsUseCaseAction extends CapturedPokemonsEvent {
  final String type;
  final bool alphabetical;
  const FilterCapturedPokemonsUseCaseAction({this.type = '', this.alphabetical = false});
}