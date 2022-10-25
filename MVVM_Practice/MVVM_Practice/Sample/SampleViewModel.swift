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
    let textFieldStringSubject = PassthroughSubject<String, Never>()
    var textFieldString: String = "" {
      didSet { textFieldStringSubject.send(textFieldString) }
    }
  }

  enum Action {
    case minusButtonTapped
    case plusButtonTapped
    case textdidChanged(text: String)
  }

  struct Output {
    var resultNumber: Int = 0
    var resultText: String = ""
  }

  // MARK: - @Published 적용 시키고, Binding<String> 자체를 input으로 넣는건 어떨까?
  var input: Input = Input()

  func action(_ action: Action) {
    switch action {
    case .minusButtonTapped:
      input.minusButton.send()
    case .plusButtonTapped:
      input.plusButton.send()
    case .textdidChanged(let text):
      input.textFieldStringSubject.send(text)
    }
  }

  @Published private(set) var output: Output = Output()

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

    input.textFieldStringSubject
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .sink(receiveValue: {
        self.output.resultText = $0
      }).store(in: &cancellables)
  }

}
