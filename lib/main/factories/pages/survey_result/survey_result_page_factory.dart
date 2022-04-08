import 'package:clean_architecture_tdd_solid/main/factories/pages/survey_result/survey_result_presenter_factory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/survey_result/survey_result_page.dart';

Widget makeSurveyResultPage() {
  return SurveyResultPage(makeGetxSurveyResultPresenter(Get.parameters['survey_id'] ?? ""));
}