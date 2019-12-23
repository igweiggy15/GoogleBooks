//
//  BookService.swift
//  GoogleBooks
//
//
//

import Foundation

typealias BookHandler = ([Book]) -> Void

final class BookService {
    
    static let shared = BookService()
    private init() {}
    
    
    func getBooks(for search: String, completion: @escaping BookHandler) {
        
        guard let url = BookAPI( search: search).getURL else {
            completion([])
            return //exit the scope
        }
        
        //API Request for the URLSessions and data task
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            
            if let error = err {
                print("Bad Data Task: \(error.localizedDescription)")
                completion([])
                return
            }
            
            if let data = dat {
                
                do {
                    let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                    let books = bookResponse.books
                    completion(books)
                } catch {
                    print("Couldn't Serialize Object: \(error.localizedDescription)")
                    completion([])
                    return
                }
            }
            
            }.resume()
    }
    
}
