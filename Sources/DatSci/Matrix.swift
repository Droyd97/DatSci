import Foundation

internal typealias MatrixDimension = (rows: Int, columns: Int)


public struct Matrix: CustomStringConvertible, ExpressibleByArrayLiteral {
    
  var dimensions: MatrixDimension
  var grid: [Double]

  public init(arrayLiteral: [Double]...)   {
    let array: [Double] = arrayLiteral.flatMap{$0}
    self.dimensions.rows = arrayLiteral.count
    self.dimensions.columns = arrayLiteral[0].count
    self.grid = array
    for i in 0...dimensions.rows - 1{
      if arrayLiteral[i].count != dimensions.columns {
        fatalError("Incorrect Marix Dimensions")
      }
    }  
  }

  public var description: String {
    var matrixString: String = ""
    let max = String(grid.max()!).count
    for i in 0...dimensions.rows-1{
      for ii in 0...dimensions.columns-1{
        matrixString += "\(grid[(i * dimensions.columns) + ii])".padding(toLength: max + 5, withPad: " ", startingAt:0)        
      }
      matrixString += "\n"
    }
    return matrixString
  }

  subscript(row: Int, col: Int) -> Double {
    get {
      return grid[(row * dimensions.columns) + col]
    }
    set {
      grid[(row * dimensions.columns)+col] = newValue
    }
  }

  subscript(rowRange: ClosedRange<Int>, columnRange: ClosedRange<Int>) -> Matrix {
    get {
      let rows: Int = rowRange.count
      var newArray: [Double] = []
      for row in rowRange{
        for column in columnRange{
          newArray.append(grid[(row * self.dimensions.columns) + column ])
        }
      }
      let newMatrix = array1DToMat(newArray, rows:rows)
      return newMatrix
    }
  }
}


public func array1DToMat(_ array: [Double], rows: Int) -> Matrix{
  var newMatrix: Matrix = [[0]]
  newMatrix.grid = array
  newMatrix.dimensions.rows = rows
  newMatrix.dimensions.columns = array.count / rows
  if (newMatrix.dimensions.rows * newMatrix.dimensions.columns) != newMatrix.grid.count{
    fatalError("Incorrect Matrix Dimensions")
  }
  return newMatrix
}

public func arrayToMat(_ array: [[Double]]) -> Matrix{
  var newMatrix: Matrix = [[0]]
  newMatrix.grid = array.flatMap{$0}
  newMatrix.dimensions.rows = array.count
  newMatrix.dimensions.columns = array[0].count
  for i in 0...newMatrix.dimensions.rows-1{
    if array[i].count != newMatrix.dimensions.columns{
      fatalError("Incorrect Matrix Dimensions")
    }
  }
  return newMatrix
}