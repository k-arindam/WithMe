//
//  ContentView.swift
//  WithMe
//
//  Created by Arindam Karmakar on 03/07/25.
//

import SwiftUI
import AwesomeNavigation

struct ContentView: View {
    var body: some View {
        VStack {
            let config = ANConfig(initialRoute: WMRoutes.splash) { route in
                switch route {
                case .splash:
                    SplashView()
                case .login:
                    LoginView()
                case .home:
                    HomeView()
                }
            }
            
            ANApplication(with: config)
        }
        .padding(0.0)
    }
}

#Preview {
    ContentView()
}
