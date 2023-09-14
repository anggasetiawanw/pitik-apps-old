// ignore_for_file: slash_for_doc_comments

import 'dart:async';
import 'interface/schedule_listener.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class Scheduler {
    SchedulerListener? mListener;
    bool isAlways = false;
    Timer? _timer;
    int max = -1;
    int countRetry = -1;
    dynamic packets;

    Scheduler packet(dynamic data) {
        packets = data;
        return this;
    }

    /// Scheduler listener(SchedulerListener listener) {...}
    ///
    /// Args:
    ///   listener (SchedulerListener): The listener to be notified when the
    /// scheduler is started, stopped, or when a job is scheduled.
    ///
    /// Returns:
    ///   The Scheduler object itself.
    Scheduler listener(SchedulerListener listener) {
        mListener = listener;
        return this;
    }

    /// `always` is a function that takes a boolean value and returns a Scheduler
    /// object
    ///
    /// Args:
    ///   always (bool): If true, the task will be executed even if the network is
    /// not available.
    ///
    /// Returns:
    ///   The Scheduler object itself.
    Scheduler always(bool always) {
        isAlways = always;
        max = -1;
        countRetry = -1;

        return this;
    }

    /// If the max number of retries is reached, then stop retrying.
    ///
    /// Args:
    ///   max (int): The maximum number of retries.
    ///
    /// Returns:
    ///   The Scheduler itself.
    Scheduler maxRetry(int max) {
        this.max = max;
        isAlways = false;
        countRetry = 0;

        return this;
    }

    /// > The function runs a timer that calls the `onTick` function of the listener
    /// every `duration` milliseconds. If the `onTick` function returns `true`, the
    /// `onTickDone` function is called. If the `onTick` function returns `false`,
    /// the `onTickFail` function is called. If the `max` variable is not equal to
    /// -1 and the `countRetry` variable is less than or equal to the `max`
    /// variable, the `countRetry` variable is incremented. If the `isAlways`
    /// variable is `false`, the timer is cancelled
    ///
    /// Args:
    ///   duration (Duration): The time interval between each tick.
    Future<void> run(Duration duration) async {
        _timer = Timer.periodic(duration, (val) {
            if (mListener!.onTick(packets)) {
                mListener!.onTickDone(packets);
            } else {
                mListener!.onTickFail(packets);
            }

            if (max != -1 && countRetry <= max) {
                countRetry++;
            } else if (!isAlways) {
                _timer!.cancel();
                val.cancel();
            }
        });
    }

    /// If the timer is not null, cancel it, then run the timer.
    ///
    /// Args:
    ///   duration (Duration): The amount of time to wait before running the
    /// function.
    void update(Duration duration) {
        if (_timer != null) {
            _timer!.cancel();
        }

        run(duration);
    }

    /// If the timer is not null, cancel it.
    void stop() {
        if (_timer != null) {
            _timer!.cancel();
        }
    }
}