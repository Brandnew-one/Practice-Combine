//
//  SampleView.swift
//  MVVM_Practice
//
//  Created by Bran on 2022/10/25.
//

import SwiftUI

struct SampleView: ViewType {
  @StateObject
  var viewModel = SampleViewModel()

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
          action: { viewModel.action(.minusButtonTapped) },
          label: {
            Text("-")
              .font(.title)
          }
        )

        Text("\(viewModel.output.resultNumber)")
          .font(.largeTitle)

        Button(
          action: { viewModel.action(.plusButtonTapped) },
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

      TextField("Enter Anything", text: $viewModel.input.textFieldString)
        .textFieldStyle(.roundedBorder)
        .frame(width: 300)


      Text(viewModel.output.resultText)
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
