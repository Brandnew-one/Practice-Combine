//
//  SignupViewModel.swift
//  Signup_Ex
//
//  Created by Bran on 2022/08/30.
//

import Combine
import Foundation

final class SignupViewModel: ObservableObject {
  // MARK: - Input
  @Published
  var user: String = ""

  @Published
  var password: String = ""

  @Published
  var passwordCheck: String = ""


  // MARK: - Output
  @Published
  var usernameMessage: String = ""

  @Published
  var passwordHeaderMessage: String = ""

  @Published
  var passwordMessage: String = ""

  @Published
  var validation: Bool = false

  private var cancellables = Set<AnyCancellable>()

  @Published
  var pageSheetShow: Bool = false

  func transform() {
    // MARK: - User Name Logic
    let usernameCheck: AnyPublisher<Bool, Never> = $user
      .filter { !$0.isEmpty }
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .map { $0.count >= 3 ? true : false }
      .eraseToAnyPublisher()

    // MARK: - Password From
    let passwordFormCheck = $password
      .filter { !$0.isEmpty }
      .map { password -> Bool in
        if password.isEmpty {
          return false
        } else {
          return self.checkExpression(password) ? true : false
        }
      }
      .eraseToAnyPublisher()

    // MARK: - Password Same Check
    let passwordSameCheck = $password
      .filter { !$0.isEmpty }
      .combineLatest($passwordCheck)
      .map { $0 == $1 && !$0.isEmpty && !$1.isEmpty ? true : false }
      .eraseToAnyPublisher()

    // MARK: - Validate
    let validateCheck = Publishers.CombineLatest3(usernameCheck, passwordFormCheck, passwordSameCheck)
      .map { $0.0 && $0.1 && $0.2 }
      .eraseToAnyPublisher()

    usernameCheck
      .receive(on: RunLoop.main)
      .map { $0 ? "" : "User name must at least have 3 characters" }
      .assign(to: \.usernameMessage, on: self)
      .store(in: &cancellables)

    passwordFormCheck
      .receive(on: RunLoop.main)
      .map { $0 ? "" : "영어 대소문자,숫자,특수문자 중 3종, 8자 이상" }
      .assign(to: \.passwordHeaderMessage, on: self)
      .store(in: &cancellables)

    passwordSameCheck
      .receive(on: RunLoop.main)
      .map { $0 ? "" : "Password is not matched" }
      .assign(to: \.passwordMessage, on: self)
      .store(in: &cancellables)

    validateCheck
      .receive(on: RunLoop.main)
      .assign(to: \.validation, on: self)
      .store(in: &cancellables)
  }

  init() {
    transform()
  }

}

// MARK: -  정규표현식
extension SignupViewModel {
  func checkExpression(_ text: String) -> Bool {
    let pattern = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
    let regex = try? NSRegularExpression(pattern: pattern)

    if let _ = regex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) {
      return true
    } else {
      return false
    }
  }
}
