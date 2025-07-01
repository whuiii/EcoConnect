import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const YouTubePlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _youtubeController;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
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
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Text(
                    'Player',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.info_outline_rounded),
                ],
              ),
            ),

            // YouTube Player with rounded corners
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: YoutubePlayer(
                  controller: _youtubeController,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.deepPurple,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.deepPurple,
                    handleColor: Colors.deepPurpleAccent,
                  ),
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Progress bar is handled by YouTubePlayer itself, no need for custom one
            // But you can add extra controls if you like
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildControlButtons(),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            _isMuted ? Icons.volume_off : Icons.volume_up,
            color: Colors.black87,
          ),
          onPressed: () {
            if (_isMuted) {
              _youtubeController.unMute();
            } else {
              _youtubeController.mute();
            }
            setState(() {
              _isMuted = !_isMuted;
            });
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            _youtubeController.value.isPlaying
                ? Icons.pause_circle
                : Icons.play_circle,
            size: 40,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            setState(() {
              _youtubeController.value.isPlaying
                  ? _youtubeController.pause()
                  : _youtubeController.play();
            });
          },
        ),
      ],
    );
  }

}
