import Combine
import Foundation

var cancellables = Set<AnyCancellable>()

// MARK: - Filter (= RxSwift)
let publisher1 = [1, 2, 3, 4, 5].publisher
publisher1
  .filter { $0 % 2 == 0 }
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("--------------")

// MARK: - removeDuplicates(= distinctUntilChanged)
let publisher2 = "I really really want to go Home Home Home!"
  .components(separatedBy: " ")
  .publisher

publisher2
  .removeDuplicates()
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("--------------")

// MARK: - first, last (조건 일치하는 경우 시퀀스 종료)
let publisher3 = [1, 2, 3, 4, 5].publisher
publisher3
  .first { $0 % 2 == 0 }
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("--------------")

let publisher4 = [1, 2, 3, 4, 5].publisher
publisher4
  .last { $0 % 2 == 0 }
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("--------------")

/// collect와 마찬가지로 마지막 subject로 들어오는 경우 종료되는 시점까지 값을 관찰해야 한다
let publisher5 = PassthroughSubject<Int, Never>()
publisher5
  .last { $0 % 2 == 0 }
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

publisher5.send(1)
publisher5.send(2)
publisher5.send(3)
publisher5.send(4)
publisher5.send(completion: .finished)

print("--------------")

// MARK: - drop(= skip)
let publisher6 = (1...10).publisher
publisher6
  .dropFirst(8) // skip()
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("--------------")

let publisher7 = (1...10).publisher
publisher7
  .drop(while: { $0 != 3 }) // skip(while:)과 동일, 조건을 만족하지 못하는 순간부터 이벤트를 방출(조건 사라짐)
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("--------------")

let publisher8 = PassthroughSubject<Int, Never>()
let trigger = PassthroughSubject<Void, Never>()
publisher8
  .drop(untilOutputFrom: trigger) // skip(until:)과 동일, tigger 이벤트가 발생하는 시점부터 이벤트 방출
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

publisher8.send(0)
publisher8.send(1)
publisher8.send(2)

trigger.send(Void())

publisher8.send(3)
publisher8.send(4)

print("--------------")

// MARK: - prefix (= take)
let publisher9 = (1...10).publisher
publisher9
  .prefix(2) // take()와 동일
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("--------------")

let publisher10 = (1...10).publisher
publisher10
  .prefix(while: { $0 < 3 }) // take(while:)
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

print("--------------")

let publisher11 = PassthroughSubject<Int, Never>()
let trigger2 = PassthroughSubject<Void, Never>()
publisher11
  .prefix(untilOutputFrom: trigger2) // take(until:)
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

publisher11.send(0)
publisher11.send(1)
publisher11.send(2)

trigger2.send(Void())

publisher11.send(3)
publisher11.send(4)

print("--------------")

