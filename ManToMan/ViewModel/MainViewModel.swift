//
//  MainViewModel.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/27.
//

import Combine
import Foundation
import Speech

class MainViewModel: ObservableObject {
    @Published var translated: TranslatedModel?
    @Published var text : String = ""
    
    let manToManAPI = ManToManAPI.instance
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    var recognitionTask: SFSpeechRecognitionTask?
    
    let audioEngine = AVAudioEngine()
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        addKyuSubscriber()
    }
    
    private func addKyuSubscriber() {
        manToManAPI.$translated
            .sink { [weak self] (receiveModel) in
                DispatchQueue.main.async {
                    self?.translated = receiveModel
                }
            }
            .store(in: &cancellable)
    }
    
    func startRecording() throws {
        
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
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
    }
}
