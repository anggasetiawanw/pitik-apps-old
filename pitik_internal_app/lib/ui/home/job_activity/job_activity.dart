import 'package:flutter/material.dart';
import 'package:pitik_internal_app/ui/home/job_activity/job_controller.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';

class JobActivity extends StatelessWidget {
  const JobActivity({super.key});

  @override
  Widget build(BuildContext context) {
    JobController controller = JobController(context: context);
    return Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: CustomAppbar(title: "Tugas", onBack: (){}, isBack: false,),)
    );
  }
}