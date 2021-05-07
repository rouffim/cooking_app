import 'package:cool_cooker/core/model/factory/factory_locator_setup.dart';
import 'package:cool_cooker/core/persistence/persistence_locator_setup.dart';
import 'package:cool_cooker/core/service/service_locator_setup.dart';

void locatorsSetup() {
  factoryLocatorSetup();
  persistenceLocatorSetup();
  serviceLocatorSetup();
}
