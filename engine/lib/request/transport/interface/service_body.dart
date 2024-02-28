// ignore_for_file: slash_for_doc_comments

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class ServiceBody<T> {
  Future<List<dynamic>> body(T object, List<dynamic> extras) {
    throw Exception("You're not extends ServiceBody");
  }

  String getServiceName(T object) {
    throw Exception("You're not extends ServiceBody");
  }
}
