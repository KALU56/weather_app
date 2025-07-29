import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? weatherData;
  List<dynamic>? hourlyForecast;
  String city = "Addis Ababa";
  bool isLoading = false;
  String? errorMessage;

  final String apiKey = '56f255812ae46fcf7ae2f411cc5262c9'; // <-- Add your real OpenWeatherMap API key here

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Reset error before new fetch
    });

    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey',
      );
      final forecastUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey',
      );

      final currentResponse = await http.get(url);
      final forecastResponse = await http.get(forecastUrl);

      if (currentResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        setState(() {
          weatherData = json.decode(currentResponse.body);
          hourlyForecast = json.decode(forecastResponse.body)['list'];
          isLoading = false;
        });
      } else {
        setState(() {
          weatherData = null;
          hourlyForecast = null;
          isLoading = false;
          errorMessage = "City not found or API error";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to fetch weather data";
      });
      print("Error: $e");
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

  Widget buildWeatherIcon(String iconCode, {double size = 60}) {
    return Image.network(
      'https://openweathermap.org/img/wn/$iconCode@2x.png',
      width: size,
      height: size,
    );
  }

  Widget buildWeatherInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 99, 203, 245)),
        const SizedBox(height: 4),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
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
              onSubmitted: (value) {
                city = value.trim();
                if (city.isNotEmpty) {
                  fetchWeather(city);
                }
              },
            ),
            const SizedBox(height: 20),

            // Show error message if any
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18),
              ),

            // Show loading indicator while fetching
            if (isLoading)
              const Center(child: CircularProgressIndicator()),

            // Show weather data when available and not loading
            if (weatherData != null && !isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${weatherData!['name']}, ${weatherData!['sys']['country']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
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
                      const SizedBox(height: 20),
                      const Text(
                        'Hourly Forecast',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 120,
                        child: hourlyForecast != null
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    hourlyForecast!.length < 10 ? hourlyForecast!.length : 10,
                                itemBuilder: (context, index) {
                                  final hourData = hourlyForecast![index];
                                  final time = DateTime.parse(hourData['dt_txt']);
                                  final hour = '${time.hour}:00';
                                  final icon = hourData['weather'][0]['icon'];
                                  final temp = hourData['main']['temp'];

                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(hour,
                                            style: const TextStyle(
                                                color: Colors.white)),
                                        buildWeatherIcon(icon, size: 40),
                                        Text('${temp.toStringAsFixed(1)}°C',
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text('Loading...',
                                    style: TextStyle(color: Colors.white)),
                              ),
                      )
                    ],
                  ),
                ),
              ),

            // Prompt to enter a city if nothing else to show
            if (weatherData == null && !isLoading && errorMessage == null)
              const Center(
                child: Text('Enter a city',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
          ],
        ),
      ),
    );
  }
}
