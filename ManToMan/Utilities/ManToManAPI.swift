//
//  KyupagoAPI.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/28.
//



import Foundation
import Combine

class ManToManAPI {
    
    @Published var translated : TranslatedModel?
    @Published var initialText : String = ""
    @Published var langList: [String: String] = ["한글" : "ko", "영어": "en", "일본어": "ja", "중국어(간체)": "zh-cn"]
    
    static let instance = ManToManAPI()
    
    var cancellables = Set<AnyCancellable>()
    
    private init() {
        
    }
    
    func postData(text: String, selectedlang: String) {
        let endpoint = "https://port-0-kyupago-server-1luhct24lctgq9gx.gksl2.cloudtype.app/translate"
        let body = ["source": "ko", "target": langList[selectedlang], "text": text]

        guard let url = URL(string: endpoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accpet")

        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap(handleOutput)
            .decode(type: TranslatedModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error to download!!!", error)
                }
            } receiveValue: { [weak self] (translatedData) in
                print(translatedData)
                self?.translated = translatedData
            }
            .store(in: &cancellables)
    }
    
    func handleOutput(output : URLSession.DataTaskPublisher.Output) throws -> Data {
        
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300  else {
                  throw URLError(.badServerResponse)
              }
        return output.data
    }
}

