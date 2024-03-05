part of 'pokemon_detail_bloc.dart';

sealed class PokemonEvent {
  const PokemonEvent();
}

class LoadPokemonUseCaseAction extends PokemonEvent {
  final int id;
  const LoadPokemonUseCaseAction({required this.id});
}

class CaptureOrReleasePokemonUseCaseAction extends PokemonEvent {
  final String url;
  final CapturedPokemonsBloc capturedPokemonsBloc;
  final ThemeProvider themeProvider;
  const CaptureOrReleasePokemonUseCaseAction({required this.url, required this.capturedPokemonsBloc, required this.themeProvider});
}