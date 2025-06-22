import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import '../../color.dart';

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
  Duration? _duration;
  Duration? _position;
  var _progress = 0.0;
  var _onUpdateControllerTime;
  bool _disposed = false;
  String convertTwo(int value) => value < 10 ? "0$value" : "$value";


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
        _controller.addListener(_onControllerUpdate);
      });
  }


  @override
  void dispose() {
    _disposed = true;
    _controller.removeListener(_onControllerUpdate);
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
                  _controlView(context),
                  // VideoProgressIndicator(
                  //   _controller,
                  //   allowScrubbing: true,
                  //   colors: VideoProgressColors(
                  //     playedColor: Colors.purple,
                  //     backgroundColor: Colors.purple.shade100,
                  //     bufferedColor: Colors.purple.shade200,
                  //   ),
                  // ),

                ],
              ),
            ),

            const Spacer(),

            // Bottom Status (optional volume or subtitle buttons)
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 24.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: const [
            //       Icon(Icons.volume_up_outlined),
            //       Text("11:59"),
            //     ],
            //   ),
            // )
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

  Widget _controlView(BuildContext context) {
    final duration = _duration?.inSeconds ?? 0;
    final position = _position?.inSeconds ?? 0;
    final currentFormatted = _formatDuration(Duration(seconds: position));
    final totalFormatted = _formatDuration(Duration(seconds: duration));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
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
                      setState(() {
                        final newPosition = Duration(
                          milliseconds: (_controller.value.duration.inMilliseconds * (value / 100)).round(),
                        );
                        _controller.seekTo(newPosition);
                      });
                    },
                    onChangeStart: (_) => _controller.pause(),
                    onChangeEnd: (value) {
                      final duration = _controller.value.duration;
                      if (duration != null) {
                        final newValue = value.clamp(0, 100) * 0.01;
                        final millis = (duration.inMilliseconds * newValue).toInt();
                        _controller.seekTo(Duration(milliseconds: millis));
                        _controller.play();
                      }
                    },
                  ),
                ),
              ),
              Text(
                totalFormatted,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildControlButtons(),
      ],
    );
  }

  Widget _buildControlButtons() {
    final noMute = (_controller.value.volume > 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            noMute ? Icons.volume_up : Icons.volume_off,
            color: Colors.black87,
          ),
          onPressed: () {
            _controller.setVolume(noMute ? 0 : 1.0);
            setState(() {});
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause_circle : Icons.play_circle,
            size: 40,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            setState(() => _isPlaying = !_isPlaying);
            _isPlaying ? _controller.play() : _controller.pause();
          },
        ),
      ],
    );
  }



  void _onControllerUpdate() {
    if (_disposed) return;
    if (!_controller.value.isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    setState(() {
      _position = position;
      _duration = duration;
      _progress = (duration.inMilliseconds == 0)
          ? 0
          : position.inMilliseconds / duration.inMilliseconds;
      _isPlaying = _controller.value.isPlaying;
    });
  }

}


