class FactoryLocator {
  var _factoryMap;
  static FactoryLocator _instance;

  // Private constructor
  FactoryLocator._() {
    _factoryMap = new Map();
  }

  /// access to the Singleton instance of FactoryLocator
  static FactoryLocator get instance {
    if (_instance == null) {
      _instance = new FactoryLocator._();
    }
    return _instance;
  }

  void addFactory<T>(T instance) {
    _factoryMap[T.hashCode] = instance;
  }

  T getFactory<T>() {
    return _factoryMap[T.hashCode];
  }
}
