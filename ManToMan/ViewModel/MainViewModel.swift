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
    @Published var text : String = ""
    @Published var debouncedText: String = ""
    
    let manToManAPI = ManToManAPI.instance
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    var recognitionTask: SFSpeechRecognitionTask?
    
    let audioEngine = AVAudioEngine()
    
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
    
    
    func startRecording(selectedLang: String) {
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: langModel.langList[selectedLang]!))!
        
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        guard speechRecognizer.isAvailable else {
            print("Speech Recognition is not available")
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = audioEngine.inputNode
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { fatalError("SFSpeechAudioBufferRecognitionRequest 객체 생성 오류") }
            recognitionRequest.shouldReportPartialResults = true
            
            if #available(iOS 13, *) {
                recognitionRequest.requiresOnDeviceRecognition = false
            }
            
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                var isFinal = false
                
                if let result = result {
                    self.text = result.bestTranscription.formattedString
                    isFinal = result.isFinal
                    print("Text \(result.bestTranscription.formattedString)")
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            self.text = ""
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }
    
    func requestSpeechAuthorization(completion: @escaping (Bool) -> Void) {
        // Request Authorization
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                    case .authorized:
                        completion(true)
                    case .denied:
                        completion(false)
                    case .restricted:
                        completion(false)
                    case .notDetermined:
                        completion(false)
                    @unknown default:
                        completion(false)
                }
            }
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
