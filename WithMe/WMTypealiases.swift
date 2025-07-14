//
//  Typealiases.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import Foundation

internal typealias JSON = [String: Any]

internal typealias Portable = Codable & Sendable & Hashable & Identifiable

internal typealias VoidCallback = () -> Void

internal typealias OCRData = [String]

internal typealias Caption = String

internal typealias Vector = [Float]
