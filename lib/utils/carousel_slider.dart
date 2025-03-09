import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatelessWidget {
  final List<String> imagePaths;  // List of image paths to be displayed
  final double height;            // Height for the slider
  final double width;             // Width for the slider
  final Duration autoPlayInterval; // Auto play interval for the slider

  const CarouselSliderWidget({
    Key? key,
    required this.imagePaths,
    required this.height,
    required this.width,
    required this.autoPlayInterval,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imagePaths.map((imagePath) {
        return Builder(
          builder: (context) {
            return Container(
              width: width,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Mood Panda!',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: height, // Custom height
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: autoPlayInterval, // Custom interval
      ),
    );
  }
}
