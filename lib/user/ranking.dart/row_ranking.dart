import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/ranking.dart/cubit_ranking.dart';

class RankingList extends StatefulWidget {
  final String index;
  final String taskName;
  final String value;
  final String category;
  final String imageUrl;

  const RankingList(
      {super.key,
      required this.taskName,
      required this.value,
      required this.index,
      required this.category, required this.imageUrl});

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  @override
  Widget build(BuildContext context) {
    return
        //Left Portion Container
        Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8),
          margin: const EdgeInsets.all(10.0),
          height: 60,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: widget.index == '1'
                ? Colors.yellow
                : widget.index == '2'
                    ? const Color.fromARGB(255, 246, 235, 235)
                    : widget.index == '3'
                        ? Colors.orange
                        : widget.category == 'point'
                            ? point_color
                            : widget.category == 'weight'
                                ? weight_color
                                : frequency_color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Text(widget.index, style: TextName),
              //Image
              Container(
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    image: DecorationImage(
  image: widget.imageUrl.isNotEmpty
      ? NetworkImage(widget.imageUrl)
      : const AssetImage("assets/images/ava.jpg") as ImageProvider,
  fit: BoxFit.cover,
),),
                width: 40,
                height: 40,
              ),

              //Text
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.taskName,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),

        //Right Portion
        Container(
          padding: const EdgeInsets.all(5),
          height: 60,
          width: MediaQuery.of(context).size.width * 0.23,
          decoration: BoxDecoration(
            color: widget.index == '1'
                ? Colors.yellow
                : widget.index == '2'
                    ? const Color.fromARGB(255, 246, 235, 235)
                    : widget.index == '3'
                        ? Colors.orange
                        : widget.category == 'point'
                            ? point_color
                            : widget.category == 'weight'
                                ? weight_color
                                : frequency_color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.value}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
