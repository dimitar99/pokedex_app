import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/layers/data/repository/pokemon/pokemon_repository_impl.dart';
import 'package:pokedex_app/layers/data/source/local/pokemon_local_data_source.dart';
import 'package:pokedex_app/layers/data/source/network/pokemon_remote_data_source.dart';
import 'package:pokedex_app/layers/domain/use-cases/pokemon/pokemon_usecase.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/bloc/pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/view/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Nos aseguramos que la infraestructura fundamental esta inicializada antes de iniciar la app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Shared preferences instance
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  
  // Data sources
  PokemonLocalDataSource pokemonLocalDataSource = PokemonLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  PokemonRemoteDataSource pokemonRemoteDataSource = PokemonRemoteDataSourceImpl();
  
  // Repository
  PokemonRepositoryImpl pokemonRepositoryImpl = PokemonRepositoryImpl(
    pokemonLocalDataSource: pokemonLocalDataSource,
    pokemonRemoteDataSource: pokemonRemoteDataSource,
  );
  
  // Use case
  PokemonUseCase pokemonUseCase = PokemonUseCase(pokemonRepository: pokemonRepositoryImpl);

  runApp(AppState(pokemonUseCase: pokemonUseCase));
}

class AppState extends StatefulWidget {
  final PokemonUseCase pokemonUseCase;
  const AppState({super.key, required this.pokemonUseCase});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PokemonsBloc>(create: (_) => PokemonsBloc(pokemonsUseCase: widget.pokemonUseCase)),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex Code Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
