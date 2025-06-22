import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigate/user/ranking.dart/cubit_ranking.dart';
import 'package:navigate/user/ranking.dart/top3_ranking.dart';

class Top3RankingSection extends StatelessWidget {
  final String category;
  const Top3RankingSection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RankingCubit, Map<String, List<Map<String, dynamic>>>>(
      builder: (context, rankings) {
        final rankingList = rankings[category] ?? [];

        final first = rankingList.isNotEmpty ? rankingList[0] : null;
        final second = rankingList.length > 1 ? rankingList[1] : null;
        final third = rankingList.length > 2 ? rankingList[2] : null;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Top3Ranking(
              size: 70,
              rank: 2,
              imagePath: "assets/images/ava.jpg",
              name: second?['name'] ?? 'N/A',
              colored: const Color.fromARGB(255, 246, 235, 235),
            ),
            Top3Ranking(
              size: 100,
              rank: 1,
              imagePath: "assets/images/ava.jpg",
              name: first?['name'] ?? 'N/A',
              colored: Colors.yellow,
            ),
            Top3Ranking(
              size: 70,
              rank: 3,
              imagePath: "assets/images/ava.jpg",
              name: third?['name'] ?? 'N/A',
              colored: Colors.orangeAccent,
            ),
          ],
        );
      },
    );
  }
}
