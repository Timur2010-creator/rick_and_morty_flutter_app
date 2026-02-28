import 'package:flutter/material.dart';
import '../models/character.dart';

class DetailScreen extends StatelessWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: Center( // Центрируем весь контент
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // по вертикали
            crossAxisAlignment: CrossAxisAlignment.center, // по горизонтали
            children: [
              Image.network(character.image, height: 300),
              const SizedBox(height: 20),
              Text("Имя: ${character.name}", style: const TextStyle(fontSize: 25)),
              Text("Гендер: ${character.gender}"),
              Text("Статус: ${character.status}"),
              Text("Локация: ${character.location}"),
              Text("Вид: ${character.species}"),
            ],
          ),
        ),
      ),
    );
  }
}
