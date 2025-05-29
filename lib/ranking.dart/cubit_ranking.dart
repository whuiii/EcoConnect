//Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RankingCubit extends Cubit<Map<String, List<Map<String, String>>>> {
  RankingCubit()
      : super({
          'point': [
            {'name': 'Yihong', 'value': '1500'},
            {'name': 'Recycle Monster', 'value': '1300'},
            {'name': 'Mega Knight', 'value': '1200'},
            {'name': 'Terralith', 'value': '1200'},
            {'name': 'Cycloop never die', 'value': '1123'},
            {'name': 'debate', 'value': '1100'},
            {'name': 'lalat king', 'value': '1002'},
            {'name': 'zei bi', 'value': '323'},
            {'name': 'beimuyu', 'value': '142'},
            {'name': 'Wen Hui', 'value': '81'},
          ],
          'weight': [
            {'name': 'Yihong', 'value': '90'},
            {'name': 'Recycle Monster', 'value': '76'},
            {'name': 'Mega Knight', 'value': '42'},
            {'name': 'Terralith', 'value': '42'},
            {'name': 'Cycloop never die', 'value': '41'},
            {'name': 'debate', 'value': '39'},
            {'name': 'lalat king', 'value': '35'},
            {'name': 'zei bi', 'value': '32'},
            {'name': 'beimuyu', 'value': '10'},
            {'name': 'Wen Hui', 'value': '8'},
          ],
          'frequency': [
            {'name': 'Yihong', 'value': '9'},
            {'name': 'Recycle Monster', 'value': '7'},
            {'name': 'Mega Knight', 'value': '4'},
            {'name': 'Terralith', 'value': '4'},
            {'name': 'Cycloop never die', 'value': '4'},
            {'name': 'debate', 'value': '3'},
            {'name': 'lalat king', 'value': '3'},
            {'name': 'zei bi', 'value': '2'},
            {'name': 'beimuyu', 'value': '1'},
            {'name': 'Wen Hui', 'value': '1'},
          ],
        });
}
