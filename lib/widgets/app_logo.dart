import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  
  const AppLogo({
    Key? key,
    this.size = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.directions_car,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
} 