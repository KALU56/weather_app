import 'package:flutter/material.dart';
import 'package:weather_app/core/assets.dart';
import 'package:weather_app/screens/home.dart';

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  State<Onbording> createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> onboardingData = [
     {
      'icon': Icons.wb_sunny_rounded,
      'title': 'Live Weather',
      'desc': 'Real-time updates for current weather conditions.',
    },
    {
      'icon': Icons.cloud_outlined,
      'title': 'Accurate Forecasts',
      'desc': 'Hourly and daily predictions to plan ahead.',
    },
    {
      'icon': Icons.location_city,
      'title': 'Multiple Cities',
      'desc': 'Save and switch between your favorite locations.',
    },
    {
      'icon': Icons.settings,
      'title': 'Customization',
      'desc': 'Choose between °C/°F and light/dark themes.',
    },
  ];

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  void _skip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.weather),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: const Text(
                  'Weather',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color:  Color.fromARGB(255, 99, 203, 245),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final item = onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        size: 120,
                        color: const Color.fromARGB(255, 99, 203, 245),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _currentIndex == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? const Color.fromARGB(255, 99, 203, 245)
                      : const Color.fromARGB(255, 128, 200, 241),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

            
           Column(
            children: [
              Text(
                onboardingData[_currentIndex]['title']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                onboardingData[_currentIndex]['desc']!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 80, 224, 250)
                // minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _nextPage,
              child: Text(
                _currentIndex == onboardingData.length - 1 ? 'Finish' : 'Next',
              ),
            ),
          ),

          TextButton(
            onPressed: _skip,

            child: Text(
              _currentIndex == onboardingData.length - 1 ? 'Home' : 'Skip',
              style: TextStyle(color: const Color.fromARGB(255, 117, 226, 245),
            ),
          ),
        
          ),
            SizedBox(height: 16),

        ],
      ),
    );
  }
}
