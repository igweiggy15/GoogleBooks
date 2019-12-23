//
//  Book.swift
//  GoogleBooks
//
// 
//
//
import UIKit

struct BookResponse: Decodable {
    let books: [Book]
    
    private enum CodingKeys: String, CodingKey {
        case books = "items"
    }
}

//MARK: To get JSON data

struct BookInfo: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publishDate: String?
    let desc: String?
    let imgs: BookImg?
    
    private enum CodingKeys: String, CodingKey {
        case title, authors, subtitle
        case publishDate = "publishedDate"
        case desc = "description"
        case imgs = "imageLinks"
    }
    
    init(title: String,
         subtitle: String? = nil,
         authors: String? = nil,
         publishedDate: String? = nil,
         desc: String? = nil,
         small: String? = nil,
         large: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors?.components(separatedBy: ",")
        self.publishDate = publishedDate
        self.desc = desc
        self.imgs = BookImg(small: small, large: large)
    }
}

//MARK: To get image data
struct BookImg: Decodable {
    let small: String?
    let large: String?
    
    private enum CodingKeys: String, CodingKey {
        case small = "smallThumbnail"
        case large = "thumbnail"
    }
    
    init(small: String? = nil, large: String? = nil) {
        self.small = small
        self.large = large
    }
}

struct BookShort: Decodable {
    let text: String?
    
    private enum CodingKeys: String, CodingKey {
        case text = "textSnippet"
    }
    
    init(text: String? = nil) {
        self.text = text
    }
}

class Book: Decodable {
    let id: String
    let info: BookInfo?
    let short: BookShort?
    
    private enum CodingKeys: String, CodingKey {
        case info = "volumeInfo"
        case short = "searchInfo"
        case id
    }
    
    init(from core: CoreFav) {
        self.id = core.id!
        self.short = BookShort(text: core.short)
        self.info = BookInfo(title: core.title!,
                             subtitle: core.subtitle,
                             authors: core.authors,
                             publishedDate: core.publishedDate,
                             desc: core.bookDescription,
                             small: core.smallImage,
                             large: core.largeImage)
    }
    
        func getYear(completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            if let info = self.info {
                if let str = info.publishDate{
                    let index = str.index(str.startIndex, offsetBy: 4)
                    let sub = str[..<index]
                    completion(String("(\(sub))"))
                    return
                }
            }
            completion("")
        }
    }
    
    func getAuthors(completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            var authors = "By: "
            if let info = self.info {
                if let auths = info.authors {
                    for auth in auths {
                        if auth != "" {
                            authors += auth + ", "
                        }
                    }
                    authors.removeLast()
                    authors.removeLast()
                    completion(String(authors))
                    return
                    
                }
            }
            completion("")
        }
    }
    
    func getImageSmall(completion: @escaping (UIImage?) -> Void) {
        if let img = info?.imgs?.small {
            cache.downloadFrom(endpoint: img) { dat in
                if let data = dat {
                    DispatchQueue.main.async {
                        completion(UIImage(data: data))
                    }
                }
            }
        }
        else {
            completion(UIImage(imageLiteralResourceName: "404"))
        }
    }
    
    func getImageLarge(completion: @escaping (UIImage?) -> Void) {
        //if there is an image lets grab it
        if let img = info?.imgs?.large {
            cache.downloadFrom(endpoint: img) { dat in
                if let data = dat {
                    DispatchQueue.main.async {
                        completion(UIImage(data: data))
                    }
                }
            }
        }
        else {
            completion(UIImage(imageLiteralResourceName: "404"))
        }
    }
}
