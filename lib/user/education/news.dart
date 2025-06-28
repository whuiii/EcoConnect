import 'package:flutter/material.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            NewsPane(
              title: 'How recycle can help the environment',
              image: 'assets/images/SortWaste.png',
              date: '18 March 2024',
              onTap: () {
                print("Tap on the news pane");
              },
            ),
            SizedBox(height: 10),
            NewsPane(
              title: 'This is News',
              image: 'assets/images/SortWaste.png',
              date: '18 March 2024',
              onTap: () {
                print("Tap on the news pane");
              },
            ),

          ],
        ),
      ),
    );
  }
}

class NewsPane extends StatelessWidget {
  final String title;
  final String image;
  final String date;
  final VoidCallback onTap;

  const NewsPane({
    super.key,
    required this.title,
    required this.image,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.black12,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE CONTAINER with rounded top corners only
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

            // TEXT CONTAINER
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 16, left: 12, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],

        ),
      ),
    );

  }
}
