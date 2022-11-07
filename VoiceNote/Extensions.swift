//
//  Extensions.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-17.
//

import Foundation
import SwiftUI

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    func getFileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func getFileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

extension Font {
//    static let mediumFont = Font.custom("Sans-Regular", size: Font.TextStyle.subheadline.size, relativeTo: .caption)
//    static let mediumSmallFont = Font.custom("Sans-Regular", size: Font.TextStyle.footnote.size, relativeTo: .caption)
//    static let smallFont = Font.custom("Sans-Regular", size: Font.TextStyle.caption.size, relativeTo: .caption)
//    static let verySmallFont = Font.custom("Sans-Regular", size: Font.TextStyle.caption2.size, relativeTo: .caption)
    
    // Bold
    static let btnBold = Font.custom("IBMPlexSansDevanagari-Bold", size: Font.TextStyle.title3.size, relativeTo: .caption)
    static let bold21 = Font.custom("IBMPlexSansDevanagari-Bold", size: Font.TextStyle.caption.size, relativeTo: .caption)
    static let bold34 = Font.custom("IBMPlexSansDevanagari-Bold", size: Font.TextStyle.title2.size, relativeTo: .caption)
    // Regular
    static let regular24 = Font.custom("IBMPlexSansDevanagari-Regular", size: Font.TextStyle.title3.size, relativeTo: .caption)
    static let regular21 = Font.custom("IBMPlexSansDevanagari-Regular", size: Font.TextStyle.caption.size, relativeTo: .caption)
    static let regular18 = Font.custom("IBMPlexSansDevanagari-Regular", size: Font.TextStyle.headline.size, relativeTo: .caption)
    
    // Light
    static let light16 = Font.custom("IBMPlexSansDevanagari-Light", size: Font.TextStyle.subheadline.size, relativeTo: .caption)
    static let light18 = Font.custom("IBMPlexSansDevanagari-Light", size: Font.TextStyle.headline.size, relativeTo: .caption)
    
}
extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 60
        case .title: return 48
        case .title2: return 34
        case .title3: return 24
        case .caption: return 21
        case .headline, .body: return 18
        case .subheadline, .callout: return 16
        case .footnote: return 14
       // case .caption: return 12
        case .caption2: return 10
        @unknown default:
            return 8
        }
    }
}
