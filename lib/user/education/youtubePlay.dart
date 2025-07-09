import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final String author;
  const YouTubePlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.author,
  });

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  bool _isLiked = false;
  int _likesCount = 2300;

  late YoutubePlayerController _youtubeController;
  bool _isMuted = false;

  Duration _videoPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;
  double _progress = 0.0;

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
    )..addListener(() {
      final metaData = _youtubeController.metadata;
      final position = _youtubeController.value.position;
      final duration = metaData.duration;

      setState(() {
        _videoPosition = position;
        _videoDuration = duration;
        _progress = duration.inMilliseconds == 0
            ? 0
            : position.inMilliseconds / duration.inMilliseconds;
      });
    });
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }


  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Report Video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Inappropriate Content'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Reported as Inappropriate Content');
                },
              ),
              ListTile(
                leading: const Icon(Icons.copyright),
                title: const Text('Copyright Issue'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Reported as Copyright Issue');
                },
              ),
              ListTile(
                leading: const Icon(Icons.error_outline),
                title: const Text('Spam or Misleading'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Reported as Spam');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
                    'DIY Video',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flag_outlined),
                    onPressed: () {
                      _showReportDialog();
                    },
                  ),
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Author: ${widget.author}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.redAccent : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked;
                            if (_isLiked) {
                              _likesCount++;
                            } else {
                              _likesCount--;
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${_likesCount ~/ 1000}.${_likesCount % 1000 ~/ 100}k",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Progress bar + description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressBar(),

                  const SizedBox(height: 8),
                  _buildControlButtons(),
                  // Inside the Padding -> Column (after _buildControlButtons)
                  const SizedBox(height: 20),

                  const Divider(
                    color: Colors.black12,
                    thickness: 1,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurple.shade50),
                    ),
                    child: Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final currentFormatted = _formatDuration(_videoPosition);
    final totalFormatted = _formatDuration(_videoDuration);

    return Row(
      children: [
        Text(
          currentFormatted,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: Colors.deepPurple,
              inactiveTrackColor: Colors.deepPurple.shade100,
              thumbColor: Colors.deepPurpleAccent,
              overlayColor: Colors.deepPurple.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            ),
            child: Slider(
              value: _progress * 100,
              min: 0,
              max: 100,
              onChanged: (value) {
                final newPosition = Duration(
                  milliseconds:
                  (_videoDuration.inMilliseconds * (value / 100)).round(),
                );
                _youtubeController.seekTo(newPosition);
              },
            ),
          ),
        ),
        Text(
          totalFormatted,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
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

