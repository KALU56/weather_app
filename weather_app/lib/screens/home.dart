import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String? errorMessage;


  final String apiKey = '56f255812ae46fcf7ae2f411cc5262c9';

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      weatherData = null;
    });

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherData = data;
        });
      } else {
        setState(() {
          errorMessage = 'City not found. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching weather. Check your connection.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
    void _search() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      fetchWeather(city);
      FocusScope.of(context).unfocus(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 89, 148, 250),
      body: Padding(
      
        padding: const EdgeInsets.all(8.0),
        
        child: Column(
          children: [
            TextField(
              controller: _controller,
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
             onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 20),
             if (isLoading) 
              const CircularProgressIndicator(color: Colors.white) 
            else if (errorMessage != null) 
              Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 18)) 
            else if (weatherData != null) 

             Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${weatherData!['name']}, ${weatherData!['sys']['country']}',
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      Icons.cloud, // You can replace with dynamic icons based on weather condition
                      size: 100,
                      color: const Color.fromARGB(255, 99, 203, 245),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${weatherData!['main']['temp'].round()}°C',
                      style: const TextStyle(color: Colors.white, fontSize: 50),
                    ),
                    Text(
                      weatherData!['weather'][0]['description'],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.opacity, color: Color.fromARGB(255, 99, 203, 245)),
                            Text('${weatherData!['main']['humidity']}%', style: const TextStyle(color: Colors.white)),
                            const Text('Humidity', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.beach_access, color: Color.fromARGB(255, 99, 203, 245)),
                            Text('${weatherData!['rain']?['1h'] ?? 0} mm', style: const TextStyle(color: Colors.white)),
                            const Text('Rain', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.air, color: Color.fromARGB(255, 99, 203, 245)),
                            Text('${weatherData!['wind']['speed']} km/h', style: const TextStyle(color: Colors.white)),
                            const Text('Wind', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    'Search for a city to get weather info',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}
