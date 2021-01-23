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
