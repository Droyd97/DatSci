
internal enum MatrixError: Error{
  case invalidAddition(got: MatrixDimension, expected: MatrixDimension)
  case invalidMultiplication(left: MatrixDimension, right: MatrixDimension)
}

internal func enforceAddDimensions(got: MatrixDimension, expected: MatrixDimension) throws {
  guard got == expected else {
    throw MatrixError.invalidAddition(got:got, expected:expected)
  }
}

internal func enforceMultDimensions(left: MatrixDimension, right: MatrixDimension) throws {
  guard left.columns == right.rows else{
    throw MatrixError.invalidMultiplication(left: left, right: right)
  }
}