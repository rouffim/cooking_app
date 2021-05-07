import 'package:uuid/uuid.dart';

class UuidUtils {
  static final uuid = Uuid();

  static String generateUuid() {
    return uuid.v4();
  }

}