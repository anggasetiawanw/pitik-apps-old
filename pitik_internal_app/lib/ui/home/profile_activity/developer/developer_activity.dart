import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import '../../../../widget/common/custom_appbar.dart';

class DeveloperActivity extends StatelessWidget {
  const DeveloperActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: CustomAppbar(title: 'Developer', onBack: () => Navigator.pop(context))),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: const Text('Open Chucker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4, left: 16, right: 16),
                child: ChuckerFlutter.chuckerButton,
              )
            ],
          ),
        ));
  }
}
