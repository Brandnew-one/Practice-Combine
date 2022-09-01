import Combine
import Foundation

var cancellables = Set<AnyCancellable>()

// MARK: - Prepend (RxSwift에서의 Concat과 굉장히 유사하다(순서가 보장된다) )
let publisher1 = [3, 4].publisher
publisher1
  .prepend(1, 2)
  .prepend(-1, 0)
  .sink(receiveValue: { print($0) })
  .store(in: &cancellables)

print("----------------")

let publisher2 = [3, 4].publisher
publisher2
  .prepend([-1, -2])
  .prepend(Set(1...3))
  .sink(receiveValue: { print($0) })
  .store(in: &cancellables)

print("----------------")

let publisher3 = [3, 4].publisher
let publisher4 = [1, 2].publisher

publisher3
  .prepend(publisher4)
  .sink(receiveValue: { print($0) })
  .store(in: &cancellables)

print("----------------")

// MARK: - Append (= Prepend와 유사, 뒤로 값을 붙여주는게 차이)
/// 마찬가지로 순서가 보장된다 (Upstream이 종료되어야 다음 시퀀스가 실행된다.)
let publisher5 = [1, 2].publisher
publisher5
  .append(3, 4)
  .append(5)
  .sink(receiveValue: { print($0) })
  .store(in: &cancellables)

print("----------------")


let publisher6 = [1, 2].publisher
let publisher7 = [3, 4].publisher
publisher6
  .append(publisher7)
  .append(Set(6...9))
  .sink(receiveValue: { print($0) })
  .store(in: &cancellables)

print("-----------")

// MARK: - switchToLatest
let subject1 = PassthroughSubject<Int, Never>()
let subject2 = PassthroughSubject<Int, Never>()
let subject3 = PassthroughSubject<Int, Never>()

let subject = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
subject
  .switchToLatest()
  .sink(
    receiveCompletion: { _ in print("Completed!") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

subject.send(subject1)
subject1.send(1)
subject1.send(2)

subject.send(subject2)
subject1.send(1) // subject1의 구독이 취소되어서 값을 관찰할 수 없음
subject1.send(1)
subject2.send(3)
subject2.send(4)

subject.send(subject3)
subject1.send(1) // subject1의 구독이 취소되어서 값을 관찰할 수 없음
subject2.send(1)
subject3.send(5)
subject3.send(6)

subject3.send(completion: .finished)
subject.send(completion: .finished) // 2개다 finish 되어야 연결이 끊어진다

print("-----------")


// MARK: - merge(RxSwift와 동일)
let publisher8 = PassthroughSubject<Int, Never>()
let publisher9 = PassthroughSubject<Int, Never>()

publisher8
  .merge(with: publisher9)
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

publisher8.send(1)
publisher9.send(-1)
publisher8.send(2)
publisher9.send(-2)
publisher8.send(3)
publisher9.send(-3)
publisher8.send(4)

publisher9.send(completion: .finished)
publisher8.send(completion: .finished)

print("-----------")


// MARK: - CombineLatest(RxSwift와 동일)
let publisher10 = PassthroughSubject<Int, Never>()
let publisher11 = PassthroughSubject<String, Never>()
publisher10
  .combineLatest(publisher11)
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print("\($0) \($1)") }
  ).store(in: &cancellables)

publisher10.send(1)
publisher10.send(2)
publisher11.send("A")
publisher11.send("B")
publisher11.send("C")
publisher10.send(3)

publisher10.send(completion: .finished)
publisher11.send(completion: .finished)

print("-----------")

// MARK: - Zip(=RxSwift)
let publisher12 = PassthroughSubject<Int, Never>()
let publisher13 = PassthroughSubject<String, Never>()
publisher12
  .zip(publisher13)
  .print("publishser")
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print("\($0) \($1)") }
  ).store(in: &cancellables)

publisher12.send(1)
publisher12.send(2)
publisher13.send("A")
publisher13.send("B")
publisher13.send("C")
publisher12.send(3)
publisher12.send(4)

publisher10.send(completion: .finished)
publisher11.send(completion: .finished)

print("-----------")

