//
//  SignupView.swift
//  Signup_Ex
//
//  Created by Bran on 2022/08/30.
//

import SwiftUI

struct SignupView: View {
  @StateObject
  var viewModel = SignupViewModel()

  var body: some View {
    List {
      Section(
        content: {
          TextField("UserName", text: $viewModel.user)
        },
        footer: {
          Text(viewModel.usernameMessage)
        })

      Section(
        content: {
          SecureField("Password", text: $viewModel.password)
          SecureField("Password Check", text: $viewModel.passwordCheck)
        },
        header: {
          Text(viewModel.passwordHeaderMessage)
            .foregroundColor(.red)
        },
        footer: {
          Text(viewModel.passwordMessage)
            .foregroundColor(.red)
        }
      )

      Section {
        Button(
          action: { viewModel.pageSheetShow.toggle() },
          label: {
            Text("Sign Up")
          }
        ).disabled(!viewModel.validation)
      }
    }
    .fullScreenCover(isPresented: $viewModel.pageSheetShow) {
      WelcomeView(isShow: $viewModel.pageSheetShow)
        .interactiveDismissDisabled(true)
    }
  }
}

struct SignupView_Previews: PreviewProvider {
  static var previews: some View {
    SignupView()
  }
}

