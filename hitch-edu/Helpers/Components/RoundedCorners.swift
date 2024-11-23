//
//  RoundedCorners.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/22/24.
//

import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


//#Preview {
//    RoundedCorners()
//}
