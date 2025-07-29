import 'package:flutter/material.dart';

import 'package:weather_app/widget/bottom_navigation.dart';
import 'package:weather_app/widget/weatherpage.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // // This will track favorite cities
  // List<String> favoriteCities = [];

  // This will track the selected city to show in WeatherPage
  String selectedCity = "Addis Ababa";

  // Callback when user taps a bottom nav item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // // Callback to add favorite city
  // void addFavoriteCity(String city) {
  //   if (!favoriteCities.contains(city)) {
  //     setState(() {
  //       favoriteCities.add(city);
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('$city added to favorites')),
  //     );
  //   }
  // }

  // When user picks a city from FavoritePage
  void onCitySelected(String city) {
    setState(() {
      selectedCity = city;
      _selectedIndex = 0; // go back to WeatherPage
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      WeatherPage(
     
      ),
      // FavoritePage(
      //   favoriteCities: favoriteCities,
      //   onSelect: onCitySelected,
      // ),
      const Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavidater(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
