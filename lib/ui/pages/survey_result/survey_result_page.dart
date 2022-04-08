import 'package:clean_architecture_tdd_solid/ui/components/reload_screen.dart';
import 'package:clean_architecture_tdd_solid/ui/mixins/loading_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/mixins/session_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../helpers/i18n/resources.dart';
import 'components/survey_result.dart';

class SurveyResultPage extends StatefulWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage(this.presenter, {Key? key}) : super(key: key);

  @override
  _SurveyResultPageState createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> with LoadingManager, SessionManager {
  @override
  void initState() {
    super.initState();

    widget.presenter.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(R.string.surveyResult)),
        body: Builder(
            builder: (context) {
              handleSessionExpired(widget.presenter.sessionExpiredStream);
              handleLoading(context, widget.presenter.loadingStream);

              return StreamBuilder<SurveyResultViewModel?>(
                  stream: widget.presenter.surveyResultStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ReloadScreen(error: '${snapshot.error}', reload: widget.presenter.loadData);
                    }
                    if (snapshot.hasData) {
                      return SurveyResult(viewModel: snapshot.data!, onSave: widget.presenter.save);
                    }
                    return const SizedBox(height: 0);
                  }
              );
            }
        )
    );
  }
}