import 'package:flutter/material.dart';
import 'package:pitik_internal_app/ui/home/job_activity/job_controller.dart';

class JobActivity extends StatelessWidget {
  const JobActivity({super.key});

  @override
  Widget build(BuildContext context) {
    JobController controller = JobController(context: context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tugas"),
        ),
    );
  }
}