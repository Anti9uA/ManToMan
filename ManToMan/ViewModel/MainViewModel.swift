//
//  MainViewModel.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/27.
//

import Combine
import Foundation
import Speech
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var translated: TranslatedModel?
    @Published var defaultString = DefaultStringModel()
    @Published var langModel = LangListModel()
    @Published var mainViewState: MainViewState = .idle
    @Published var buttonTappedState: ButtonTappedState = .noneTapped
    @Published var text : String = ""
    @Published var debouncedText: String = ""
    @Published var langList: [Lang] = [
        Lang(key: "langlist_0", displayName: NSLocalizedString("langlist_0", comment: "")),
        Lang(key: "langlist_1", displayName: NSLocalizedString("langlist_1", comment: "")),
        Lang(key: "langlist_2", displayName: NSLocalizedString("langlist_2", comment: ""))
    ]
    
    let manToManAPI = ManToManAPI.instance
    
    var audioEngines = [String: AVAudioEngine]()
    var recognitionRequests = [String: SFSpeechAudioBufferRecognitionRequest]()
    var recognitionTasks = [String: SFSpeechRecognitionTask?]()
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        addKyuSubscriber()
        $text
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &cancellable)
        
    }
    
    private func addKyuSubscriber() {
        manToManAPI.$translated
            .sink { [weak self] (receiveModel) in
                DispatchQueue.main.async { [weak self] in
                    self?.translated = receiveModel
                }
            }
            .store(in: &cancellable)
    }
    
    func getAudioEngine(key: String) -> AVAudioEngine {
        guard let audioEngine = audioEngines[key] else {
            let newAudioEngine = AVAudioEngine()
            audioEngines[key] = newAudioEngine
            return newAudioEngine
        }
        return audioEngine
    }
    
    func startRecording(selectedLang: String, for key: String) {
        let otherKey = key == "myAudioEngine" ? "partnerAudioEngine" : "myAudioEngine"
        let otherAudioEngine = getAudioEngine(key: otherKey)
        
        if otherAudioEngine.isRunning {
            otherAudioEngine.stop()
            otherAudioEngine.inputNode.removeTap(onBus: 0)
        }
        
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: langModel.langList[selectedLang]!))!
        
        guard speechRecognizer.isAvailable else {
            print("Speech Recognition is not available")
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let audioEngine = getAudioEngine(key: key)
            let inputNode = audioEngine.inputNode
            
            recognitionRequests[key] = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequests[key] else { fatalError("SFSpeechAudioBufferRecognitionRequest 객체 생성 오류") }
            recognitionRequest.shouldReportPartialResults = true
            
            if #available(iOS 13, *) {
                recognitionRequest.requiresOnDeviceRecognition = false
            }
            
            recognitionTasks[key] = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                var isFinal = false
                
                if let result = result {
                    self.text = result.bestTranscription.formattedString
                    isFinal = result.isFinal
                    print("Text \(result.bestTranscription.formattedString)")
                }
                
                if error != nil || isFinal {
                    self.stopRecording(for: key)
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequests[key]?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            self.text = ""
        } catch let error as NSError {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }
    
    
    func stopRecording(for key: String) {
        if let audioEngine = audioEngines[key], audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequests[key]?.endAudio()
            recognitionTasks[key]??.finish()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
    
    
    func shouldUseCustomFrame() -> Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let horizontalSizeClass = windowScene.windows.first?.rootViewController?.traitCollection.horizontalSizeClass else {
            return false
        }
        
        if horizontalSizeClass == .compact {
            if UIScreen.main.bounds.height == 568 { // iPhone SE
                return true
            } else if UIScreen.main.bounds.height == 667 { // iPod 7
                return true
            }
        }
        
        return false
    }
}
