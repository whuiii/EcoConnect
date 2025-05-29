import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigate/color.dart';
import 'package:navigate/ranking.dart/cubit_ranking.dart';
import 'package:navigate/ranking.dart/row_ranking.dart';

class Ranking extends StatelessWidget {
  final String category; // e.g., 'point', 'weight', 'frequency'
  const Ranking({super.key, required this.category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(top: 8.0),
        // You can remove fixed height here; let it fill the space naturally
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child:
            BlocBuilder<RankingCubit, Map<String, List<Map<String, String>>>>(
          builder: (context, rankings) {
            final selectedList = rankings[category] ?? [];

            return ListView.builder(
              itemCount: selectedList.length,
              itemBuilder: (context, index) {
                return RankingList(
                  category: category,
                  index: (index + 1).toString(),
                  taskName: selectedList[index]['name']!,
                  value: selectedList[index]['value']!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
