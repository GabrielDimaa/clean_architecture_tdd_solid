import 'package:flutter/material.dart';

import '../helpers/i18n/resources.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  const ReloadScreen({Key? key, required this.error, required this.reload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: reload,
            child: Text(R.string.reload),
          )
        ],
      ),
    );
  }
}