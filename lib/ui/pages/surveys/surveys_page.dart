import 'package:clean_architecture_tdd_solid/ui/pages/surveys/survey_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/surveys/survey_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/spinner_dialog.dart';
import '../../helpers/i18n/resources.dart';
import 'components/survey_items.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  const SurveysPage({Key? key, required this.presenter}) : super(key: key);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys)),
      body: Builder(
        builder: (context) {
          // handleLoading(context, widget.presenter.isLoadingStream);
          // handleSessionExpired(widget.presenter.isSessionExpiredStream);
          // handleNavigation(widget.presenter.navigateToStream);
          // widget.presenter.loadData();
          //
          widget.presenter.loadingStream.listen((loading) {
            if (loading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          //
          // presenter.mainErrorStream?.listen((UIError? error) {
          //   if (error != null) {
          //     showErrorMessage(context, error.descricao);
          //   }
          // });
          //
          // presenter.navigateToStream?.listen((String? page) {
          //   if (page?.isNotEmpty ?? false) {
          //     Get.offAllNamed(page!);
          //   }
          // });

          return StreamBuilder<List<SurveyViewModel>>(
              stream: widget.presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(error: '${snapshot.error}', reload: widget.presenter.loadData);
                }
                if (snapshot.hasData) {
                  return ListenableProvider(
                      create: (_) => widget.presenter,
                      child: SurveyItems(viewModels: snapshot.data!)
                  );
                }
                return const SizedBox(height: 0);
              }
          );
        },
      ),
    );
  }
}