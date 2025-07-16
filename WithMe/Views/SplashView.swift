//
//  SplashView.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import SwiftUI
import AwesomeNavigation

struct SplashView: View {
    @EnvironmentObject var navigation: AwesomeNavigation
    var body: some View {
        Image(.txtLogoWhiteExt)
            .resizable()
            .scaledToFit()
            .frame(width: 256)
            .padding(32.0)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SplashView()
}
