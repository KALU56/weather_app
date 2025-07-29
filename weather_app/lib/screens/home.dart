import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 89, 148, 250),
      body: Padding(
      
        padding: const EdgeInsets.all(8.0),
        
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search here...',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search,color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
              ),
            
            ),
          ],
        ),
      ),
    );
  }
}
