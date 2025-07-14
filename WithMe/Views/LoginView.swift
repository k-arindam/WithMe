//
//  LoginView.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Button {
                //
            } label: {
                HStack {
                    Text("Sign in with Apple")
                }
            }
            .glassButtonStyleWithFallback()
        }
    }
}

#Preview {
    LoginView()
}
