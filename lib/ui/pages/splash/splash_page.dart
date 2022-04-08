import 'package:clean_architecture_tdd_solid/ui/mixins/navigation_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/splash/splash_presenter.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({required this.presenter, Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with NavigationManager {
  @override
  void initState() {
    super.initState();

    widget.presenter.checkAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4Dev')),
      body: Builder(
        builder: (context) {
          handleNavigation(widget.presenter.navigateToStream, clear: true);

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
