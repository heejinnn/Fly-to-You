//
//  Font.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import SwiftUI

extension Font {
    enum PretendardWeight {
        case black
        case bold
        case heavy
        case ultraLight
        case light
        case medium
        case regular
        case semibold
        case thin
        
        var value: String {
            switch self {
            case .black:
                return "Black"
            case .bold:
                return "Bold"
            case .heavy:
                return "ExtraBold"
            case .ultraLight:
                return "ExtraLight"
            case .light:
                return "Light"
            case .medium:
                return "Medium"
            case .regular:
                return "Regular"
            case .semibold:
                return "SemiBold"
            case .thin:
                return "Thin"
            }
        }
    }

    static func pretendard(_ weight: PretendardWeight, size fontSize: CGFloat) -> Font {
        let familyName = "Pretendard"
        let weightString = weight.value

        return Font.custom("\(familyName)-\(weightString)", size: fontSize)
    }
    
    static func italiana(size fontSize: CGFloat) -> Font {
        let familyName = "Italiana"
        let weightString = "Regular"

        return Font.custom("\(familyName)-\(weightString)", size: fontSize)
    }
    
    static func gaRamYeonGgoc(size fontSize: CGFloat) -> Font {
        let familyName = "NanumGaRamYeonGgoc"

        return Font.custom("\(familyName)", size: fontSize)
    }
}
