import Combine
import Foundation

var cancellables = Set<AnyCancellable>()

// MARK: - sink를 통해 구독
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
print("---------------")

// MARK: - assign을 통해 구독
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

print("---------------")
print(object.value)

// MARK: - subscribe를 통해 구독
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

let subscribePublisher = ["삑두", "마늘맨", "코코종"].publisher
subscribePublisher.subscribe(BranSubscriber())

