//
//  LLM+WMEngine.swift
//  WithMe
//
//  Created by nuuuron on 15/07/25.
//

#if canImport(FoundationModels)
import FoundationModels
#endif

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
//        let modelURL = Bundle.main.url(forResource: "llama-3.2-3b-instruct-q4_k_m", withExtension: "gguf")!
//        let model = LLM(
//            from: modelURL,
//            template: .llama(llmInstructions),
            //            topK: 40,
            //            topP: 0.9,
            //            temp: 0.7,
            //            maxTokenCount: 4096
//        )
        
//        model?.historyLimit = 0
//        
//        self.llmModel = model
        
                Task {
                    do {
                        let modelURL = Bundle.main.url(forResource: "llama-3.2-3b-instruct-q8_0", withExtension: "gguf")!
                        self.llmClient = try await LocalLLMClient.llama(
                            url: modelURL,
                            parameter: .init(
                                temperature: 0.7,
                                topK: 40,
                                topP: 0.9
                            )
                        )
//                        let model = LLMSession.DownloadModel.llama(
//                            id: "ggml-org/gemma-3-4b-it-GGUF",
//                            model: "gemma-3-4b-it-Q4_K_M.gguf",
//        //                    model: "gemma-3-4b-it-Q8_0.gguf",
//        //                    mmproj: "mmproj-model-f16.gguf",
//                            parameter: .init(
//                                temperature: 0.7,
//                                topK: 40,
//                                topP: 0.9
//                            )
//                        )
//        
//                        try await model.downloadModel { progress in
//                            debugPrint("----->>> loadLocalLLM() Progress: \(progress) !!!")
//                        }
        
//                        self.llmModel = model
                    } catch {
                        debugPrint("----->>> loadLocalLLM() Error: \(error) !!!")
                    }
                }
    }
    
    private func promptLocalLLM(_ input: WMLLMInput, completion: @escaping ResultCallback<String>) -> Void {
        guard let llmClient else {
            completion(.failure(WMError.modelUnavailable))
            return
        }
        
//        Task {
//            let input = llmModel.preprocess(input.prompt, [])
////            let output = await llmModel.getCompletion(from: input)
//            
//            var output = String()
//            
//            await llmModel.respond(to: input) { stream in
//                for await chunk in stream {
//                    output += chunk
//                }
//                return output
//            }
//            
//            completion(.success(output.trimmingCharacters(in: .whitespacesAndNewlines)))
//        }
        
                Task {
                    do {
//                        let session = LLMSession(model: llmModel)
//                        let response = try await session.respond(to: input.join())
                        let response = try await llmClient.generateText(from: input.join())
        
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
            
            Based on the provided context from the screenshots, answer my question without extra commentary. Remember you are helping me and be quirky:
            
            **My Question:** "\(query)"
            
            ---
            
            ## ANSWER
            
            """
        
        return WMLLMInput(
            instructions: llmInstructions,
            prompt: prompt
        )
    }
    
    private var llmInstructions: String {
                    """
                    You are WithMe, an intelligent assistant helping me retrieve useful information from my screenshots, which were stored using Siri or Shortcuts.
                    
                    For each screenshot, the app has stored:
                        - OCR Text (text extracted from the image)
                        - Caption (AI-generated description)
                        - Timestamp
                    
                    Based on my queries, the WithMe app retrieve the most semantically relevant screenshots via embedding search and present their context here.
                    
                    ---
                    
                    ## INSTRUCTIONS
                    
                    1. If relevant information exists in the context, use it to generate a helpful and accurate answer. Visual characteristics (like color or layout) may be indirectly represented in the caption or text — interpret them accordingly.
                    2. You don't need to mention the screenshot name in your answer, but feel free to include the timestamp if it's relevant.
                    3. If none of the screenshots appear directly relevant, try to answer the question in a general or helpful way. Clearly inform me that the answer is not based on my screenshots.
                    4. If the question is unrelated to screenshot content (e.g., trivia, advice, general knowledge), provide a helpful answer if possible.
                    5. Never hallucinate or fabricate facts that aren't in the provided OCR or captions.
                    6. Be concise, accurate, clear, and helpful in tone.
                    """
    }
}
