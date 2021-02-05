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
    @ObservedObject var weatherStore = WeatherStore.shared
    @State var active = false
    @State var items: [CurrentWeatherViewModel] = []
    
    var body: some View {
        UITableView.appearance().backgroundColor = .black
        return ZStack {
            Color.black
                .frame(width: screen.width, height: screen.height)
            if active {
                WeatherDetailView(
                    show: $active,
                    location: .constant(weatherStore.selectedLocation),
                    fromMainView: .constant(true)
                )
                    .frame(width: screen.width, height: screen.height)
                    .opacity(active ? 1 : 0)
            }
            else {
                VStack(spacing: 0.0) {
                    List {
                        ForEach(items, id: \CurrentWeatherViewModel.id) { item in
                            GeometryReader { geo in
                                LocationCell(dt: .constant(item.dt),
                                             temp: .constant(item.temp),
                                             cityName: .constant(item.name!),
                                             onTapped: {
                                                self.weatherStore.selectLocation(with: item.id)
                                             }
                                )
                            }
                            .offset(x: -20)
                            .frame(width: screen.width)
                            .frame(height: 63)
                            .listRowBackground(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                            
                        }
                        .onDelete { index in
                            weatherStore.deleteLocation(index: index)
                        }
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
                                .environment(\.showingSheet, self.$showLocationList)
                        })
                    }
                    .padding()
                    .background(Color.black)
                    Spacer()
                }
                .opacity(active ? 0 : 1)
                .onReceive(self.weatherStore.$currentWeatherViewModel, perform: { newItems in
                    self.items = newItems
                })
                .onReceive(self.weatherStore.$selectedLocation, perform: { location in
                    self.active = location != nil
                })
            }
        }
        .animation(.easeOut(duration: 0.4))
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
    
    var onTapped: (() -> Void)?

    var body: some View {
        HStack(spacing: 0)  {
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
        .padding(8)
        .background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
        .onTapGesture(perform: {
            self.onTapped?()
        })
    }
}






