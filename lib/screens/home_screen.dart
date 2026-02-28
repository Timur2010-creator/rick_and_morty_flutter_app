import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/character.dart';
import '../widgets/character_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Character> characters = [];
  int currentPage = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    final newCharacters = await ApiService.fetchCharacters(currentPage);
    setState(() {
      characters.addAll(newCharacters);
      currentPage++;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rick and Morty")),
      body: ListView.separated(
        controller: _scrollController,
        itemCount: characters.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index < characters.length) {
            final character = characters[index];
            return CharacterCard(
              character: character,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(character: character),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            );
          }
        },
      ),
    );
  }
}
