# Transforming Operator

## 1) collect

발생한 이벤트를 모아서 전달한다

```swift
let publisher1 = [1, 2, 3, 4].publisher
publisher1
  .collect()
  .sink(
    receiveCompletion: { _ in print("Completed") },
    receiveValue: { print($0) }
  ).store(in: &cancellables)

// [1, 2, 3, 4]
// Completed
```

결과를 확인하면 finish 될때까지 이벤트를 모아서 배열 형태로 이벤트가 방출되는 것을 확인 할 수 있다.

하지만 만약 이벤트가 종료되지 않는 경우에는 어떻게 될까?

```swift
// MARK: 그럼 스트림이 종료되기 전까지는 결과값을 출력해주지 못하는 형태? -> O
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
```

위와 같이 publisher에 finish 이벤트가 발생하지 않으면 메모리에 지금까지 발생한 이벤트들이 모두 저장된 상태로 남아있게 된다. collect에 따로 count 개수를 지정하지 않으면 개수에 제한이 없기 때문에 주의해아 한다

## 2) map

```swift
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

// 2
// 4
// 2
// Completed
```

Swift의 map, RxSwift의 map과 동일하다

## 3) tryMap

```swift
let publisher4 = Just<String>("Unwrapping")
publisher4
  .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
  .sink(
    receiveCompletion: { print($0) },
    receiveValue: { print("finished: \($0)") }
  ).store(in: &cancellables)
```

코드에서 확인할 수 있듯이 transform 클로저가 에러를 발생시키면 tryMap을 사용해서 에러이벤트를 발생시키면서 publisher를 종료시킬 수 있다.

## 4) flatMap

```swift
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

// 1A
// 1B
// 1C
// 1D
// 2A
// 2B
// 2C
// 2D
// finished
```

RxSwift에서 사용하던 flatMap과 굉장히 유사하다. publisher를 통해 새로운 publisher로 변환한다