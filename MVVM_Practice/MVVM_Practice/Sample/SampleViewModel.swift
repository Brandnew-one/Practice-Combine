//
//  SampleViewModel.swift
//  MVVM_Practice
//
//  Created by Bran on 2022/10/25.
//

import Combine
import Foundation

final class SampleViewModel: ViewModelType {
  struct Input {
    let minusButton = PassthroughSubject<Void, Never>()
    let plusButton = PassthroughSubject<Void, Never>()
  }

  enum Action {
    case minusButtonTapped
    case plusButtonTapped
  }

  struct Output {
    var resultNumber: Int = 0
  }

  let input: Input = Input()

  func action(_ action: Action) {
    switch action {
    case .minusButtonTapped:
      input.minusButton.send()
    case .plusButtonTapped:
      input.plusButton.send()
    }
  }

  @Published private(set) var output: Output = Output() {
    didSet {
      print("Changed")
    }
  }

  var cancellables = Set<AnyCancellable>()

  init() {
    transform()
  }

  func transform() {
    input.minusButton
      .throttle(for: 0.1, scheduler: RunLoop.main, latest: false)
      .sink(receiveValue: {
        self.output.resultNumber -= 1
      }).store(in: &cancellables)

    input.plusButton
      .throttle(for: 0.1, scheduler: RunLoop.main, latest: false)
      .sink(receiveValue: {
        self.output.resultNumber += 1
      }).store(in: &cancellables)
  }

}
