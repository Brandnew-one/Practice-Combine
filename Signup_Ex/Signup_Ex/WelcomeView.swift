//
//  WelcomeView.swift
//  Signup_Ex
//
//  Created by Bran on 2022/08/30.
//

import SwiftUI

struct WelcomeView: View {
  @Binding
  var isShow: Bool

  var body: some View {
    VStack {
      Text("Hello")

      Button(
        action: {
//          presentationMode.wrappedValue.dismiss()
          self.isShow.toggle()
        },
        label: {
          Text("Dismiss Button")
        }
      )
    }
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView(isShow: .constant(false))
  }
}

