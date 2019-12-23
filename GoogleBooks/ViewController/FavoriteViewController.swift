//
//  FavoriteViewController.swift
//  GoogleBooks
//
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favTableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel = ViewModel() {
        didSet {
            self.favTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMain()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavs()
    }
    
    private func setupMain() {

        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Google Books..."
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        favTableView.register(UINib(nibName: BookTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: BookTableCell.identifier)
        
        favTableView.tableFooterView = UIView(frame: .zero)
       
        viewModel.favBookDelegate = self
       
    }
}

extension FavoriteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        viewModel.get(search: searchText)
        
        navigationItem.searchController?.isActive = false
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableCell.identifier, for: indexPath) as! BookTableCell
        let book = viewModel.favBooks[indexPath.row]
        cell.book = book
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.favBooks[indexPath.row]
        viewModel.book = book
        goToDetail(with: viewModel)
    }
}

extension FavoriteViewController: FavBookDelegate {
    func update() {
        DispatchQueue.main.async {
            self.favTableView.reloadData()
        }
    }
}
