import 'package:flutter/material.dart';
import 'package:navigate/color.dart';

class FlashMessage extends StatelessWidget {
  const FlashMessage({super.key});

  @override
  Widget build(BuildContext context) {
    // Show SnackBar after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                height: 90,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Congrats!",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          Text(
                            "All steps completed",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(20)),
                  child: Image.asset(
                    "assets/images/chikawa.png",
                    height: 48,
                    width: 40,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    });

    // Return empty container to occupy widget space
    return const SizedBox.shrink();
  }
}
