//
//  ViewModel.swift
//  GoogleBooks
//
//
//

import Foundation

protocol BookDelegate: class {
    func update()
}

protocol FavBookDelegate: class {
    func update()
}

class ViewModel {
    
    weak var bookDelegate: BookDelegate?
    weak var favBookDelegate: FavBookDelegate?
    
    var books = [Book]() {
        didSet {
            bookDelegate?.update()
           
        }
    }
    
    var book: Book!
    
    var favBooks = [Book]() {
        didSet {
            favBookDelegate?.update()
            
        }
    }
    
    func get(search: String) {
        
        BookService.shared.getBooks(for: search) { [weak self] books in
            self?.books = books
            print("Book Count: \(books.count)")
        }
    }
    
    func isFav(id: String) -> Bool {
        if CoreManager.shared.read(id) != nil {
            return true
        }
        return false
    }
        func unFav(book: Book) {
        CoreManager.shared.delete(book)
    }
    
    func fav(book: Book) {
        CoreManager.shared.save(book)
    }
    
    func getFavs() {
        CoreManager.shared.load() { [weak self] books in self?.favBooks = books
            print("Fav Book Count: \(books.count)")
        }
    }
}
