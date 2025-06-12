import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Get.back();
                  },
                      icon:const Icon(Icons.arrow_back_ios_new_rounded) ),
                  const Text(
                    'Player',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.info_outline_rounded),
                ],
              ),
            ),

            // Video Player with rounded corners
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_controller),
                      _buildControls(),
                    ],
                  ),
                )
                    : const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),

            // Title and Subtext
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Justin89",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.favorite, color: Colors.redAccent),
                      SizedBox(width: 4),
                      Text("2.3k"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Video Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.purple,
                      backgroundColor: Colors.purple.shade100,
                      bufferedColor: Colors.purple.shade200,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_controller.value.position)),
                      Text(_formatDuration(_controller.value.duration)),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Status (optional volume or subtitle buttons)
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.volume_up_outlined),
                  Text("11:59"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPlaying ? _controller.pause() : _controller.play();
          _isPlaying = !_isPlaying;
        });
      },
      child: Icon(
        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
        color: Colors.white,
        size: 64,
        shadows: const [
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            color: Colors.black45,
          )
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
