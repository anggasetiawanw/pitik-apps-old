import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../dao/dao_impl.dart';
import '../request/service.dart';
import '../request/transport/interface/response_listener.dart';
import '../util/interface/schedule_listener.dart';
import '../util/scheduler.dart';
import 'offline.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.id>
 *@create date 31/07/23
 */

class OfflineAutomation {
    Map<DaoImpl, ServicePeripheral?> registered = {};

    OfflineAutomation put(DaoImpl persistance) {
        registered[persistance] = null;
        return this;
    }

    OfflineAutomation putWithRequest(DaoImpl persistance, ServicePeripheral servicePeripheral) {
        registered[persistance] = servicePeripheral;
        return this;
    }

    Future<List> _getRecords(DaoImpl daoImpl) async {
        return await daoImpl.getRecords('idOffline');
    }

    T _getRecord<T extends Offline>(DaoImpl daoImpl, int idOffline) {
        return daoImpl.queryForModel(daoImpl.instance, 'SELECT * FROM ${daoImpl.tableName} WHERE idOffline = ?', [idOffline]) as T;
    }

    void _deleteByExpiredDateAndFlag(Offline record, DaoImpl daoImpl) {
        try {
            int expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(record.expiredDate!).millisecondsSinceEpoch;

            if (DateTime.now().millisecondsSinceEpoch >= expiredDate && record.flag == 1) {
                daoImpl.delete("idOffline = ?", [record.idOffline.toString()]);
            }
        } on Exception catch(e, stacktrace) {
            print(stacktrace);
        }
    }

    void _deleteByExpiredDate(Offline record, DaoImpl daoImpl) {
        try {
            int expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(record.expiredDate!).millisecondsSinceEpoch;

            if (DateTime.now().millisecondsSinceEpoch >= expiredDate) {
                daoImpl.delete("idOffline = ?", [record.idOffline.toString()]);
            }
        } on Exception catch(e, stacktrace) {
            print(stacktrace);
        }
    }

    Future<int?> _updateFlag<T extends Offline>(DaoImpl daoImpl, int idOffline) async {
        T data = daoImpl.queryForModel(daoImpl.instance, "SELECT * FROM ${daoImpl.tableName} WHERE idOffline = ?", [idOffline]) as T;
        data.flag = 1;

        return await daoImpl.save(data);
    }

    void launch() async {
        await Scheduler()
            .listener(SchedulerListener(
                onTick: (packet) {
                    registered.forEach((key, value) async {
                        for (Offline record in await _getRecords(key)) {
                            if (value == null) {
                                _deleteByExpiredDate(record, key);
                            } else  {
                                if (record.flag == 0) {
                                    value.push(
                                        Get.context!,
                                        value.getRequestBody().body(_getRecord(key, record.idOffline!)),
                                        ResponseListener(
                                            onResponseDone: (code, message, body, id, packet) async {
                                                int? updateStatus = await _updateFlag(key, record.idOffline!);
                                                if (updateStatus != null && updateStatus > 0) {
                                                    _deleteByExpiredDateAndFlag(await _getRecord(key, record.idOffline!), key);
                                                }
                                            },
                                            onResponseFail: (code, message, body, id, packet) {},
                                            onResponseError: (exception, stacktrace, id, packet) {},
                                            onTokenInvalid: () {}
                                        ));
                                } else {
                                    _deleteByExpiredDateAndFlag(record, key);
                                }
                            }
                        }
                        ;
                    });

                    return true;
                },
                onTickDone: (packet) {

                },
                onTickFail: (packet) {

                }))
            .always(true)
            .run(const Duration(minutes: 1));
    }
}