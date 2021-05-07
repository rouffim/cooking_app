class PersistenceLocator {
  var _persistenceMap;
  static PersistenceLocator _instance;

  // Private constructor
  PersistenceLocator._() {
    _persistenceMap = new Map();
  }

  /// access to the Singleton instance of PersistenceLocator
  static PersistenceLocator get instance {
    if (_instance == null) {
      _instance = new PersistenceLocator._();
    }
    return _instance;
  }

  void addPersistence<T>(T instance) {
    _persistenceMap[T.hashCode] = instance;
  }

  T getPersistence<T>() {
    return _persistenceMap[T.hashCode];
  }
}
