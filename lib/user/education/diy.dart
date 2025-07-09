import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/user/education/youtubePlay.dart';
import 'package:video_player/video_player.dart';
import '../../color.dart';
import 'diyVideo.dart';

class DiyVideo extends StatefulWidget {
  const DiyVideo({super.key});

  @override
  State<DiyVideo> createState() => _DiyVideoState();
}

class _DiyVideoState extends State<DiyVideo> {
  bool _isYouTubeLink(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  List videoInfo = [];
  TextEditingController _searchController = TextEditingController();
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();
    _loadVideoData();
  }

  Future<void> _loadVideoData() async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json");
    setState(() {
      videoInfo = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: button,
        appBar: AppBar(title: const Text("DIY Video")),
        body: Column(
          children: [
            _buildInitialHeader(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _buildHeaderRow(),
                    Expanded(child: _buildVideoList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialHeader() {
    return Container(
      width: double.infinity,
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "DIY Video Guide",
            style: TextStyle(
                fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.recycling, size: 28, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Learn to create fun and useful items using recyclable materials. "
                      "Eco-friendly, creative, and easy to do at home!",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<dynamic> _filteredVideoInfo() {
    if (_searchKeyword.isEmpty) {
      return videoInfo;
    } else {
      return videoInfo.where((video) {
        final title = (video['title'] ?? '').toString().toLowerCase();
        final author = (video['author'] ?? '').toString().toLowerCase();
        return title.contains(_searchKeyword) || author.contains(_searchKeyword);
      }).toList();
    }
  }


  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "DIY video",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // light grey background
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search videos...",
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value.trim().toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Total Videos: ${_filteredVideoInfo().length}",
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildVideoList() {
    final filteredList = _filteredVideoInfo();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      itemCount: filteredList.length,
      itemBuilder: (_, index) {
        final video = filteredList[index];
        return GestureDetector(
          onTap: () {
            final String videoUrl = video["videoUrl"];
            final String title = video["title"] ?? "";
            final String description = video["description"] ?? "";
            final String author = video["author"] ?? "";

            if (_isYouTubeLink(videoUrl)) {
              Get.to(() => YouTubePlayerScreen(
                videoUrl: videoUrl,
                title: title,
                description: description,
                author: author,
              ));
            } else {
              Get.to(() => VideoPlayerScreen(
                videoUrl: videoUrl,
                title: title,
                description: description,
                author: author,
              ));
            }
          },
          child: _buildVideoCard(filteredList, index),
        );
      },
    );
  }



  Widget _buildVideoCard(List list, int index) {
    final video = list[index];
    return Container(
      height: 135,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(video["thumbnail"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video["title"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video["time"],
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video["author"] ?? "",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500),
                    ),

                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDottedLine(),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 20,
          decoration: BoxDecoration(
              color: const Color(0xFFeaeefc),
              borderRadius: BorderRadius.circular(10)),
        ),
        Row(
          children: List.generate(
            70,
                (i) => Container(
              width: 3,
              height: 1,
              color: i.isEven ? Colors.grey.shade500 : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
