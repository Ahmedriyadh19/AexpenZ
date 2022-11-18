import 'package:uuid/uuid.dart';

class UniqueID {
  static late String _uniqueID;

  UniqueID() {
    generateID();
  }
  static String generateID() {
    return _uniqueID = const Uuid().v4().split('-').join();
  }

  @override
  String toString() => 'UniqueID(_id: $_uniqueID)';
}
