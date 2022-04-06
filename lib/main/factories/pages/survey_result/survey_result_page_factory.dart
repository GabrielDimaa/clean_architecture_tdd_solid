import 'package:clean_architecture_tdd_solid/main/factories/pages/surveys/surveys_presenter_factory.dart';
import 'package:flutter/material.dart';
import '../../../../ui/pages/survey_result/survey_result_page.dart';

Widget makeSurveyResultPage() => SurveyResultPage(presenter: makeGetxSurveyPresenter());