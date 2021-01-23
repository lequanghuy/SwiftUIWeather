//
//  ContentView.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 20/01/2021.
//

import SwiftUI

struct ContentView: View {
    @State var showLocationList = false
    var body: some View {
        ScrollView {
            ZStack {
                Color.black
                    .frame(width: screen.width, height: screen.height)
                VStack(spacing: 0.0) {
                    ForEach(0 ..< 5) { item in
                        LocationCell()
                    }
                    
                    HStack {
                        HStack {
                            Button(action: {}) {
                                Text("°C")
                            }
                            Text("/")
                            Button(action: {}) {
                                Text("°F")
                                    
                            }
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                        Spacer()
                        Image("the-weather-channel")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36, alignment: .center)
                            .background(Color.white)
                            .offset(x: -20)
                        Spacer()
                        Button(action: { showLocationList.toggle() }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .medium))
                            
                        }
                        .sheet(isPresented: $showLocationList, content: {
                            SelectLocationView(show: $showLocationList)
                        })
                    }
                    .padding()
                    Spacer()
                }
                
                
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LocationCell: View {
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8.0) {
                Text("21:31")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("Hà Nội")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            Spacer()
            Text("17°")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(16)
        .background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
    }
}


