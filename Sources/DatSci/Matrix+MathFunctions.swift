public extension Matrix {
  static func * (left: Matrix, right: Matrix) -> Matrix {
  try! enforceMultDimensions(left: left.dimensions, right: right.dimensions)
  let n = left.dimensions.rows
  let m = left.dimensions.columns
  let p = right.dimensions.rows
  var C: [Double] = [Double](repeating: 0.0, count: n * p)
  for i in 0...n-1 {
    for j in 0...p - 1 {
      var sum: Double = 0
      for k in 0...m - 1{
        sum += left.grid[(i * left.dimensions.columns) + k] * right.grid[(k * right.dimensions.columns) + j]
      }
      C[(i * p) + j] = sum
    }        
  }
  print(C)
  let newMatrix: Matrix = array1DToMat(C, rows: p)
  return newMatrix
}

   // static func + (left: Matrix, right: Matrix) -> Matrix {
     // try! enforceAddDimensions(got: right.dimensions, expected: left.dimensions)
  //  }
}