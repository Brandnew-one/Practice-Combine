//
//  BindingSubject.swift
//  MVVM_Practice
//
//  Created by Bran on 2022/10/26.
//

import Combine
import Foundation

struct BindingSubject<T> {
  let subject = PassthroughSubject<T, Never>()
  var value: T {
    didSet { subject.send(value) }
  }
}
