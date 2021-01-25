//
//  ContentView.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 20/01/2021.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State var showLocationList = false
    @ObservedObject var weatherStore = WeatherStore()
    
    var body: some View {
        return ScrollView {
            ZStack {
                Color.black
                    .frame(width: screen.width, height: screen.height)
                VStack(spacing: 0.0) {
                    LocationCell(dt: .constant("a"), temp: .constant("a"), cityName: .constant("a"))
                    ForEach(weatherStore.currentWeatherViewModel) { item in
                        LocationCell(dt: .constant(item.dt), temp: .constant(item.temp), cityName: .constant(item.name!))
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
        .onAppear(perform: {

        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LocationCell: View {
    @Binding var dt: String
    @Binding var temp: String
    @Binding var cityName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8.0) {
                Text(dt)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(cityName)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            Spacer()
            Text(temp)
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(16)
        .background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
    }
}


