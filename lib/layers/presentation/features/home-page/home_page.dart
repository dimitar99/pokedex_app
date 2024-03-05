import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/core/providers/theme_provider/theme_provider.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/captured-pokemons-list/bloc/captured_pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/captured-pokemons-list/view/captured_pokemons_list.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/pokemons-list/bloc/pokemons_bloc.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/pokemons-list/view/pokemons_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Page Controller instance
  final PageController _pageController = PageController();

  // List of pages
  List<Widget> listOfPages = [];

  // Bloc instaces
  late PokemonsBloc _pokemonsBloc;
  late CapturedPokemonsBloc _capturedPokemonsBloc;

  // Theme Provider instance
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    _pokemonsBloc = context.read<PokemonsBloc>();
    _capturedPokemonsBloc = context.read<CapturedPokemonsBloc>();
    _themeProvider = context.read<ThemeProvider>();

    _pokemonsBloc.add(const LoadPokemonsUseCaseAction());
    _capturedPokemonsBloc.add(LoadCapturedPokemonsUseCaseAction(themeProvider: _themeProvider));

    listOfPages = const [
      PokemonsList(),
      CapturedPokemonsList(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokedex'), centerTitle: true),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: listOfPages,
      ),
      bottomNavigationBar: TabBar(
        controller: TabController(length: listOfPages.length, vsync: this),
        onTap: (value) => _pageController.jumpToPage(value),
        tabs: const [
          Tab(icon: Icon(Icons.chrome_reader_mode), child: Text('Pokedex')),
          Tab(icon: Icon(Icons.catching_pokemon), child: Text('Captured')),
        ],
      ),
    );
  }
}
