//
//  Typealiases.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import Foundation

internal typealias JSON = [String: Any]

internal typealias PortableWithoutID = Codable & Sendable & Hashable

internal typealias Portable = PortableWithoutID & Identifiable

internal typealias VoidCallback = @Sendable () -> Void

internal typealias StringCallback = @Sendable (String) -> Void

internal typealias ResultCallback<T> = @Sendable (Result<T, Error>) -> Void

internal typealias OCRData = [String]

internal typealias Caption = String

internal typealias Vector = [Float]
