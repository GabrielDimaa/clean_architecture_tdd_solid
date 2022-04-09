import 'package:clean_architecture_tdd_solid/ui/pages/surveys/survey_view_model.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/surveys/surveys_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../ui/mixins/loading_manager.dart';
import '../../../ui/mixins/navigation_manager.dart';
import '../../../ui/mixins/session_manager.dart';
import '../../components/reload_screen.dart';
import '../../components/spinner_dialog.dart';
import '../../helpers/i18n/resources.dart';
import 'components/survey_items.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  const SurveysPage({Key? key, required this.presenter}) : super(key: key);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> with LoadingManager, NavigationManager, SessionManager, RouteAware {
  @override
  void initState() {
    super.initState();

    widget.presenter.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys)),
      body: Builder(
        builder: (context) {
          widget.presenter.loadingStream.listen((loading) {
            if (loading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter.sessionExpiredStream.listen((expired) {
            if (expired) {
              Get.offAllNamed("/login");
            }
          });

          widget.presenter.navigateToStream.listen((String? page) {
            if (page?.isNotEmpty ?? false) {
              Get.toNamed(page!);
            }
          });

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

  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  void dispose() {
    final RouteObserver<Route> routeObserver = Get.find<RouteObserver>();
    routeObserver.unsubscribe(this);

    super.dispose();
  }
}
