part of 'captured_pokemons_bloc.dart';

sealed class CapturedPokemonsEvent {
  const CapturedPokemonsEvent();
}

class LoadCapturedPokemonsUseCaseAction extends CapturedPokemonsEvent {
  final ThemeProvider themeProvider;
  const LoadCapturedPokemonsUseCaseAction({required this.themeProvider});
}

class FilterCapturedPokemonsUseCaseAction extends CapturedPokemonsEvent {
  final String type;
  final bool alphabetical;
  const FilterCapturedPokemonsUseCaseAction({this.type = '', this.alphabetical = false});
}