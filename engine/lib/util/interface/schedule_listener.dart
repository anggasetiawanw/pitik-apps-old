/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */


class SchedulerListener {
    Function(dynamic packet) onTick;
    Function(dynamic packet) onTickDone;
    Function(dynamic packet) onTickFail;

    SchedulerListener({required this.onTick, required this.onTickDone, required this.onTickFail});
}