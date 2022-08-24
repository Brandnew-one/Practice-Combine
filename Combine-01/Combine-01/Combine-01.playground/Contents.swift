import Combine
import Foundation

// MARK: - Convenience Publisher
var cancellables = Set<AnyCancellable>()

// MARK: - Just
print("--------Just---------")
let justPublisher = Just(["Bran", "JD-Man"])
justPublisher
  .sink(
    receiveCompletion: {
      print("completion", $0)
    },
    receiveValue: {
      print("recevied Value is", $0)
    }
  ).store(in: &cancellables)
print("-----------------")

// MARK: - Future
print("------Future------")
let futurePublisher = Future<String, Never> { promise in
  promise(.success("Bran"))
  promise(.success("JD-Man"))
}
futurePublisher
  .sink(
    receiveCompletion: {
      print("completion", $0)
    },
    receiveValue: {
      print("recevied Value is", $0)
    }
  ).store(in: &cancellables)
print("-----------------")

// MARK: - Empty
print("--------Empty---------")
let emptyPublisher = Empty<String, Never>()
emptyPublisher
  .sink(
    receiveCompletion: {
      print("completion", $0)
    },
    receiveValue: {
      print("recevied Value is", $0)
    }
  ).store(in: &cancellables)
print("-----------------")

// MARK: - Fail
print("--------Fail---------")
enum CustomError: Error {
  case `default`
}

let failPublisher = Fail<String, CustomError>(error: CustomError.default)
failPublisher
  .sink(
    receiveCompletion: {
      print("completion", $0)
    },
    receiveValue: {
      print("recevied Value is", $0)
    }
  ).store(in: &cancellables)
print("-----------------")

// MARK: - Sequence
print("-------Sequence---------")
let sequencePublisher1 = Publishers.Sequence<[String], Never>(sequence: ["Bran", "JD-Man"])

sequencePublisher1
  .sink(
    receiveCompletion: {
      print("completion", $0)
    },
    receiveValue: {
      print("recevied Value is", $0)
    }
  ).store(in: &cancellables)
print("-----------------")

print("--------Sequence2---------")
let sequencePublisher2 = ["Bran", "JD-Man"].publisher
sequencePublisher2
  .sink(
    receiveCompletion: {
      print("completion", $0)
    },
    receiveValue: {
      print("recevied Value is", $0)
    }
  ).store(in: &cancellables)
print("--------x--------")

sequencePublisher2
  .sink(
    receiveCompletion: {
      print("completion", $0)
    },
    receiveValue: {
      print("recevied Value is", $0)
    }
  ).store(in: &cancellables)
print("-----------------")

// MARK: - record
print("--------Record---------")
let recordPublisher = Record<String, Never>(output: ["Bran", "JD-Man"], completion: .finished)
recordPublisher
  .sink(
    receiveCompletion: {
      print("completion", $0)
    },
    receiveValue: {
      print("recevied Value is", $0)
    }
  ).store(in: &cancellables)
print("-----------------")


// MARK: - deferred
print("--------Deferred---------")
let deferredPublisher = Deferred { Just(Void()) }

deferredPublisher
  .sink(receiveValue: { print("Combine Deferred") })
  .store(in: &cancellables)
print("-----------------")

