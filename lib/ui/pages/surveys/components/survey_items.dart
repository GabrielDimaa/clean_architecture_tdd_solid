import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/surveys/components/survey_item.dart';
import 'package:flutter/material.dart';

import '../survey_view_model.dart';

class SurveyItems extends StatelessWidget {
  final List<SurveyViewModel> viewModels;

  const SurveyItems({Key? key, required this.viewModels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1
        ),
        items: viewModels.map((viewModel) => SurveyItem(viewModel: viewModel)).toList(),
      ),
    );
  }
}