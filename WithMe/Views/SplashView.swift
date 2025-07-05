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
        Image("TxtLogoWhiteExt")
            .resizable()
            .scaledToFit()
            .frame(width: 256)
            .padding(32.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .task { @MainActor in
                try? await Task.sleep(nanoseconds: 2_500_000_000)
                navigation.updateRoot(with: WMRoutes.home)
            }
    }
}

#Preview {
    SplashView()
}
