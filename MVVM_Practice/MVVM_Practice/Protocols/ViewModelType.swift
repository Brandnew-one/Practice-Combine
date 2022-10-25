//
//  ViewModelType.swift
//  MVVM_Practice
//
//  Created by Bran on 2022/10/25.
//

import Combine
import Foundation

protocol ViewModelType: ObservableObject {
  associatedtype Input // Struct
  associatedtype Action
  associatedtype Output // Struct

  var cancellables: Set<AnyCancellable> { get }
  var input: Input { get }
  var output: Output { get } // private(set)

  func action(_ action: Action)
  func transform()
}
