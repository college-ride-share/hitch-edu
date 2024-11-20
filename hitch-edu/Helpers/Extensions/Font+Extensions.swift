//
//  Font+Extensions.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/19/24.
//

import SwiftUI

extension Font {
   
    
    /// Returns a custom font with a specific weight.
       static func customFont(name: String, size: CGFloat, weight: Weight = .regular) -> Font {
           Font.custom("\(name)-\(weight.name)", size: size)
       }
    
    // MARK: - Geist Custom Fonts
    static func geistBlack(size: CGFloat) -> Font {
        Font.custom("Geist-Black", size: size)
    }
    
    static func geistBold(size: CGFloat) -> Font {
        Font.custom("Geist-Bold", size: size)
    }
    
    static func geistExtraBold(size: CGFloat) -> Font {
        Font.custom("Geist-ExtraBold", size: size)
    }
    
    static func geistExtraLight(size: CGFloat) -> Font {
        Font.custom("Geist-ExtraLight", size: size)
    }
    
    static func geistLight(size: CGFloat) -> Font {
        Font.custom("Geist-Light", size: size)
    }
    
    static func geistMedium(size: CGFloat) -> Font {
        Font.custom("Geist-Medium", size: size)
    }
    
    static func geistRegular(size: CGFloat) -> Font {
        Font.custom("Geist-Regular", size: size)
    }
    
    static func geistSemiBold(size: CGFloat) -> Font {
        Font.custom("Geist-SemiBold", size: size)
    }
    
    static func geistThin(size: CGFloat) -> Font {
        Font.custom("Geist-Thin", size: size)
    }
    
    // MARK: - GeistMono Custom Font
    
    static func geistMonoBlack(size: CGFloat) -> Font {
        Font.custom("GeistMono-Black", size: size)
    }
    
    static func geistMonoBold(size: CGFloat) -> Font {
        Font.custom("GeistMono-Bold", size: size)
    }
    
    static func geistMonoLight(size: CGFloat) -> Font {
        Font.custom("GeistMono-Light", size: size)
    }
    
    static func geistMonoMedium(size: CGFloat) -> Font {
        Font.custom("GeistMono-Medium", size: size)
    }
    
    static func geistMonoRegular(size: CGFloat) -> Font {
        Font.custom("GeistMono-Regular", size: size)
    }
    
    static func geistMonoSemiBold(size: CGFloat) -> Font {
        Font.custom("GeistMono-SemiBold", size: size)
    }
    
    static func geistMonoThin(size: CGFloat) -> Font {
        Font.custom("GeistMono-Thin", size: size)
    }
    
    static func geistMonoUltraBlack(size: CGFloat) -> Font {
        Font.custom("GeistMono-UltraBlack", size: size)
    }
    
    static func geistMonoUltraLight(size: CGFloat) -> Font {
        Font.custom("GeistMono-UltraLight", size: size)
    }
}

// MARK: - Helper Extension for Font.Weight

private extension Font.Weight {
    var name: String {
        switch self {
        case .ultraLight: return "UltraLight"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "SemiBold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        default: return "Regular"
        }
    }
}
