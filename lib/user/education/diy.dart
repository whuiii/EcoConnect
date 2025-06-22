import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../color.dart';
import 'diyVideo.dart';
//import 'video_player_screen.dart'; // New file for full-screen video

class DiyVideo extends StatefulWidget {
  const DiyVideo({super.key});

  @override
  State<DiyVideo> createState() => _DiyVideoState();
}

class _DiyVideoState extends State<DiyVideo> {
  List videoInfo = [];

  @override
  void initState() {
    super.initState();
    _loadVideoData();
  }

  Future<void> _loadVideoData() async {
    final jsonString = await DefaultAssetBundle.of(context).loadString("json/videoinfo.json");
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
      height: 300,
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
            style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              _buildInfoBox("Avg Time: 5-10 mins"),
              const SizedBox(width: 20),
              _buildInfoBox("Eco-friendly", width: 140),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String text, {double width = 120}) {
    return Container(
      width: width,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, size: 18, color: Colors.black87),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text("DIY video",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          const Spacer(),
          const Icon(Icons.loop, size: 30, color: Colors.grey),
          const SizedBox(width: 10),
          Text("${videoInfo.length} videos", style: const TextStyle(fontSize: 15, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      itemCount: videoInfo.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            Get.to(() => VideoPlayerScreen(videoUrl: videoInfo[index]["videoUrl"], title: videoInfo[index]["title"],));
          },
          child: _buildVideoCard(index),
        );
      },
    );
  }

  Widget _buildVideoCard(int index) {
    final video = videoInfo[index];
    return Container(
      height: 135,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: AssetImage(video["thumbnail"]), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(video["time"], style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
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
          decoration: BoxDecoration(color: const Color(0xFFeaeefc), borderRadius: BorderRadius.circular(10)),
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

// import 'dart:convert';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
//
// import '../color.dart';
//
// class DiyVideo extends StatefulWidget {
//   const DiyVideo({super.key});
//
//   @override
//   State<DiyVideo> createState() => _DiyVideoState();
// }
//
// class _DiyVideoState extends State<DiyVideo> {
//   List videoInfo = [];
//   bool _playArea = false;
//   bool _isPlaying = false;
//   bool _disposed = false;
//   int _isPlayingIndex = -1;
//   VideoPlayerController? _controller;
//
//   Duration? _duration;
//   Duration? _position;
//   var _progress = 0.0;
//   var _onUpdateControllerTime;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadVideoData();
//   }
//
//   Future<void> _loadVideoData() async {
//     final jsonString = await DefaultAssetBundle.of(context).loadString("json/videoinfo.json");
//     setState(() {
//       videoInfo = json.decode(jsonString);
//     });
//   }
//
//   @override
//   void dispose() {
//     _disposed = true;
//     _controller?.pause();
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   String convertTwo(int value) => value < 10 ? "0$value" : "$value";
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: button,
//         appBar: AppBar(title: const Text("DIY Video")),
//         body: Column(
//           children: [
//             _playArea ? _buildPlayArea() : _buildInitialHeader(),
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.only(bottom: 0,),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 30),
//                     _buildHeaderRow(),
//                     Expanded(child: _buildVideoList()),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInitialHeader() {
//     return Container(
//       width: double.infinity,
//       height: 300,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//       decoration: const BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 10,
//             spreadRadius: 2,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "DIY Video Guide",
//             style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: const [
//               Icon(Icons.recycling, size: 28, color: Colors.white),
//               SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   "Learn to create fun and useful items using recyclable materials. "
//                       "Eco-friendly, creative, and easy to do at home!",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 30),
//           Row(
//             children: [
//               _buildInfoBox("Avg Time: 5-10 mins"),
//               const SizedBox(width: 20),
//               _buildInfoBox("Eco-friendly", width: 140),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoBox(String text, {double width = 120}) {
//     return Container(
//       width: width,
//       height: 40,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 5,
//             spreadRadius: 1,
//             offset: const Offset(2, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.timer, size: 18, color: Colors.black87),
//           const SizedBox(width: 5),
//           Flexible(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 13, color: Colors.black87),
//               overflow: TextOverflow.ellipsis,
//               softWrap: false,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlayArea() {
//     return Column(
//       children: [
//         Container(
//           height: 80,
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: () => setState(() => _playArea = false),
//                 child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 5, bottom: 20), // Move it up 20 pixels
//           child: Column(
//             children: [
//               _playView(context),
//               _controlView(context),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHeaderRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           const Text("DIY video",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
//           const Spacer(),
//           const Icon(Icons.loop, size: 30, color: Colors.grey),
//           const SizedBox(width: 10),
//           Text("${videoInfo.length} videos", style: const TextStyle(fontSize: 15, color: Colors.grey)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVideoList() {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
//       itemCount: videoInfo.length,
//       itemBuilder: (_, index) {
//         return GestureDetector(
//           onTap: () {
//             _onTapVideo(index);
//             setState(() => _playArea = true);
//           },
//           child: _buildVideoCard(index),
//         );
//       },
//     );
//   }
//
//   Widget _buildVideoCard(int index) {
//     final video = videoInfo[index];
//     return Container(
//       height: 135,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 80,
//                 height: 90,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   image: DecorationImage(image: AssetImage(video["thumbnail"]), fit: BoxFit.cover),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(video["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Text(video["time"], style: TextStyle(color: Colors.grey.shade500)),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           _buildDottedLine(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDottedLine() {
//     return Row(
//       children: [
//         Container(
//           width: 80,
//           height: 20,
//           decoration: BoxDecoration(color: const Color(0xFFeaeefc), borderRadius: BorderRadius.circular(10)),
//         ),
//         Row(
//           children: List.generate(
//             70,
//                 (i) => Container(
//               width: 3,
//               height: 1,
//               color: i.isEven ? Colors.grey.shade500 : Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _playView(BuildContext context) {
//     if (_controller != null && _controller!.value.isInitialized) {
//       return AspectRatio(aspectRatio: 16 / 9, child: VideoPlayer(_controller!));
//     } else {
//       return AspectRatio(
//         aspectRatio: 16 / 9,
//         child: const Center(child: Text("Loading...", style: TextStyle(fontSize: 20, color: Colors.white60))),
//       );
//     }
//   }
//
//   Widget _controlView(BuildContext context) {
//     final noMute = (_controller?.value.volume ?? 0) > 0;
//     final duration = _duration?.inSeconds ?? 0;
//     final head = _position?.inSeconds ?? 0;
//     final remained = max(0, duration - head);
//     final mins = convertTwo(remained ~/ 60);
//     final secs = convertTwo(remained % 60);
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SliderTheme(
//           data: SliderTheme.of(context).copyWith(
//             activeTrackColor: Colors.red.shade700,
//             inactiveTrackColor: Colors.red.shade100,
//             thumbColor: Colors.redAccent,
//             overlayColor: Colors.red.withAlpha(32),
//             trackShape: const RoundedRectSliderTrackShape(),
//             thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
//             overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
//             valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
//             valueIndicatorColor: Colors.redAccent,
//             valueIndicatorTextStyle: const TextStyle(color: Colors.white),
//           ),
//           child: Slider(
//             value: max(0, min(_progress * 100, 100)),
//             min: 0,
//             max: 100,
//             divisions: 100,
//             label: _position?.toString().split(".")[0],
//             onChanged: (value) => setState(() => _progress = value * 0.01),
//             onChangeStart: (_) => _controller?.pause(),
//             onChangeEnd: (value) {
//               final duration = _controller?.value.duration;
//               if (duration != null) {
//                 final newValue = max(0, min(value, 99)) * 0.01;
//                 final millis = (duration.inMilliseconds * newValue).toInt();
//                 _controller?.seekTo(Duration(milliseconds: millis));
//                 _controller?.play();
//               }
//             },
//           ),
//         ),
//         _buildControlButtons(noMute, mins, secs),
//       ],
//     );
//   }
//
//   Widget _buildControlButtons(bool noMute, String mins, String secs) {
//     return Container(
//       height: 40,
//       width: double.infinity,
//       color: button,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: Icon(noMute ? Icons.volume_up : Icons.volume_off, color: Colors.white),
//             onPressed: () {
//               _controller?.setVolume(noMute ? 0 : 1.0);
//               setState(() {});
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.fast_rewind, size: 36, color: Colors.white),
//             onPressed: () {
//               final index = _isPlayingIndex - 1;
//               if (index >= 0) {
//                 _onTapVideo(index);
//               } else {
//                 _showSnackbar("No videos ahead!");
//               }
//             },
//           ),
//           IconButton(
//             icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 36, color: Colors.white),
//             onPressed: () {
//               setState(() => _isPlaying = !_isPlaying);
//               _isPlaying ? _controller?.play() : _controller?.pause();
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.fast_forward, size: 36, color: Colors.white),
//             onPressed: () {
//               final index = _isPlayingIndex + 1;
//               if (index < videoInfo.length) {
//                 _onTapVideo(index);
//               } else {
//                 _showSnackbar("No more video in the list");
//               }
//             },
//           ),
//           Text("$mins:$secs", style: const TextStyle(color: Colors.white)),
//         ],
//       ),
//     );
//   }
//
//   void _showSnackbar(String message) {
//     Get.snackbar("Video List", "",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: button,
//       colorText: Colors.white,
//       icon: const Icon(Icons.face, size: 30, color: Colors.white),
//       messageText: Text(message, style: const TextStyle(fontSize: 20, color: Colors.white)),
//     );
//   }
//
//   void _onTapVideo(int index) {
//     final controller = VideoPlayerController.network(videoInfo[index]["videoUrl"]);
//     final old = _controller;
//     _controller = controller;
//
//     old?.removeListener(_onControllerUpdate);
//     old?.pause();
//
//     setState(() {});
//
//     controller.initialize().then((_) {
//       old?.dispose();
//       _isPlayingIndex = index;
//       controller.addListener(_onControllerUpdate);
//       controller.play();
//       setState(() {});
//     });
//   }
//
//   void _onControllerUpdate() async {
//     if (_disposed) return;
//
//     final now = DateTime.now().microsecondsSinceEpoch;
//     if (_onUpdateControllerTime != null && _onUpdateControllerTime > now) return;
//
//     _onUpdateControllerTime = now + 500;
//
//     final controller = _controller;
//     if (controller == null || !controller.value.isInitialized) return;
//
//     _duration ??= controller.value.duration;
//     final position = await controller.position;
//     _position = position;
//
//     if (controller.value.isPlaying && !_disposed) {
//       setState(() {
//         _progress = position!.inMilliseconds / _duration!.inMilliseconds;
//       });
//     }
//
//     _isPlaying = controller.value.isPlaying;
//   }
// }
