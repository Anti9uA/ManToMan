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
    @Published var debouncedText: String = ""
    @Published var langList: [String: String] = ["한글" : "ko-KR", "영어": "en-US", "일본어": "ja-JP", "중국어(간체)": "zh"]
    @Published var idle: [String: String] = ["영어" : "Please wait.. ", "일본어" : "待ってください。", "중국어(간체)" : "请等着"]
    @Published var pleaseSpeak: [String: String] = ["영어" : "Please speak..", "일본어" : "話してください。", "중국어(간체)" : "请说"]
    @Published var pleaseWait: [String: String] = ["영어" : "Partner speaking..", "일본어" : "相手が言っています。", "중국어(간체)" : "对方正在说话。"]
    
    let manToManAPI = ManToManAPI.instance
    
    // let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    
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
                DispatchQueue.main.async {
                    self?.translated = receiveModel
                }
            }
            .store(in: &cancellable)
    }
    
    func startRecording(selectedLang: String, flipSpeaker: Bool) throws {
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: langList[selectedLang]!))!
        
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
