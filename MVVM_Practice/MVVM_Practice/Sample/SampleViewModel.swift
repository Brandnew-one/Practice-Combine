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
    fileprivate let minusButtonSubject = PassthroughSubject<Void, Never>()
    fileprivate let plusButtonSubject = PassthroughSubject<Void, Never>()

    var textFieldInput = BindingSubject<String>(value: "")
  }

  enum Action {
    case minusButtonTapped
    case plusButtonTapped
  }

  func action(_ action: Action) {
    switch action {
    case .minusButtonTapped:
      input.minusButtonSubject.send()
    case .plusButtonTapped:
      input.plusButtonSubject.send()
    }
  }

  struct Output {
    var resultNumber: Int = 0
    var resultText: String = ""
  }

  var input: Input = Input()

  @Published private(set) var output: Output = Output()

  var cancellables = Set<AnyCancellable>()

  init() {
    transform()
  }

  func transform() {
    input.minusButtonSubject
      .throttle(for: 0.1, scheduler: RunLoop.main, latest: false)
      .sink(receiveValue: {
        self.output.resultNumber -= 1
      }).store(in: &cancellables)

    input.plusButtonSubject
      .throttle(for: 0.1, scheduler: RunLoop.main, latest: false)
      .sink(receiveValue: {
        self.output.resultNumber += 1
      }).store(in: &cancellables)

    input.textFieldInput.subject
      .debounce(for: 0.1, scheduler: RunLoop.main)
      .sink(receiveValue: {
        self.output.resultText = $0
      }).store(in: &cancellables)
  }
}
