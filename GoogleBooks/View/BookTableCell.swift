//
//  BookTableCell.swift
//  GoogleBooks
//
//
//

import UIKit

class BookTableCell: UITableViewCell {
    
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    
    static let identifier = "BookTableCell"
    
    var book: Book! {
        didSet {
            book.getImageSmall { [weak self] img in
                self?.bookImage.image = img
            }
        book.getYear { [weak self] year in
               self?.bookTitle.text = "\(self?.book.info?.title ?? "") \(year)"
            }
            book.getAuthors { [weak self] authors in
                self?.bookAuthors.text = authors
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
