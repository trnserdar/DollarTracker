//
//  NetworkManager.swift
//  DollarTracker
//
//  Created by SERDAR TURAN on 24.01.2021.
//

import Foundation

struct NetworkConstants {
    static var baseURL = "https://openexchangerates.org/api"
}

protocol NetworkManagerProtocol {
    func getCurrencyTypes(completion: @escaping (_ currencyTypes: [String: String]?) -> Void)
    func getLatest(apiKey: String, selectedCurrency: String, completion: @escaping (_ latest: [String: Any]?) -> Void)
}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class NetworkManager: NetworkManagerProtocol {
    
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func getCurrencyTypes(completion: @escaping (_ currencyTypes: [String: String]?) -> Void) {
        let url = URL(string: "\(NetworkConstants.baseURL)/currencies.json")!
        urlSession.dataTask(with: url) { (data, response, error) in

            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                completion(dict)
            } catch {
                completion(nil)
            }
            
        }.resume()
    }

    func getLatest(apiKey: String, selectedCurrency: String, completion: @escaping (_ latest: [String: Any]?) -> Void) {
        guard let url = URL(string: "\(NetworkConstants.baseURL)/latest.json?app_id=\(apiKey)") else {
            completion(nil)
            return
        }
        urlSession.dataTask(with: url) { (data, response, error) in

            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                var latest: [String: Any] = [:]
                if let dict = dict {
                    
                    if let timestamp = dict["timestamp"] as? Int {
                        latest["timestamp"] = timestamp
                    }
                    
                    if let rates = dict["rates"] as? [String: Double],
                       let selectedCurrencyRate = rates[selectedCurrency] {
                        latest[selectedCurrency] = selectedCurrencyRate
                    }
                }
                
                completion(latest)
            } catch {
                completion(nil)
            }
            
        }.resume()
    }
    
    
}
