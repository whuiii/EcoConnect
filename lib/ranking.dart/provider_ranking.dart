//Platform connecting cubit and UI

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigate/ranking.dart/cubit_ranking.dart';
import 'package:navigate/ranking.dart/page_ranking.dart';

class RankingPage extends StatelessWidget {
  final String category;
  const RankingPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    //Bloc Provider
    return BlocProvider(
      create: (context) => RankingCubit(),
      child: Ranking(category: category),
    );
  }
}
