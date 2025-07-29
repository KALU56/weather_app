import 'package:flutter/material.dart';
import 'package:weather_app/core/assets.dart';
import 'package:weather_app/screens/onbording.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 168, 236, 248),
      body: Center(
        
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            
             Container(
              width: 100,
              height: 100,
          
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.weather),
                  
                 
                ),
              ),
            ),
            
             GestureDetector(
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Onbording()),
                );
                
              },
            child:Text('Weather app',style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color:const Color.fromARGB(255, 80, 224, 250)
            ),)
             ),

          ],




        ),
      ),
    );
  }
}