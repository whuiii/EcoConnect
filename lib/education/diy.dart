import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import '../color.dart';

class DiyVideo extends StatefulWidget {
  const DiyVideo({super.key});

  @override
  State<DiyVideo> createState() => _DiyVideoState();
}

class _DiyVideoState extends State<DiyVideo> {

  List videoInfo = [];
  bool _playArea = false;
  bool _isPlaying = false;
  bool _disposed = false;
  int _isPlayingIndex = -1;

  VideoPlayerController? _controller;
  _initData() async {
    await DefaultAssetBundle.of(context).loadString("json/videoinfo.json").then((value){
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState(){
    super.initState();
    _initData();
  }

  @override
  void dispose(){
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea
      (child: Scaffold(
      //backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("DIY Video"),
      ),
      body:  Container(
        decoration: _playArea == false? BoxDecoration(
          color: button,
          ):BoxDecoration(
          color: button,
        ),
        child: Column(
          children: [
            _playArea == false? Container(
              width: double.infinity,
              height: 250,
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Icon(Icons.info_outline,size: 20,
                      color: Colors.grey,),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Text("DIY Video",
                    style: TextStyle(fontSize: 25,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5,),
                  Text("Do it Yourself",
                    style: TextStyle(fontSize: 25,
                        color: Colors.white),
                  ),
                  SizedBox(height: 50,),
                  Row(
                    children: [
                      Container(
                        width: 90,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer,size: 20,
                            color: Colors.black,),
                            SizedBox(width: 5,),
                            Text("Time",style: TextStyle(
                              fontSize: 16,
                              color: Colors.black),),
                          ],

                        ),

                      ),
                      SizedBox(width: 20,),
                      Container(
                        width: 250,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer,size: 20,
                              color: Colors.black,),
                            SizedBox(width: 5,),
                            Text("Time",style: TextStyle(
                                fontSize: 16,
                                color: Colors.black),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ):Container(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    padding: const EdgeInsets.only(top:50, left:30, right:30),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            debugPrint("tapped");


                        },
                          child: Icon(Icons.arrow_back,
                            size: 20,
                          color: Colors.black),
                        ),
                        Icon(Icons.info_outline,
                        size: 20,
                            color: Colors.black,),
                      ],
                    ),
                  ),
                  _playView(context),
                  _controlView(context),
                ],
              ),
              // width: 300,
              // height: 300,
              // color: Colors.red,
            ),
            Expanded(child: Container(
              //padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70)),
              ),
              child: Column(
                children:[
                  SizedBox(height:30,),
                  Row(
                    children:[
                      SizedBox(height: 20,),

                      Text("    DIY video",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      Expanded(child: Container()),
                      Row(
                        children: [
                          Icon(Icons.loop,size: 30, color: Colors.grey,),
                          SizedBox(width: 10,),
                          Text("4 videos",style:
                          TextStyle(fontSize: 15,color: Colors.grey),)
                        ],
                      ),
                      SizedBox(width: 20,),
                    ]
                  ),
                  Expanded(child: _listView()),

                ]
              ),
            ))

          ],
        ),
        ),
      ),
    );
  }
  String convertTwo(int value){
    return value <10 ? "0$value" : "$value";
  }

  Widget _controlView(BuildContext context){
    final noMute = (_controller?.value?.volume??0) >0;
    final duration = _duration?.inSeconds ??0;
    final head = _position?.inSeconds ??0;
    final remained = max(0, duration - head);
    final mins = convertTwo(remained ~/60.0);
    final secs = convertTwo(remained %60);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
    SliderTheme(data: SliderTheme.of(context).copyWith(
      activeTrackColor: Colors.red.shade700,
      inactiveTrackColor: Colors.red.shade100,
      trackShape: RoundedRectSliderTrackShape(),
      trackHeight: 2.0,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
      thumbColor: Colors.redAccent,
      overlayColor: Colors.red.withAlpha(32),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      tickMarkShape: RoundSliderTickMarkShape(),
      activeTickMarkColor: Colors.red.shade700,
      inactiveTickMarkColor: Colors.red.shade100,
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: Colors.redAccent,
      valueIndicatorTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    child: Slider(
          value: max(0, min(_progress * 100, 100)),
    min: 0,
    max:100,
    divisions: 100,
    label: _position?.toString().split(".")[0],
    onChanged: (value){
            setState(() {
              _progress = value * 0.01;
            });
    },
    onChangeStart: (value){
            _controller?.pause();
    },
    onChangeEnd: (value){
            final duration = _controller?.value?.duration;
            if(duration != null){
              var newValue = max(0, min(value, 99)) * 0.01;
              var millis = (duration.inMilliseconds * newValue).toInt();
              _controller?.seekTo(Duration(milliseconds: millis));
              _controller?.play();
    }
    },
        ),
    ),
      Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom:5,),
      color: button,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.0, 0.0),
                        blurRadius: 4.0,
                        color: Color.fromARGB(50, 0, 0, 0),
                      ),
                    ]
                ),
                child: Icon(
                  noMute?Icons.volume_up: Icons.volume_off
                  ,color: Colors.white,),
              ),

            ),
            onTap: (){
              if(noMute){
                _controller?.setVolume(0);
              }else{
                _controller?.setVolume(1.0);
              }
              setState(() {

              });
            },
          ),
          IconButton(onPressed: ()async{
            final index = _isPlayingIndex - 1;
            if(index >= 0 && videoInfo.length >=0){
              _onTapVideo(index);
            }else{
              Get.snackbar("Video List", "",
                snackPosition: SnackPosition.BOTTOM,
                icon: Icon(Icons.face,size: 30,color: Colors.white,
                ),
                backgroundColor: button,
                colorText: Colors.white,
                messageText: Text("No videos ahead!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              );

            }
          }, icon: Icon(Icons.fast_rewind,
            size: 36,
            color: Colors.white,)
            ,),
          IconButton(onPressed: ()async{
            if(_isPlaying){
              setState(() {
                _isPlaying = false;
              });
              _controller?.pause();
            }else{
              setState(() {
                _isPlaying = true;
              });
              _controller?.play();
            }
          }, icon: Icon(_isPlaying?Icons.pause: Icons.play_arrow,
            size: 36,
            color: Colors.white,)
            ,),
          IconButton(onPressed: ()async{
            final index = _isPlayingIndex + 1;
            if(index <= videoInfo.length - 1){
              _onTapVideo(index);
            }else{
              Get.snackbar("Video List", "",
                snackPosition: SnackPosition.BOTTOM,
                icon: Icon(Icons.face,size: 30,color: Colors.white,
                ),
                backgroundColor: button,
                colorText: Colors.white,
                messageText: Text("No more video in the list",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              );
            }

          }, icon: Icon(Icons.fast_forward,
            size: 36,
            color: Colors.white,)
            ,),
          Text("$mins:$secs",
          style: TextStyle(
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0.0, 1.0),
                blurRadius: 4.0,
                color: Color.fromARGB(150, 0, 0, 0),

              )
            ]
          ),),
        ],
      ),
    )
      ],
    );

  }

  Widget _playView(BuildContext context){
    final controller = _controller;
    if(controller != null && controller.value.isInitialized){
      return AspectRatio(
        aspectRatio: 16/9,
        child: VideoPlayer(controller),
      );
    }else{
      return AspectRatio(
        aspectRatio: 16/9,
          child: Text("Loading...", style:
          TextStyle(fontSize: 20, color: Colors.white60)),);

    }


  }

