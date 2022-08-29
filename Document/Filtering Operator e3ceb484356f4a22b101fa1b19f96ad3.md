# Filtering Operator

## 1) filter

```swift
let publisher1 = [1, 2, 3, 4, 5].publisher
publisher1
  .filter { $0 % 2 == 0 }
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// 2
// 4
// Completed
```

## 2) removeDuplicates

바로 이전에 방출한 이벤트와 동일한 값인 경우 무시

```swift
let publisher2 = "I really really want to go Home Home Home!"
  .components(separatedBy: " ")
  .publisher

publisher2
  .removeDuplicates()
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// I
// really
// want
// to
// go
// Home
// Home!
// Completed
```

RxSwift에서의 ****distinctUntilChanged****와 동일하다!

really, Home이 이전값과 중복되기 때문에 무시되는 것을 확인할 수 있다.

## 3) first

```swift
let publisher3 = [1, 2, 3, 4, 5].publisher
publisher3
  .first { $0 % 2 == 0 }
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// 2
// Completed
```

처음으로 조건이 일치할 때, 해당 이벤트를 방출하고 시퀀스가 종료된다

## 4) last

```swift
let publisher4 = [1, 2, 3, 4, 5].publisher
publisher4
  .last { $0 % 2 == 0 }
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// 4
// Completed
```

조건이 일치하는 마지막 요소를 방출한다. `last`의 경우 언제 조건을 만족하는 마지막 값이 들어올 지 모르기 때문에 시퀀스의 종료까지 값을 바라봐야 한다. 

```swift
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
publisher5.send(completion: .finished) // 종료되지 않으면 값이 방출되지 않음

// 4
// Completed
```

## 5) drop

- drop()

```swift
let publisher6 = (1...10).publisher
publisher6
  .dropFirst(8) // skip()
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// 9
// 10
// Completed
```

처음 발생하는 n개의 이벤트를 무시한다(= RxSwift에서 skip과 동일)

- drop(while:)

```swift
let publisher7 = (1...10).publisher
publisher7
  .drop(while: { $0 != 3 })
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// 3
// 4
// 5
// 6
// 7
// 8
// 9
// 10
// Completed
```

skip(while:)과 동일, 조건을 만족하지 못하는 순간부터 이벤트를 방출(조건 사라짐)

- drip(untilOutputFrom:)

```swift
let publisher8 = PassthroughSubject<Int, Never>()
let trigger = PassthroughSubject<Void, Never>()
publisher8
  .drop(untilOutputFrom: trigger)
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

// 3
// 4
```

skip(until:)과 동일, tigger 이벤트가 발생하는 시점부터 이벤트 방출

## 6) prefix

- prefix()

```swift
let publisher9 = (1...10).publisher
publisher9
  .prefix(2)
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// 1
// 2
// Completed
```

take()와 동일, 입력한 개수만큼 이벤트를 방출하고 그 이후에 종료된다

- prefix(while:)

```swift
let publisher10 = (1...10).publisher
publisher10
  .prefix(while: { $0 < 3 }) // take(while:)
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// 1
// 2
```

take(while:)과 동일, 조건을 만족하는 경우까지 이벤트를 방출(false가 되는 시점부터 조건 사라짐)

- prefix(untilOutputFrom:)

```swift
let publisher11 = PassthroughSubject<Int, Never>()
let trigger2 = PassthroughSubject<Void, Never>()
publisher11
  .prefix(untilOutputFrom: trigger2)
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
```

take(until:)과 동일, trigger 이벤트가 발생하기 전까지 이벤트 방출