import Combine
import Foundation

var cancellables = Set<AnyCancellable>()

let subject1 = PassthroughSubject<Int, Never>()
subject1
  .sink(
    receiveCompletion: { print("completion1", $0) },
    receiveValue: {
      print("Received Value1:", $0)
    }
  ).store(in: &cancellables)


subject1.send(0)
subject1.send(1)
subject1.send(2)
subject1.send(completion: .finished)

print("----------------")

let subject2 = CurrentValueSubject<Int, Never>(0)
subject2
  .sink(
    receiveCompletion: { print("completion2", $0) },
    receiveValue: {
      print("Received Value2:", $0)
    }
  ).store(in: &cancellables)

subject2.send(1)
subject2.send(2)

subject2
  .sink(
    receiveCompletion: { print("completion3", $0) },
    receiveValue: {
      print("Received Value3:", $0)
    }
  ).store(in: &cancellables)

subject2.send(3)

subject2.send(completion: .finished)
