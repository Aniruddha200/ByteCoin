//  ApiManger.swift
//  ByteCoin

import Foundation

protocol ExchangeRateDelegate {
    func currentRate(_ apiManager: ApiManger, _ rate: Double)
}

struct ApiManger {
    
    var exchangerDelegate: ExchangeRateDelegate?
    
    let baseURL: String?
    let apiKey: String?
    let fiatCurrency: String?
    init(base: String, currency: String, key: String) {
        baseURL = base;apiKey = key;fiatCurrency = currency;
    }
    
    func apiCall(){
        let url = URL(string: baseURL!+fiatCurrency!+apiKey!)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
        task.resume()
    }
    
    func parseJson(_ data: Data) -> Double?{
        do{
            let json = JSONDecoder()
            let response = try json.decode(responseStruct.self, from: data)
            return response.rate
        }catch{
            print(error)
            return nil
        }
        }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if let safeData = data {
            if let rate = parseJson(safeData) {
            exchangerDelegate?.currentRate(self, rate)
            }
        }
    
    }
}

struct responseStruct: Decodable {
    let rate: Double
}
