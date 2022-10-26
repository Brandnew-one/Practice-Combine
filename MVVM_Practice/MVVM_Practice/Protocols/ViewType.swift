//
//  ViewType.swift
//  MVVM_Practice
//
//  Created by Bran on 2022/10/25.
//

import Foundation
import SwiftUI

protocol ViewType: View {
  associatedtype ViewModel: ViewModelType
  var viewModel: ViewModel { get } // StateObject
}
