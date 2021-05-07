class ServiceLocator {
  var _servicesMap;
  static ServiceLocator _instance;

  // Private constructor
  ServiceLocator._() {
    _servicesMap = new Map();
  }

  /// access to the Singleton instance of ServiceLocator
  static ServiceLocator get instance {
    if (_instance == null) {
      _instance = new ServiceLocator._();
    }
    return _instance;
  }

  void addService<T>(T instance) {
    _servicesMap[T.hashCode] = instance;
  }

  T getService<T>() {
    return _servicesMap[T.hashCode];
  }
}
