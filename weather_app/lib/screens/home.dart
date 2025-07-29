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
    IconData getWeatherIcon(String mainWeather) {
    switch (mainWeather.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.grain;
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return Icons.blur_on;
      default:
        return Icons.help_outline;
    }
  }
    Widget buildWeatherInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 99, 203, 245)),
        Text(value, style: const TextStyle(color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
    List<Widget> getWeatherDetailsWidgets(Map<String, dynamic> data) {
    final main = data['weather'][0]['main'].toLowerCase();

    if (main == 'rain' || main == 'drizzle' || main == 'thunderstorm') {
      return [
        buildWeatherInfo(Icons.beach_access, '${data['rain']?['1h'] ?? 0} mm', 'Rain'),
        buildWeatherInfo(Icons.air, '${data['wind']['speed']} km/h', 'Wind'),
        buildWeatherInfo(Icons.opacity, '${data['main']['humidity']}%', 'Humidity'),
      ];
    } else if (main == 'clear') {
      return [
        buildWeatherInfo(Icons.wb_sunny, 'High', 'UV'),
        buildWeatherInfo(Icons.opacity, '${data['main']['humidity']}%', 'Humidity'),
        buildWeatherInfo(Icons.air, '${data['wind']['speed']} km/h', 'Wind'),
      ];
    } else if (main == 'clouds') {
      return [
        buildWeatherInfo(Icons.cloud, 'Cloudy', 'Sky'),
        buildWeatherInfo(Icons.opacity, '${data['main']['humidity']}%', 'Humidity'),
        buildWeatherInfo(Icons.air, '${data['wind']['speed']} km/h', 'Wind'),
      ];
    } else {
      return [
        buildWeatherInfo(Icons.info, 'N/A', 'Info'),
      ];
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
            const SizedBox(height: 45),
             if (isLoading) 
              const CircularProgressIndicator(color: Colors.white) 
            else if (errorMessage != null) 
              Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 18)) 
            else if (weatherData != null) 

            Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${weatherData!['name']}, ${weatherData!['sys']['country']}',
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      getWeatherIcon(weatherData!['weather'][0]['main']),
                      size: 70,
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
                      children: getWeatherDetailsWidgets(weatherData!),
                    ),
                  ],
                ),
            Expanded(
              child: Row(
                te


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
