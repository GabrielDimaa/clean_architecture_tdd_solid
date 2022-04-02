import 'package:clean_architecture_tdd_solid/main/factories/pages/surveys/surveys_presenter_factory.dart';
import 'package:flutter/material.dart';
import '../../../../ui/pages/surveys/surveys_page.dart';

Widget makeSurveysPage() => SurveysPage(presenter: makeGetxSurveyPresenter());