//
//  SampleView.swift
//  MVVM_Practice
//
//  Created by Bran on 2022/10/25.
//

import SwiftUI

struct SampleView: View {
  var body: some View {
    VStack(spacing: 30) {
      userButtonInputSection

      userKeyboardInputSection
    }
  }
}

extension SampleView {
  var userButtonInputSection: some View {
    VStack {
      Text("This is Button Action")
        .font(.title)

      HStack(spacing: 18) {
        Button(
          action: {},
          label: {
            Text("-")
              .font(.title)
          }
        )

        Text("12")
          .font(.largeTitle)

        Button(
          action: {},
          label: {
            Text("+")
              .font(.title)
          }
        )
      }
    }
    .padding()
    .border(.black, width: 2)
  }

  var userKeyboardInputSection: some View {
    VStack {
      Text("This is Keyboard Action")
        .font(.title)

      TextField("Enter Anything", text: .constant(""))
        .textFieldStyle(.roundedBorder)
        .frame(width: 300)

      Text("Anything")
    }
    .padding()
    .border(.black, width: 2)
  }

  // TODO: - Toggle Action

}

struct SampleView_Previews: PreviewProvider {
  static var previews: some View {
    SampleView()
  }
}
