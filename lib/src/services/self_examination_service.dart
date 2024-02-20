import 'package:Actualizator/src/repository/self_examination_repository.dart';

import '../models/examination_result.dart';

class SelfExaminationService {
  ExaminationRepository examinationRepository = ExaminationRepository();


  Future<List<String>> getTodayExaminations() async {

    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

    List<ExaminationResult> examinations = await examinationRepository.loadData();
    List<ExaminationResult> todayExaminations = examinations
        .where((examination) =>
        examination.date.year == yesterday.year &&
        examination.date.month == yesterday.month &&
        examination.date.day == yesterday.day)
        .toList();

    return getOnlyGoals(todayExaminations);
  }


  List<String> getOnlyGoals(List<ExaminationResult> examinations) {
    return examinations.map((examination) => examination.goals).toList();
  }
}