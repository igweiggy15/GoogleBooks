//
//  BookAPI.swift
//  GoogleBooks
//
//  
//
//

import Foundation

struct BookAPI {
    
    var book: Book!
    var search: String!
    
    init( search: String) {
        self.search = search
    }
    
    
    init(book: Book){
        self.book = book
    }
    
    let base = "https://www.googleapis.com/books/v1/volumes?"
    let test = "q="
    
    var getURL: URL? {
        return URL(string: base + test + search)
    }
    
    
    
    
}
