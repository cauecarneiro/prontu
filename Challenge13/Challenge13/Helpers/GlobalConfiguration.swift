//
//  GlobalConfiguration.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation
import SwiftUI

enum GlobalConfiguration {
    // MARK: - Colors
    static var primaryGreen: Color { Color(.primaryGreen) }
    static var primaryBlue: Color { Color(.primaryBlue) }

    // MARK: - Spacing & Radius
    static var normalSpacing: CGFloat { 16 }
    static var normalCornerRadius: CGFloat { 12 }

    // MARK: - Calendar
    static var calendarChevronSize: CGFloat { 26 }
    static var calendarTapTargetSize: CGFloat { 44 }
    static var calendarWeekPagerHeight: CGFloat { 52 }
    static var calendarDayCellSize: CGFloat { 40 }
    static var calendarDotSize: CGFloat { 5 }
    static var calendarSpringResponse: Double { 0.37 }
    static var calendarSpringDamping: Double { 0.85 }
    static var calendarTitleScaleFactor: CGFloat { 0.78 }
    static var calendarPaddingTop: CGFloat { 12 }
    static var calendarPaddingBottom: CGFloat { 8 }
    static var calendarHeaderSpacing: CGFloat { 12 }
    static var calendarDayCellInnerSpacing: CGFloat { 4 }
    static var calendarWeekdayFontSize: CGFloat { 12 }
}
