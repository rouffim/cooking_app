import 'package:cool_cooker/core/model/exception/default_exception.dart';

class NoConnexionException extends DefaultException {
  const NoConnexionException(): super("general.no_internet");
}