//
//  IconButton.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import SwiftUI

struct IconButton: View {
    var action: () -> Void
    var label: String
    var icon: IconType

    enum IconType {
        case system(name: String)
        case custom(imageName: String)
    }

    var body: some View {
        Button(action: action) {
            HStack {
                iconView
                    .frame(width: 20, height: 20)
                    .foregroundColor(.appTextPrimary)

                ZStack {
                    Text(label)
                        .font(.geistMedium(size: 15))
                        .foregroundColor(.appTextPrimary)
                }
                .frame(maxWidth: .infinity) // Centers the label
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.border, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var iconView: some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
        case .custom(let imageName):
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    IconButton(
        action: {
            // Example action
        },
        label: "Continue with email",
        icon: .system(name: "envelope")
    )
}
