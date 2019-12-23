//
//  CacheManager.swift
//  GoogleBooks
//
//  
//

import Foundation
typealias DataHandler = (Data?) -> Void
let cache = CacheManager.shared

final class CacheManager {
    private let cache = NSCache<NSString, NSData>()
    
    static let shared = CacheManager()
    private init() {}
    
    func downloadFrom(endpoint: String, completion: @escaping DataHandler) {
        if let data = cache.object(forKey: endpoint as NSString) {
            completion(data as Data)
            return
        }
        
        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                print("Bad Task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = dat {
                self.cache.setObject(data as NSData, forKey: endpoint as NSString)
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
            }.resume()
    }
}
