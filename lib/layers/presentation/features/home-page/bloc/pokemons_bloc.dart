import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/data/dto/pokemon_dto.dart';
import 'package:pokedex_app/layers/domain/use-cases/pokemon/pokemon_usecase.dart';

part 'pokemons_event.dart';
part 'pokemons_state.dart';

class PokemonsBloc extends Bloc<PokemonsEvent, PokemonsState> {
  final PokemonUseCase pokemonsUseCase;

  PokemonsBloc({required this.pokemonsUseCase}) : super(PokemonsInitialState()) {
    on<LoadPokemonsUseCaseAction>(_loadPokemonsUseCaseAction);
  }

  Future _loadPokemonsUseCaseAction(LoadPokemonsUseCaseAction event, Emitter<PokemonsState> emit) async {
    emit(PokemonsLoadingState());
    await pokemonsUseCase.callPokemons().then((result) {
      result.fold(
        (exception) => emit(PokemonsErrorState()),
        (pokemons) => emit(PokemonsLoadedState(listOfPokemons: pokemons)),
      );
    });
  }
}
