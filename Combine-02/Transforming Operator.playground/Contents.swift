import Combine
import Foundation

var cancellables = Set<AnyCancellable>()

// MARK: - collect
let publisher1 = [1, 2, 3, 4].publisher
publisher1
  .collect()
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("---------------")

// MARK: 그럼 스트림이 종료되기 전까지는 결과값을 출력해주지 못하는 형태? -> O
/// 아래와 같이 finished를 받기 전까지 메모리에 저장되기 때문에 잘못짜면 큰일날듯
let publisher2 = PassthroughSubject<Int, Never>()
publisher2
  .collect()
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

publisher2.send(1)
publisher2.send(2)
publisher2.send(1)
publisher2.send(completion: .finished)

print("---------------")

// MARK: - map
let publisher3 = PassthroughSubject<Int, Never>()
publisher3
  .map { $0 * 2 }
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

publisher3.send(1)
publisher3.send(2)
publisher3.send(1)
publisher3.send(completion: .finished)

print("---------------")

// MARK: - tryMap
/// 에러가 발생할 수 있는 경우
print(FileManager.default.currentDirectoryPath)
let publisher4 = Just<String>("Unwrapping")
publisher4
  .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
  .sink(
    receiveCompletion: { print($0) },
    receiveValue: { print("finished: \($0)") }
  ).store(in: &cancellables)

print("---------------")

// MARK: - flatMap (다시 확인해보기!)
let publisher5 = [1, 2, 3, 4].publisher
let publisher6 = ["A", "B", "C", "D"].publisher
publisher5
  .flatMap { (x: Int) -> AnyPublisher<String, Never> in
    publisher6.map { "\(x)" + $0 }
      .eraseToAnyPublisher()
  }
  .sink(
    receiveCompletion: { print($0) },
    receiveValue: { print("\($0)") }
  ).store(in: &cancellables)

print("---------------")

// MARK: - Scan(reduce랑 굉장히 유사)
let publisher7 = [1, 2, 3, 4, 5].publisher
publisher7
  .scan(0) { $0 + $1 }
  .sink(
    receiveCompletion: { print($0) },
    receiveValue: { print("\($0)") }
  ).store(in: &cancellables)

print("---------------")

let publisher8 = PassthroughSubject<Int, Never>()
publisher8
  .scan(0) { $0 + $1 }
  .sink(
    receiveCompletion: { print($0) },
    receiveValue: { print("\($0)") }
  ).store(in: &cancellables)

publisher8.send(1)
publisher8.send(2)
publisher8.send(3)
publisher8.send(4)
publisher8.send(completion: .finished)

