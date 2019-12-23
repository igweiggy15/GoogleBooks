//
//  DetailViewController.swift
//  GoogleBooks
//
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailImageLabel: UIImageView!
    @IBOutlet weak var detailSubtitlLabel: UILabel!
    @IBOutlet weak var detailAuthorLabel: UILabel!
    @IBOutlet weak var detailYearLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var detailFavoriteButton: UIButton!
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetail()
    }
    
    private func setupDetail() {
        viewModel.book.getImageLarge { [weak self] img in
            self?.detailImageLabel.image = img
        }
        viewModel.book.getYear { [weak self] year in
            self?.detailYearLabel.text = "\(self?.viewModel.book.info?.title ?? "") \(year)"
        }
        detailSubtitlLabel.text = viewModel.book.info?.subtitle ?? ""
        viewModel.book.getAuthors { [weak self] authors in
            self?.detailAuthorLabel.text = authors
        }
        detailDescriptionLabel.text = viewModel.book.info?.desc ?? ""
        
        if viewModel.isFav(id: viewModel.book.id) {

            detailFavoriteButton.setTitle("Unfavorite", for: .normal)
            detailFavoriteButton.setTitleColor(UIColor.white, for: .normal
            )
        }
        else {
            
            detailFavoriteButton.setTitle("Favorite", for: .normal)
            detailFavoriteButton.setTitleColor(UIColor.white, for: .normal
            )
        }
        
        detailFavoriteButton.addTarget(self, action: #selector(detailFavBtnTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func detailFavBtnTapped(sender: UIButton) {
        if viewModel.isFav(id: viewModel.book.id) {
           
            detailFavoriteButton.setTitle("Favorite", for: .normal)
            detailFavoriteButton.setTitleColor(UIColor.white, for: .normal)
            
            viewModel.unFav(book: viewModel.book)
        }
        else {
            
            detailFavoriteButton.setTitle("Unfavorite", for: .normal)
            detailFavoriteButton.setTitleColor(UIColor.white, for: .normal)
            
            viewModel.fav(book: viewModel.book)
        }
    }
}
