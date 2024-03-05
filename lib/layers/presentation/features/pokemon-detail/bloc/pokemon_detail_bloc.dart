import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/domain/use-cases/pokemon/pokemon_usecase.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/captured-pokemons-list/bloc/captured_pokemons_bloc.dart';

part 'pokemon_detail_event.dart';
part 'pokemon_detail_state.dart';

class PokemonDetailBloc extends Bloc<PokemonEvent, PokemonDetailState> {
  final PokemonUseCase pokemonsUseCase;

  PokemonDto _pokemon = PokemonDto.empty;
  PokemonDto get pokemon => _pokemon;

  bool _isCaptured = false;
  bool get isCaptured => _isCaptured;

  PokemonDetailBloc({required this.pokemonsUseCase}) : super(PokemonDetailInitialState()) {
    on<LoadPokemonUseCaseAction>(_loadPokemonUseCaseAction);
    on<CaptureOrReleasePokemonUseCaseAction>(_captureOrReleasePokemonUseCaseAction);
  }

  Future _loadPokemonUseCaseAction(LoadPokemonUseCaseAction event, Emitter<PokemonDetailState> emit) async {
    emit(PokemonDetailLoadingState());
    await pokemonsUseCase.callPokemon(event.id).then((result) {
      result.fold(
        (exception) => emit(PokemonDetailErrorState()),
        (pokemon) {
          _pokemon = pokemon;
          log('is captured -> ${pokemon.isCaptured}');
          _isCaptured = pokemon.isCaptured;
          emit(PokemonDetailLoadedState(pokemon: _pokemon));
        },
      );
    });
  }

  Future _captureOrReleasePokemonUseCaseAction(CaptureOrReleasePokemonUseCaseAction event, Emitter<PokemonDetailState> emit) async {
    emit(PokemonDetailLoadingState());
    await pokemonsUseCase.callCaptureOrReleasePokemon(pokemon.copyWith(url: event.url)).then((result) {
      result.fold(
        (exception) => null,
        (pokemon) {
          if (pokemon == null) {
            _pokemon.copyWith(isCaptured: false);
            _isCaptured = false;

          }else{
            _pokemon.copyWith(isCaptured: true);
            _isCaptured = true;
          }
          emit(PokemonDetailLoadedState(pokemon: _pokemon));
          event.capturedPokemonsBloc.add(const LoadCapturedPokemonsUseCaseAction());
        },
      );
    });
  }
}
