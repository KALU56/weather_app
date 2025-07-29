import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final List<String> favoriteCities;
  final Function(String) onSelect;

  const FavoritePage({
    Key? key,
    required this.favoriteCities,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 131, 248),
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        backgroundColor: const Color.fromARGB(255, 89, 148, 250),
      ),
      body: favoriteCities.isEmpty
          ? const Center(
              child: Text('No favorites yet',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            )
          : ListView.builder(
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                final city = favoriteCities[index];
                return ListTile(
                  title: Text(city, style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white),
                  onTap: () {
                    onSelect(city);
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}
