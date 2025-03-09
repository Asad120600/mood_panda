import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String buttonText;
  final VoidCallback onTap;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate dynamic font sizes and padding
    final double fontSize =
        screenWidth * 0.04; // Font size based on screen width
    final double buttonFontSize = screenWidth * 0.035; // Button text font size
    final double iconSize =
        screenWidth * 0.1; // Icon size based on screen width
    final double padding = screenWidth * 0.03; // Padding based on screen width

    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.white),
            SizedBox(height: screenHeight * 0.01), // Vertical spacing
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Limits the text to two lines.
                overflow: TextOverflow.ellipsis, // Handles overflow gracefully.
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Vertical spacing
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, // Button padding
                  vertical: screenHeight * 0.015,
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize:
                      buttonFontSize, // Responsive font size for button text
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
