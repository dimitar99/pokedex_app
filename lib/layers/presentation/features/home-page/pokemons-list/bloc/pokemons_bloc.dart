import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/domain/use-cases/pokemon/pokemon_usecase.dart';

part 'pokemons_event.dart';
part 'pokemons_state.dart';

class PokemonsBloc extends Bloc<PokemonsEvent, PokemonsState> {
  final PokemonUseCase pokemonsUseCase;
  List<PokemonDto> _listOfPokemons = [];
  List<PokemonDto> _filteredPokemonList = [];

  List<PokemonDto> get listOfPokemons => _filteredPokemonList;

  PokemonsBloc({required this.pokemonsUseCase}) : super(PokemonsInitialState()) {
    on<LoadPokemonsUseCaseAction>(_loadPokemonsUseCaseAction);
    on<FilterPokemonsUseCaseAction>(_filterPokemonsUseCaseAction);
  }

  Future _loadPokemonsUseCaseAction(LoadPokemonsUseCaseAction event, Emitter<PokemonsState> emit) async {
    emit(PokemonsLoadingState());
    await pokemonsUseCase.callPokemons().then((result) {
      result.fold(
        (exception) => emit(PokemonsErrorState()),
        (pokemons) {
          _listOfPokemons = List<PokemonDto>.of(pokemons);
          _filteredPokemonList = List<PokemonDto>.of(pokemons);
          emit(PokemonsLoadedState(listOfPokemons: pokemons));
        },
      );
    });
  }

  Future _filterPokemonsUseCaseAction(FilterPokemonsUseCaseAction event, Emitter<PokemonsState> emit) async {
    if (event.name == null && _listOfPokemons.isEmpty) return;

    if (event.name!.isEmpty) {
      _filteredPokemonList = List<PokemonDto>.of(_listOfPokemons);
    } else {
      _filteredPokemonList = List<PokemonDto>.of(_listOfPokemons).where((pokemon) {
        return pokemon.name.toLowerCase().contains(event.name!.toLowerCase());
      }).toList();
    }

    emit(PokemonsLoadedState(listOfPokemons: _filteredPokemonList));
  }
}
