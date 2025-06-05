import 'dart:convert';

import 'package:flutter/material.dart';

import '../color.dart';

class DiyVideo extends StatefulWidget {
  const DiyVideo({super.key});

  @override
  State<DiyVideo> createState() => _DiyVideoState();
}

class _DiyVideoState extends State<DiyVideo> {

  List videoInfo = [];
  bool _playArea = false;
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
  Widget build(BuildContext context) {
    return SafeArea
      (child: Scaffold(
      //backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("DIY Video"),
      ),
      body:  Container(
        decoration: BoxDecoration(
          color: button,
          ),
        child: Column(
          children: [
            _playArea == false? Container(
              width: double.infinity,
              height: 300,
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
                        color: Colors.black),
                  ),
                  SizedBox(height: 5,),
                  Text("Do it Yourself",
                    style: TextStyle(fontSize: 25,
                        color: Colors.black),
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
              width: 300,
              height: 300,
              color: Colors.red,
            ),
            Expanded(child: Container(
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
                      SizedBox(height: 30,),
                      Text("DIY video",
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

  _listView(){
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        itemCount: videoInfo.length,
        itemBuilder: (_, int index){

          return GestureDetector(
            onTap: (){
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
