import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigate/services/user_service.dart';

class RankingCubit extends Cubit<Map<String, List<Map<String, dynamic>>>> {
  RankingCubit()
      : super({
          'point': [],
          'weight': [],
          'frequency': [],
        });

  final UserService _userService = UserService();

  Future<void> fetchRankings() async {
    try {
      List<Map<String, dynamic>> users = await _userService.getAllUsers();

      // 'point'
      List<Map<String, dynamic>> pointRanking = users
          .map((user) => {
                'name': user['username'] ?? 'Unknown',
                'value': user['point'] ?? 0,
                'image': user['profileImage'] ?? '',
              })
          .toList();

      pointRanking.sort((a, b) =>
          (b['value'] as num).compareTo(a['value'] as num));

      // 'weight'
      List<Map<String, dynamic>> weightRanking = users
          .map((user) => {
                'name': user['username'] ?? 'Unknown',
                'value': user['weight'] ?? 0,
                'image': user['profileImage'] ?? '',
              })
          .toList();

      weightRanking.sort((a, b) =>
          (b['value'] as num).compareTo(a['value'] as num));

      // 'frequency'
      List<Map<String, dynamic>> frequencyRanking = users
          .map((user) => {
                'name': user['username'] ?? 'Unknown',
                'value': user['frequency'] ?? 0,
                'image': user['profileImage'] ?? '',
              })
          .toList();

      frequencyRanking.sort((a, b) =>
          (b['value'] as num).compareTo(a['value'] as num));

      emit({
        'point': pointRanking,
        'weight': weightRanking,
        'frequency': frequencyRanking,
      });
    } catch (e) {
      print("Error fetching rankings: $e");
    }
  }
}
