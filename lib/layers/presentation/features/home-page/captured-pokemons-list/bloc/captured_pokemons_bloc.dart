import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/domain/use-cases/pokemon/pokemon_usecase.dart';

part 'captured_pokemons_event.dart';
part 'captured_pokemons_state.dart';

class CapturedPokemonsBloc extends Bloc<CapturedPokemonsEvent, CapturedPokemonsState> {
  final PokemonUseCase pokemonsUseCase;
  List<PokemonDto> _listOfPokemons = [];
  List<PokemonDto> _filteredPokemonList = [];

  List<PokemonDto> get listOfPokemons => _filteredPokemonList;
  List<String> get pokemonTypes {
    List<String> pokemonTypes = [];
    for (var pokemon in _listOfPokemons) {
      for (var pokemonType in pokemon.types) {
        if (pokemonType.type?.name != null) pokemonTypes.add(pokemonType.type!.name!);
      }
    }
    // Lo pasamos a Set para eliminar los duplicados y luego a list de nuevo
    pokemonTypes = pokemonTypes.toSet().toList();

    // Ordenamos alfabeticamente
    pokemonTypes.sort((a, b) => a.compareTo(b));
    pokemonTypes.insert(0, 'All');
    return pokemonTypes;
  }

  CapturedPokemonsBloc({required this.pokemonsUseCase}) : super(PokemonsInitialState()) {
    on<LoadCapturedPokemonsUseCaseAction>(_loadPokemonsUseCaseAction);
    on<FilterCapturedPokemonsUseCaseAction>(_filterPokemonsUseCaseAction);
  }

  Future _loadPokemonsUseCaseAction(LoadCapturedPokemonsUseCaseAction event, Emitter<CapturedPokemonsState> emit) async {
    emit(PokemonsLoadingState());
    await pokemonsUseCase.callCapturedPokemons().then((result) {
      result.fold(
        (exception) => emit(PokemonsErrorState()),
        (pokemons) {
          _listOfPokemons = List<PokemonDto>.of(pokemons);
          _filteredPokemonList = List<PokemonDto>.of(pokemons);
          // Ordenamos por id por defecto
          _filteredPokemonList.sort((a, b) => a.id!.compareTo(b.id!));
          emit(PokemonsLoadedState(listOfPokemons: pokemons));
        },
      );
    });
  }

  Future _filterPokemonsUseCaseAction(FilterCapturedPokemonsUseCaseAction event, Emitter<CapturedPokemonsState> emit) async {
    if (_listOfPokemons.isEmpty) return;

    _filteredPokemonList = List<PokemonDto>.of(_listOfPokemons);

    // Ordenamos por id por defecto
    _filteredPokemonList.sort((a, b) => a.id!.compareTo(b.id!));

    // Ordenamos por tipo
    if (event.type.isNotEmpty && event.type != 'All') {
      _filteredPokemonList = _filteredPokemonList.map((e) => e).where((pokemon) => pokemon.types.any((type) => type.type?.name == event.type)).toList();
    }

    // Ordenamos alfabeticamente
    if (event.alphabetical) {
      _filteredPokemonList.sort((a, b) => a.name.compareTo(b.name));
    } else {
      _filteredPokemonList.sort((a, b) => b.name.compareTo(a.name));
    }

    emit(PokemonsLoadedState(listOfPokemons: _filteredPokemonList));
  }
}
