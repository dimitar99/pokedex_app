import 'package:flutter/material.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/widgets/captured_pokemons_list.dart';
import 'package:pokedex_app/layers/presentation/features/home-page/widgets/pokemon_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  List<Widget> listOfPages = [];

  @override
  void initState() {
    listOfPages = const [PokemonsList(), CapturedPokemonsList()];
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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Pokedex'),
        centerTitle: true,
      ),
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
