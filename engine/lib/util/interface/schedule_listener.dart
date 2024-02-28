// ignore_for_file: slash_for_doc_comments

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class SchedulerListener {
  Function(dynamic packet) onTick;
  Function(dynamic packet) onTickDone;
  Function(dynamic packet) onTickFail;

  SchedulerListener({required this.onTick, required this.onTickDone, required this.onTickFail});
}
