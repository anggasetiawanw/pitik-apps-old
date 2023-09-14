// ignore_for_file: slash_for_doc_comments, empty_catches, avoid_print, depend_on_referenced_packages

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite/sqflite.dart';
import '../util/mirror_feature.dart';
import 'annotation/attribute.dart';
import 'annotation/reference.dart';
import 'annotation/table.dart';
import 'base_entity.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class DBLite {
    static Database? _database;
    List<dynamic> tables;
    int version;

    DBLite({required this.tables, required this.version});

    /// This is a getter function that returns a database object.
    Future<Database> get create async {
        if (_database != null) {
            return _database!;
        }
        // if _database is null we instantiate it
        _database = await _createTables(tables);
        return _database!;
    }

    static get database => _database;

    /// It creates a database table for each class that has the `@Table` annotation
    ///
    /// Args:
    ///   persistanceClassList (List<dynamic>): List of classes that will be used to
    /// create tables in the database.
    ///
    /// Returns:
    ///   A Future<Database>
    _createTables(List<dynamic> persistanceClassList) async {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = '${documentsDirectory.path}/pitik$version.db';

        return await openDatabase(path, version: version, onOpen: (db) {
        }, onCreate: (Database db, int version) async {

            for (dynamic table in persistanceClassList) {
                String query = "CREATE TABLE ";
                String reference = "";

                ClassMirror classMirror = SetupEntity.reflectType(table) as ClassMirror;
                Table tableAnnotate;
                for (var t in classMirror.metadata) {
                    if (t.runtimeType == Table) {
                        tableAnnotate = t as Table;
                        query += tableAnnotate.tableName;
                        query += " (";
                    }
                }

                for (var v in classMirror.declarations.values) {
                    if (v is VariableMirror) {
                        List<dynamic> attributes = MirrorFeature.getVariables(v, Attribute);

                        // add attributes name to query create
                        for (Attribute attribute in attributes) {
                            String notNull = attribute.notNull ? "NOT NULL " : " ";
                            String primaryKey = attribute.primaryKey ? "PRIMARY KEY " : " ";
                            String autoIncrement = attribute.autoIncrements ? "AUTOINCREMENT" : " ";
                            String defaultValue = attribute.defaultValue;
                            String typeString = primaryKey == " " ? "${attribute.type}(${attribute.length}) " : "${attribute.type} ";

                            if (defaultValue != "") {
                                defaultValue = "DEFAULT '$defaultValue' ";
                            } else {
                                defaultValue = "";
                            }

                            query += attribute.name;
                            query += " ";
                            query += typeString;
                            query += notNull;
                            query += defaultValue;
                            query += primaryKey;
                            query += autoIncrement;

                            query += ",";
                        }

                        Reference? referenceAnnotate = MirrorFeature.getAnnotation(v, Reference);
                        if (referenceAnnotate != null) {
                            try {
                                ClassMirror classMirror = SetupEntity.reflectType(referenceAnnotate.tableReference) as ClassMirror;
                                for (var tf in classMirror.declarations.values) {
                                    if (tf is TypeMirror) {
                                        Table tableReference = MirrorFeature.getAnnotation(tf, Table);

                                        reference += ", FOREIGN KEY(";
                                        reference += referenceAnnotate.fieldName;
                                        reference += ") REFERENCES ";
                                        reference += tableReference.tableName;
                                        reference += ")";
                                        reference += referenceAnnotate.referenceName;
                                        reference += ")";
                                    }
                                }
                            } on Exception catch(e, stacktrace) {
                                print(stacktrace);
                            }
                        }
                    }
                }

                for (var v in classMirror.superclass!.declarations.values) {
                    if (v is VariableMirror) {
                        List<dynamic> attributes = MirrorFeature.getVariables(v, Attribute);

                        // add attributes name to query create
                        for (Attribute attribute in attributes) {
                            String notNull = attribute.notNull ? "NOT NULL " : " ";
                            String primaryKey = attribute.primaryKey ? "PRIMARY KEY " : " ";
                            String autoIncrement = attribute.autoIncrements ? "AUTOINCREMENT" : " ";
                            String defaultValue = attribute.defaultValue;
                            String typeString = primaryKey == " " ? "${attribute.type}(${attribute.length}) " : "${attribute.type} ";

                            if (defaultValue != "") {
                                defaultValue = "DEFAULT '$defaultValue' ";
                            } else {
                                defaultValue = "";
                            }

                            query += attribute.name;
                            query += " ";
                            query += typeString;
                            query += notNull;
                            query += defaultValue;
                            query += primaryKey;
                            query += autoIncrement;

                            query += ",";
                        }

                        Reference? referenceAnnotate = MirrorFeature.getAnnotation(v, Reference);
                        if (referenceAnnotate != null) {
                            try {
                                ClassMirror classMirror = SetupEntity.reflectType(referenceAnnotate.tableReference) as ClassMirror;
                                for (var tf in classMirror.declarations.values) {
                                    if (tf is TypeMirror) {
                                        Table tableReference = MirrorFeature.getAnnotation(tf, Table);

                                        reference += ", FOREIGN KEY(";
                                        reference += referenceAnnotate.fieldName;
                                        reference += ") REFERENCES ";
                                        reference += tableReference.tableName;
                                        reference += ")";
                                        reference += referenceAnnotate.referenceName;
                                        reference += ")";
                                    }
                                }
                            } on Exception catch(e, stacktrace) {
                                print(stacktrace);
                            }
                        }
                    }
                }

                query = "${query.substring(0, query.length - 1)}) ";
                query += reference;
                print('query create => $query');

                await db.execute(query);
            }
        });
    }
}

/// The DBProvider class is a singleton class that provides access to the database
class DBProvider {
    DBProvider._();
    static final DBProvider db = DBProvider._();
}