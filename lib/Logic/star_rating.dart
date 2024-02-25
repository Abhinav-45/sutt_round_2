import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double imdbRating;

  const StarRating({super.key, required this.imdbRating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 5; i++)
          Row(
            children: [
              Icon(
                i < (imdbRating / 2).round() ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),

            ],
          ),
      ],
    );
  }
}
