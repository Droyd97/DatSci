extension Mirror {
  static func childProperties<T>(for target: Any, type: T.Type = T.self, use closure: (T) -> Void){
    let mirror = Mirror(reflecting: target)

  for child in mirror.children{
    (child.value as? T).map(closure)

    Mirror.childProperties(for:child.value, use: closure)
  }
  }
}