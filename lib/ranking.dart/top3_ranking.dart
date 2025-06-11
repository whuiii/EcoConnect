import 'package:flutter/material.dart';

class Top3Ranking extends StatelessWidget {
  final double size;
  final int rank;
  final String imagePath;
  final String name;
  final Color colored;

  const Top3Ranking({
    Key? key,
    required this.size,
    required this.rank,
    required this.imagePath,
    required this.colored,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double badgeSize = 30;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 50),
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: colored,
              width: 5,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Crown if rank == 1
        if (rank == 1)
          Positioned(
            top: -20,
            child: Image.asset(
              "assets/images/crown.png", // Make sure you have this asset in your project
              width: size * 0.5,
              height: size * 0.5,
            ),
          ),

        Positioned(
          bottom: 38,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: colored,
                width: 5,
              ),
            ),
            child: Text(
              rank.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: badgeSize * 0.5,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 17,
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: badgeSize * 0.5,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
