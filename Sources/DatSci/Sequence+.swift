extension Sequence where Element: Hashable{
  var isUnique: Bool {
    var set = Set<Element>()
    for e in self {
      if set.insert(e).inserted == false { return false} 
    }
    return true
  }
}