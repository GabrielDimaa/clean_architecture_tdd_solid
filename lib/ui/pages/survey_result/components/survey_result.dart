import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/components/survey_answer.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/components/survey_header.dart';
import '../survey_result_viewmodel.dart';

import 'package:flutter/material.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final void Function({required String answer}) onSave;

  const SurveyResult({Key? key, required this.viewModel, required this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(viewModel.question);
        }
        final answer = viewModel.answers[index - 1];
        return GestureDetector(onTap: () => answer.isCurrentAnswer ? null : onSave(answer: answer.answer), child: SurveyAnswer(answer));
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
