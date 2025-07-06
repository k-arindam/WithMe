//
//  ShareImageIntent.swift
//  WithMe
//
//  Created by Arindam Karmakar on 03/07/25.
//

import Foundation
import AppIntents

struct ShareImageIntent: AppIntent {
    static var title: LocalizedStringResource = "Share Image WithMe"
    static var description: IntentDescription? = "Share image WithMe to process and store it's context!"
    
    @available(iOS 26.0, *)
    static var supportedModes: IntentModes = .foreground(.immediate)
    static var openAppWhenRun: Bool = true
    
    @Parameter(
        description: "Input Image",
        supportedContentTypes: [.image],
        inputConnectionBehavior: .connectToPreviousIntentResult
    )
    var image: IntentFile
    
    @Dependency(
        key: WMConstants.dataControllerKey
    )
    var dataController: WMDataController
    
    func perform() async throws -> some IntentResult {
        if image.fileURL?.startAccessingSecurityScopedResource() ?? false {
            await dataController.handle(image: image.data)
        }
        
        return .result()
    }
}
