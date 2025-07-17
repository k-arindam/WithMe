//
//  LLM+WMEngine.swift
//  WithMe
//
//  Created by nuuuron on 15/07/25.
//

#if canImport(FoundationModels)
import FoundationModels
#endif

//import LLM
import Foundation
import LocalLLMClient
import LocalLLMClientLlama

internal extension WMEngine {
    func initLLM() throws -> Void {
        if #available(iOS 26.0, *), foundationBackend {
            updateFMAvailability()
        } else {
            loadLocalLLM()
        }
    }
    
    func prompt(with entities: [WMEntity], for query: String, completion: @escaping ResultCallback<String>) -> Void {
        let input = buildLLMInput(with: entities, for: query)
        
        if #available(iOS 26.0, *), foundationBackend {
            promptFM(input, completion: completion)
        } else {
            promptLocalLLM(input, completion: completion)
        }
    }
    
    private func loadLocalLLM() -> Void {
//        let modelURL = Bundle.main.url(forResource: "gemma-3-4b-it-q4_0", withExtension: "gguf")!
//        self.llmModel = LLM(
//            from: modelURL,
//            template: .gemma,
//            topK: 40,
//            topP: 0.9,
//            temp: 0.7,
//            maxTokenCount: 4096
//        )
        Task {
            do {
//                let modelURL = Bundle.main.url(forResource: "gemma-3-4b-it-Q8_0", withExtension: "gguf")!
//                self.llmModel = try await LocalLLMClient.llama(
//                    url: modelURL,
//                    parameter: .init(
//                        temperature: 0.7,
//                        topK: 40,
//                        topP: 0.9
//                    )
//                )
                let model = LLMSession.DownloadModel.llama(
                    id: "ggml-org/gemma-3-4b-it-GGUF",
                    model: "gemma-3-4b-it-Q4_K_M.gguf",
//                    model: "gemma-3-4b-it-Q8_0.gguf",
//                    mmproj: "mmproj-model-f16.gguf",
                    parameter: .init(
                        temperature: 0.7,
                        topK: 40,
                        topP: 0.9
                    )
                )
                
                try await model.downloadModel { progress in
                    debugPrint("----->>> loadLocalLLM() Progress: \(progress) !!!")
                }
                
                self.llmModel = model
            } catch {
                debugPrint("----->>> loadLocalLLM() Error: \(error) !!!")
            }
        }
    }
    
    private func promptLocalLLM(_ input: WMLLMInput, completion: @escaping ResultCallback<String>) -> Void {
        guard let llmModel else {
            completion(.failure(WMError.modelUnavailable))
            return
        }
        
//        Task { @MainActor in
//            let input = llmModel.preprocess("Write a joke", [])
//            let output = await llmModel.getCompletion(from: input)
//            completion(.success(output))
//        }
        
        Task {
            do {
                let session = LLMSession(model: llmModel)
                let response = try await session.respond(to: input.join())
//                let response = try await llmModel.generateText(from: input.join())
                
                completion(.success(response))
            } catch {
                debugPrint("----->>> promptLocalLLM() Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
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
            
            1. If relevant information exists in the context, use it to generate a helpful and accurate answer. Visual characteristics (like color or layout) may be indirectly represented in the caption or text — interpret them accordingly.
            2. You don't need to mention the screenshot name in your answer, but feel free to include the timestamp if it's relevant.
            3. If none of the screenshots appear directly relevant, try to answer the question in a general or helpful way. Clearly inform the user that the answer is not based on their screenshots.
            4. If the question is unrelated to screenshot content (e.g., trivia, advice, general knowledge), provide a helpful answer if possible.
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
