//
//  LoadingButton.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import SwiftUI

struct LoadingButton: View {
    let title: String
       let action: () -> Void
       let loading: Bool
       let buttonDisabled: Bool

       var body: some View {
           VStack {
               Button {
                   if !loading && !buttonDisabled {
                       action()
                   }
               } label: {
                   ZStack {
                       if loading {
                           ProgressView()
                               .progressViewStyle(CircularProgressViewStyle(tint: .white))
                               .frame(maxWidth: .infinity)
                       } else {
                           Text(title)
                               .frame(maxWidth: .infinity)
                               .font(.geistSemiBold(size: 18))
                       }
                   }
               }
               .padding()
               .buttonStyle(.borderless)
               .frame(maxWidth: .infinity)
               .background(buttonDisabled ? Color.gray : Color.blue)
               .cornerRadius(10)
               .foregroundStyle(.white)
               .disabled(buttonDisabled || loading)
               .opacity(buttonDisabled || loading ? 0.5 : 1)

           }
       }
}

#Preview {
    LoadingButton(
        title: "Continue",
        action: {
            print("Button tapped")
        },
        loading: false, // Set to true to simulate loading state in the preview
        buttonDisabled: false // Set to true to simulate the disabled state
    )
    .padding()
}

