//
//  RootView.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 20/01/2021.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        ZStack {
            ContentView()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

let screen = UIScreen.main.bounds

struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get { self[ShowingSheetKey.self] }
        set { self[ShowingSheetKey.self] = newValue }
    }
}
