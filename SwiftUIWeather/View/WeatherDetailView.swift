//
//  WeatherDetailView.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import SwiftUI
import RealmSwift

struct WeatherDetailView: View {
    @Binding var show: Bool
    @Binding var location: Location?
    @State var showProgress: Bool = true
    @Binding var fromMainView: Bool
    
    var didSaveLocation: (() -> Void)?
    
    @ObservedObject var weatherStore = WeatherStore.shared
    
    var body: some View {
        return VStack {
            if let weather = weatherStore.weather {
                ScrollView {
                    HStack {
                        if !weatherStore.isHiddenCancel{
                            Button(action: { show.toggle() }, label: {
                                Text("Cancel")
                            })
                        }
                        
                        Spacer()
                        
                        if !weatherStore.isHiddenAdd {
                            Button(action: {
                                weatherStore.saveLocation(location: location, weather: weather)
//                                show.toggle()
                                self.didSaveLocation?()
                            }, label: {
                                Text("Add")
                            })
                        }
                    }
                    .padding()
                    //MARK: - Present View
                    VStack(spacing: 4.0) {
                        Text("\(weather.cityName)")
                            .font(.title)
                        Text(weather.description)
                        Text(String(format: "%.0f", weather.temp) + "°").font(.system(size: 60))
                    }
                    .offset(y: 32)
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    
                    //Scroll hourly view
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8.0) {
                            ForEach(weather.hourly) { item in
                                HourlyView(
                                    dt: .constant(item.dt.timeStampToString(format: "HH", timezone: weather.timeZone)),
                                    icon: .constant(item.weather[0].icon),
                                    temp: .constant("\(String(format: "%.0f", item.temp))°")
                                )
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                    }
                    
                    //Group condition view
                    HStack {
                        VStack(alignment: .leading, spacing: 16.0) {
                            ConditionView(conditionName: .constant("Sunrise"), conditionValue: .constant(weather.sunrise.timeStampToString(format: "HH:mm", timezone: weather.timeZone)))
                            ConditionView(conditionName: .constant("Humidity"), conditionValue: .constant("\(weather.humidity) %"))
                            ConditionView(conditionName: .constant("Feel"), conditionValue: .constant(String(format: "%.0f", weather.feels_like) + "°"))
                            ConditionView(conditionName: .constant("Visibility"), conditionValue: .constant("\(String(format: "%.1f", Double(weather.visibility) / Double(1000))) km"))
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 16.0) {
                            ConditionView(conditionName: .constant("Sunset"), conditionValue: .constant(weather.sunset.timeStampToString(format: "HH:mm", timezone: weather.timeZone)))
                            ConditionView(conditionName: .constant("Wind"), conditionValue: .constant("\(weather.wind_speed) km/h"))
                            ConditionView(conditionName: .constant("Pressure"), conditionValue: .constant("\(weather.pressure) hPa"))
                            ConditionView(conditionName: .constant("UV"), conditionValue: .constant("\(weather.uvi)"))
                        }
                        .offset(x: -48)
                    }
                    .padding()
                    .offset(y: 16)
                    
                    Spacer()
                }
                .background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                .foregroundColor(.white)
            }
            else {
                ScrollView {
                    VStack(spacing: 4.0) {
                        Text("--")
                            .font(.title)
                        Text("--")
                        Text(String("--")).font(.system(size: 60))
                    }
                    .offset(y: 32)
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.horizontal, 8)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 16.0) {
                            ConditionView(conditionName: .constant("Sunrise"), conditionValue: .constant("--"))
                            ConditionView(conditionName: .constant("Humidity"), conditionValue: .constant("--"))
                            ConditionView(conditionName: .constant("Feel"), conditionValue: .constant(String("--")))
                            ConditionView(conditionName: .constant("Visibility"), conditionValue: .constant("--"))
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 16.0) {
                            ConditionView(conditionName: .constant("Sunset"), conditionValue: .constant("--"))
                            ConditionView(conditionName: .constant("Wind"), conditionValue: .constant("--"))
                            ConditionView(conditionName: .constant("Pressure"), conditionValue: .constant("--"))
                            ConditionView(conditionName: .constant("UV"), conditionValue: .constant("--"))
                        }
                        .offset(x: -48)
                    }
                    .padding()
                    .offset(y: 16)
                    Spacer()
                    
                }
                .background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                .foregroundColor(.white)
            }
            //MARK: - Bottom View
            BottomView(show: $show)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            weatherStore.getWeatherDetail(location: self.location)
            weatherStore.checkHiddenButton(location: location, fromMainView: fromMainView)
        })
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(show: .constant(true), location: .constant(Location()), fromMainView: .constant(true))
    }
}

struct HourlyView: View {
    @Binding var dt: String
    @Binding var icon: String
    @Binding var temp: String
    var body: some View {
        VStack(spacing: 4.0) {
            Text(dt)
            Image(icon).resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
            Text(temp)
        }
        .frame(width: 40)
    }
}

struct ConditionView: View {
    @Binding var conditionName: String
    @Binding var conditionValue: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(conditionName.uppercased())
                .font(.title2)
            Text(conditionValue).font(.system(size: 30))
        }
    }
}

struct BottomView: View {
    @Binding var show: Bool
    var body: some View {
        HStack(alignment: .center) {
            Image("the-weather-channel")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24, alignment: .center)
                .background(Color.white)
            Spacer()
            Button(action: {
                WeatherStore.shared.selectedLocation = nil
                    show.toggle()
            }) {
                Image(systemName: "list.bullet")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .offset(y: -4)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Color.black)
    }
}
