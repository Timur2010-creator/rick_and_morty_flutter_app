import 'dart:async';
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
  String searchQuery = "";
  Timer? _debounce;

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

  Future<void> fetchData({bool reset = false}) async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (reset) {
      currentPage = 1;
      characters.clear();
    }

    try {
      final newCharacters = await ApiService.fetchCharacters(
        page: currentPage,
        query: searchQuery,
      );
      setState(() {
        characters.addAll(newCharacters);
        currentPage++;
      });
    } catch (e) {
      if (reset) {
        setState(() {
          characters.clear();
        });
      }
    }

    setState(() => isLoading = false);
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query;
      });
      fetchData(reset: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Поиск персонажей...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: onSearchChanged,
        ),
      ),
      body: ListView.separated(
        controller: _scrollController,
        itemCount: characters.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index < characters.length) {
            final character = characters[index];
            return CharacterCard(
              character: character,
              highlight: searchQuery, // подсветка
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
