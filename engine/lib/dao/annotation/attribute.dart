// ignore_for_file: slash_for_doc_comments

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class Attribute {
  final String name;
  final String type;
  final int length;
  final String defaultValue;
  final bool primaryKey;
  final bool autoIncrements;
  final bool notNull;

  const Attribute({required this.name, this.type = "VARCHAR", this.length = 255, this.defaultValue = "", this.primaryKey = false, this.autoIncrements = false, this.notNull = false});
}
