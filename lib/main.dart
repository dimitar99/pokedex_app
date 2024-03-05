import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/core/providers/theme_provider/theme_provider.dart';
import 'package:pokedex_app/layers/data/repository/pokemon/pokemon_repository_impl.dart';
import 'package:pokedex_app/layers/data/source/local/pokemon_local_data_source.dart';
import 'package:pokedex_app/layers/data/source/network/pokemon_remote_data_source.dart';
import 'package:pokedex_app/layers/domain/use-cases/pokemon/pokemon_usecase.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/captured-pokemons-list/bloc/captured_pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/pokemons-list/bloc/pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/home_page.dart';
import 'package:pokedex_app/layers/presentation/features/pokemon-detail/bloc/pokemon_detail_bloc.dart';
import 'package:pokedex_app/layers/presentation/shared/constants/constants.dart';
import 'package:pokedex_app/layers/presentation/shared/utils/pokemon_color_by_type.dart';
import 'package:pokedex_app/layers/presentation/shared/utils/theme_by_color.dart';
import 'package:provider/provider.dart';
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

  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  String? lastPokemonTypeColor = sharedPrefs.getString(Constants.lastPokemonTypeColorKey);
  log('lastPokemonTypeColor $lastPokemonTypeColor');
  ThemeData themeData = getThemeByColor(getPokemonColorByType(lastPokemonTypeColor ?? ''));

  runApp(MainApp(pokemonUseCase: pokemonUseCase, themeData: themeData));
}

class MainApp extends StatefulWidget {
  final PokemonUseCase pokemonUseCase;
  final ThemeData themeData;
  const MainApp({super.key, required this.pokemonUseCase, required this.themeData});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(themeData: widget.themeData)),
        BlocProvider<PokemonsBloc>(create: (_) => PokemonsBloc(pokemonsUseCase: widget.pokemonUseCase)),
        BlocProvider<PokemonDetailBloc>(create: (_) => PokemonDetailBloc(pokemonsUseCase: widget.pokemonUseCase)),
        BlocProvider<CapturedPokemonsBloc>(create: (_) => CapturedPokemonsBloc(pokemonsUseCase: widget.pokemonUseCase)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pokédex Code Challenge',
            theme: context.read<ThemeProvider>().getTheme(),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
