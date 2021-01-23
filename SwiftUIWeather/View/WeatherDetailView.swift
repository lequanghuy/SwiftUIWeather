//
//  WeatherDetailView.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import SwiftUI

struct WeatherDetailView: View {
    @Binding var show: Bool
    @Binding var location: Location?
    
    @ObservedObject var weatherStore = WeatherStore()
    
    var body: some View {
        weatherStore.getWeatherDetail(location: self.location)
        
        return VStack {
            ScrollView {
                //Present View
                VStack(spacing: 4.0) {
                    Text("Ha Noi")
                        .font(.title)
                    Text("Mostly Cloud")
                    Text("3°").font(.system(size: 60))
                }
                .offset(y: 32)
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                
                //Scroll hourly view
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8.0) {
                        ForEach(0 ..< 10) { item in
                            HourlyView()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                }
                
                //Group condition view
                HStack {
                    VStack {
//                        ConditionView(conditionName: .constant("Sunset"), conditionValue: .constant(String(weatherDetail!.sunset)))
//                        ConditionView(conditionName: .constant("Sunset"), conditionValue: .constant(String(weatherDetail!.sunset)))
                        ConditionView(conditionName: .constant("Sunset"), conditionValue: .constant(String(weatherStore.weather!.sunset)))
                    }
                    Spacer()
                    VStack {
//                        ConditionView(conditionName: .constant("Sunset"), conditionValue: .constant(String(weatherDetail!.sunset)))
//                        ConditionView(conditionName: .constant("Sunset"), conditionValue: .constant(String(weatherDetail!.sunset)))
                    }
                    .offset(x: -48)
                }
                .padding()
                .offset(y: 16)
                
                Spacer()
            }
            .background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
            .foregroundColor(.white)
            
            //MARK: - Bottom View
            BottomView()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(show: .constant(true), location: .constant(Location()))
    }
}

struct HourlyView: View {
    var body: some View {
        VStack(spacing: 4.0) {
            Text("04")
            Image(systemName: "cloud.drizzle.fill")
            Text("3°")
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
    var body: some View {
        HStack(alignment: .center) {
            Image("the-weather-channel")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24, alignment: .center)
                .background(Color.white)
            Spacer()
            Image(systemName: "list.bullet")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .offset(y: -4)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Color.black)
    }
}
