//
//  SelectLocationView.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 20/01/2021.
//

import SwiftUI

struct SelectLocationView: View {
    @State var text: String?
    @Binding var show: Bool
    @State var weatherDetail: WeatherViewModel?
    @ObservedObject var store = CitiesStore()
    @State var location: Location?
    @State var showWeatherDetail = false
    
    
//
//    func searchCity(cityName: String?) {
//        store.getCities(cityName: cityName)
//    }
    
    var body: some View {
        let binding = Binding<String>(get: {
                    self.text ?? ""
                }, set: {
                    self.text = $0
                    store.getCities(cityName: $0)
                })
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        
        return VStack {
            VStack {
                Text("Enter city, zip code, or airport location")
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("", text: binding)
                    }
                    .frame(height: 32)
                    .padding(.horizontal, 8)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    Button(action: { show.toggle() }) {
                        Text("Cancel")
                    }
                }
            }
            .padding()
            .background(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            
            List(store.cities) { item in
                Button(action: {
                    self.location = store.convertCityToLocation(city: item)
                    showWeatherDetail.toggle()
                }, label: {
                    Text(item.name)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 32)
                        .padding(4)
                        .padding(.horizontal, 8)
                        .foregroundColor(.blue)
                })
                .sheet(isPresented: $showWeatherDetail, content: {
                    WeatherDetailView(show: $showWeatherDetail, location: $location, fromMainView: .constant(false))
                })
            }
            .id(UUID())
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(BackgroundBlurView(style: .systemMaterialDark))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SelectLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLocationView(show: .constant(true))
    }
}
