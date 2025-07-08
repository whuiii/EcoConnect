import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../color.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("News"),
          backgroundColor: green3,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                NewsPane(
                  title: 'How and Where to Recycle Your Old Computers and Printers',
                  image: 'assets/images/news1.jpg',
                  date: '30 June 2025',
                  url: 'https://www.cnet.com/tech/computing/how-and-where-to-recycle-your-old-computers-and-printers/',
                ),
                const SizedBox(height: 20),
                NewsPane(
                  title: 'Rural recycling on the rise',
                  image: 'assets/images/news2.png',
                  date: '06 July 2025',
                  url: 'https://www.sunlive.co.nz/news/368387-rural-recycling-on-the-rise.html',
                ),
                const SizedBox(height: 20),
                NewsPane(
                  title: 'How to recycle your beauty empties',
                  image: 'assets/images/news3.jpg',
                  date: '02 May 2025',
                  url: 'https://www.russh.com/how-to-recycle-your-beauty-empties/',
                ),
              ],
            ),
          ),
        )

      ),
    );
  }
}

class NewsPane extends StatelessWidget {
  final String title;
  final String image;
  final String date;
  final String url;

  const NewsPane({
    super.key,
    required this.title,
    required this.image,
    required this.date,
    required this.url,
  });

  //Function to launch URL
  Future<void> _launchURL(BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the news link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(context), // ✅ Launch URL on tap
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
