//
//  LLM+WMEngine.swift
//  WithMe
//
//  Created by nuuuron on 15/07/25.
//

#if canImport(FoundationModels)
import FoundationModels
#endif

internal extension WMEngine {
    func initLLM() -> Void {
        if #available(iOS 26.0, *) {
            updateFMAvailability()
        } else {
            loadLocalLLM()
        }
    }
    
    func prompt(with entities: [WMEntity], for query: String, completion: @escaping ResultCallback<String>) -> Void {
        let input = buildLLMInput(with: entities, for: query)
        
        if #available(iOS 26.0, *) {
            promptFM(input, completion: completion)
        } else {
            promptLocalLLM(input)
        }
    }
    
    private func loadLocalLLM() -> Void {}
    
    private func promptLocalLLM(_ input: WMLLMInput) -> Void {}
    
    @available(iOS 26.0, *)
    private func updateFMAvailability() -> Void {
        let model = SystemLanguageModel.default
        self.llmAvailable = model.availability == .available
    }
    
    @available(iOS 26.0, *)
    private func promptFM(_ input: WMLLMInput, completion: @escaping ResultCallback<String>) -> Void {
        debugPrint("----->>> promptFM() Input: \(input.prompt)")
        
        Task {
            do {
                let session = LanguageModelSession(instructions: input.instructions)
                
                let resp = try await session.respond(to: input.prompt)
                completion(.success(resp.content))
            } catch {
                completion(.failure(error))
                debugPrint("----->>> promptFM() Error: \(error)")
            }
        }
    }
    
    private func buildLLMInput(with entities: [WMEntity], for query: String) -> WMLLMInput {
        let instructions: String = """
            You are WithMe, an intelligent assistant helping users retrieve useful information from their screenshots, which were stored using Siri or Shortcuts.
            
            For each screenshot, the app has stored:
                - OCR Text (text extracted from the image)
                - Caption (AI-generated description)
                - Timestamp
            
            Based on user queries, we retrieve the most semantically relevant screenshots via embedding search and present their context here.
            
            ---
            
            ## INSTRUCTIONS
            
            1. If relevant information exists in the context, use it to generate a helpful and accurate answer.
            2. You don't need to mention the screenshot name in your answer, but feel free to include the timestamp if it's relevant.
            3. If there is no relevant context or insufficient data, respond with:
               > "I couldn't find any relevant information from your screenshots to answer that. You might try rephrasing your question or take a new screenshot related to it."
            
            4. If the query is unrelated to screenshots (e.g., a general trivia or off-topic question), politely inform the user that this app only answers based on screenshot data.
            5. Never hallucinate or fabricate facts that aren't in the provided OCR or captions.
            6. Be concise, accurate, clear, and helpful in tone.
            """
        
        var context = String()
        for entity in entities {
            let formattedOCR = entity.ocrData.joined(separator: "\n  ")
            
            // [[SCREENSHOT: \(entity.fileName)]]
            
            context += """
            - OCR Text: 
              \(formattedOCR)
            - Caption: \(entity.caption)
            - Time: \(entity.timestamp.timeIntervalSince1970)
            """
        }
        
        let prompt: String = """
            ## CONTEXT
            
            \(context)
            
            ---
            
            ## TASK
            
            Based on the provided context from the screenshots, answer the user’s question:
            
            **User's Question:** "\(query)"
            
            ---
            
            ## ANSWER
            
            """
        
        return WMLLMInput(
            instructions: instructions,
            prompt: prompt
        )
    }
}
