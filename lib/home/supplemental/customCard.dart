import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String routeName;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;

  CustomCard({
    required this.title,
    required this.routeName,
    required this.imagePath,
    this.imageWidth = 60.0,
    this.imageHeight = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Aggiunge un margine esterno di 10 unità
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(routeName);
        },
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(4.0), // Margine interno
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.orange, // Utilizzo del colore dal tema
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
            color: Theme.of(context).colorScheme.surface, // Utilizzo del colore di superficie dal tema
          ),
          child: Column(
            children: [
              Container(
                width: imageWidth,
                height: imageHeight,
                child: Image.asset(imagePath),
              ),
              SizedBox(height: 4), // Spazio tra l'immagine e il testo
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, // Utilizzo del colore dal tema
                  fontSize: 14,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
