# Subscriber

> A protocol that declares a type that can receive input from a publisher.
> 

publisher로 부터 input을 받을 수 있는 타입을 선언하는 프로토콜

```swift
public protocol Subscriber : CustomCombineIdentifierConvertible {

    /// The kind of values this subscriber receives.
    associatedtype Input

    /// The kind of errors this subscriber might receive.
    ///
    /// Use `Never` if this `Subscriber` cannot receive errors.
    associatedtype Failure : Error

    /// Tells the subscriber that it has successfully subscribed to the publisher and may request items.
    ///
    /// Use the received ``Subscription`` to request items from the publisher.
    /// - Parameter subscription: A subscription that represents the connection between publisher and subscriber.
    func receive(subscription: Subscription)

    /// Tells the subscriber that the publisher has produced an element.
    ///
    /// - Parameter input: The published element.
    /// - Returns: A `Subscribers.Demand` instance indicating how many more elements the subscriber expects to receive.
    func receive(_ input: Self.Input) -> Subscribers.Demand

    /// Tells the subscriber that the publisher has completed publishing, either normally or with an error.
    ///
    /// - Parameter completion: A ``Subscribers/Completion`` case indicating whether publishing completed normally or with an error.
    func receive(completion: Subscribers.Completion<Self.Failure>)
}
```

실제 프로토콜을 확인해보면 Publisher와 유사하게 제네릭한 Input, Failure 타입과 receive 메서드가 존재하는 것을 확인 할 수 있다. 

`Publisher에서는 Output, Failure 타입이 있었는데 해당 Publisher에서 방출되는 값을 구독하기 위해서는 Subscriber의 Intput, Failure타입이 일치해야하는 것을 의미!`

![스크린샷 2022-08-23 오후 9.43.47.png](Subscriber%20b097f9a4143c43c38ba9b01a4bd9b95a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2022-08-23_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_9.43.47.png)

 

백문이 불여일견이라고 일단 한번 만들고 하나씩 살펴보자

```swift
class BranSubscriber: Subscriber {
  typealias Input = String
  typealias Failure = Never

  func receive(subscription: Subscription) {
    print("구독을 시작합니다.")
    subscription.request(.unlimited) // 구독 데이터 개수 제한
  }

  func receive(_ input: String) -> Subscribers.Demand {
    print("\(input)")
    return .none
  }

  func receive(completion: Subscribers.Completion<Never>) {
    print("완료", completion)
  }
}
```

- 우선, Publisher와 Subscriber의 Output(Input), Failure 타입이 String, Never로 동일한 것을 확인
- ****receive(subscription:)****

subscriber와 publisher를 연결하는 subscribe 함수 호출이후에 publisher가 호출하는 함수. 구독자에게 subscription을 전달한다. (request(subscriber가 받을 수 있는 최대 개수), cancle)

- ****receive(_ input:)****

subscriber에게 publisher가 element를 생성했음을 알린다. 즉, publisher가 방출한 값을 subscriber가 받는다

- ****receive(_ completion:)****

subscriber에게 이벤트 방출이 정상적으로 종료되었는지 혹은 에러가 발생했는지를 알려준다.

---

```swift
let subscribePublisher = ["삑두", "마늘맨", "코코종"].publisher
subscribePublisher.subscribe(BranSubscriber())

// 구독을 시작합니다.
// 삑두
// 마늘맨
// 코코종
// 완료 finished
```

그럼 우리는 위와 같이 subscribe 메서드를 통해서 Publisher가 생성하는 값들을 받을 수 있다!

```swift
/// Using ``Publisher/subscribe(on:options:)`` also causes the upstream publisher to perform ``Cancellable/cancel()`` using the specfied scheduler.
    ///
    /// - Parameters:
    ///   - scheduler: The scheduler used to send messages to upstream publishers.
    ///   - options: Options that customize the delivery of elements.
    /// - Returns: A publisher which performs upstream operations on the specified scheduler.
    public func subscribe<S>(on scheduler: S, options: S.SchedulerOptions? = nil) -> Publishers.SubscribeOn<Self, S> where S : Scheduler
```

`Publisher 프로토콜을 보면 위와 같이 subscribe를 확인 할 수 있습니다`

[Combine (1-1) - Subcribers.Demand](https://zeddios.tistory.com/966)

갓 제드님의 블로그에 제가 궁금했던 부분이 정리되어 있습니다

---

그럼 publisher에서 방출하는 값들을 관찰하기 위해서 항상 위처럼 Subscriber 프로토콜을 채택하는 클래스를 만들고 receive 메서드를 다 구현해야 하는가? → Sink와 assign을 이용하면 된다!

## Sink

- This method creates the subscriber and immediately requests an unlimited number of values, prior to returning the subscriber.
- The return value should be held, otherwise the stream will be canceled.

sink는 Publisher 프로토콜에 구현되어 있고 코드 주석에 따르면 subscriber를 만들어주는 메서드이다!

(unlimited number of values → .unlimited 추측)

```swift
let sinkPublisher = ["삑두", "마늘맨", "코코종"].publisher
sinkPublisher
  .sink(
    receiveCompletion: {
      print("Completion", $0)
    },
    receiveValue: {
      print("Received Value is", $0)
    }
  ).store(in: &cancellables)

// Received Value is 삑두
// Received Value is 마늘맨
// Received Value is 코코종
// Completion finished
```

우리가 직접 subscriber를 구현할 필요없이 굉장히 간단하게 publisher와 subscriber를 연결시키고 사용할 수 있다

## assign

key path로 표시된 프로퍼티에 수신된 값을 할당하는 subscriber

```swift
class SomeObject {
  var value: String = "" {
    didSet {
      print(value)
    }
  }
}

let object = SomeObject()
let assignPublisher = ["삑두", "마늘맨", "코코종"].publisher
  .assign(to: \.value, on: object)

// 삑두
// 마늘맨
// 코코종
```