var _onUpdateControllerTime;
  Duration? _duration;
  Duration? _position;
  var _progress = 0.0;
  void _onControllerUpdate() async{
    if(_disposed){

      return;
    }
    _onUpdateControllerTime = 0;
    final now = DateTime.now().microsecondsSinceEpoch;
    if(_onUpdateControllerTime > now){
      return;
    }
    _onUpdateControllerTime = now + 500;
    final controller = _controller;
    if(controller == null){
      debugPrint("controller is null");
      return;
    }
    if(!controller.value.isInitialized){
      debugPrint("controller can not be initialized");
      return;
    }
    if(_duration == null){
      _duration = _controller?.value.duration;
    }
    var duration = _duration;
    if(duration == null)return;
    var position = await controller.position;
    _position = position;

    final playing = controller.value.isPlaying;
    if(playing){
      if (_disposed) return;
      setState(() {

        _progress = position!.inMilliseconds.ceilToDouble()/duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;

  }

  _onTapVideo(int index){
    final controller = VideoPlayerController.network(videoInfo[index]["videoUrl"]);
    final old = _controller;
    // final controller = VideoPlayerController.network(
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    // );
    _controller = controller;
    if(old!=null){
      old.removeListener(_onControllerUpdate);
      old.pause();
    }
    setState(() {

    });
    controller..initialize().then((_){
      old?.dispose();
      _isPlayingIndex = index;
      controller.addListener(_onControllerUpdate);
      controller.play();
      setState(() {


      });
    });
  }

  _listView(){
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        itemCount: videoInfo.length,
        itemBuilder: (_, int index){

          return GestureDetector(
            onTap: (){
              _onTapVideo(index);
              debugPrint(index.toString());
              setState(() {
                if(_playArea == false){
                  _playArea = true;
                }

              });
            },
            child: _buildCard(index),
          ); //need to return a function later
        });
  }
  
  _buildCard(int index){
    return Container(
      height: 135,
      //width: 200,
      //color: Colors.redAccent,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: AssetImage(videoInfo[index]["thumbnail"]
                    ),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start, // Align the text
                children: [
                  Text(
                    videoInfo[index]["title"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

                  ),
                  SizedBox(height: 10,),
                  Padding(padding: EdgeInsets.only(top: 3),
                    child: Text(
                      videoInfo[index]["time"],
                      style: TextStyle(
                        color: Colors.grey.shade500,

                      ),
                    ),),
                ],
              )
            ],
          ),
          SizedBox(height: 18,),
          // dotted line code
          Row(
            children: [
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFFeaeefc),
                  borderRadius: BorderRadius.circular(10),

                ),
              ),
              Row(
                children: [
                  for(int i = 0; i<70; i++)
                    i.isEven?Container(
                      width: 3,
                      height: 1,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(2)
                      ),
                    ):Container(
                      width: 3,
                      height: 1,
                      color: Colors.white,
                    )
                ],
              )
            ],
          )

        ],
      ),
    );
  }
}
