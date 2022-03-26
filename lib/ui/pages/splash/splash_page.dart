import 'package:clean_architecture_tdd_solid/ui/pages/splash/splash_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({required this.presenter, Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
          widget.presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty ?? false) {
              Get.offAllNamed(page!);
            }
          });

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
