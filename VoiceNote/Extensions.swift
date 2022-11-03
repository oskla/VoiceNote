//
//  Extensions.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-17.
//
import SwiftUI


import Foundation

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
    static let bold = Font.custom("IBMPlexSansDevanagari-Bold", size: 18)
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 60
        case .title: return 48
        case .title2: return 34
        case .title3: return 24
        case .headline, .body: return 18
        case .subheadline, .callout: return 16
        case .footnote: return 14
        case .caption: return 12
        case .caption2: return 10
        @unknown default:
            return 8
        }
    }
}


