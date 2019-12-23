//
//  ViewController.swift
//  GoogleBooks
//
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchViewTable: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var viewModel = ViewModel(){
        didSet{
            self.searchViewTable.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMain()
        
    }
    private func setupMain(){
        
       
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Searching Google Books"
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        
        searchViewTable.register(UINib(nibName: BookTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: BookTableCell.identifier)
        searchViewTable.tableFooterView = UIView(frame: .zero)
        
        
        viewModel.bookDelegate = self

    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        viewModel.get(search: searchText)
        
        navigationItem.searchController?.isActive = false
    }
}

//MARK: TableView

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableCell.identifier, for: indexPath) as! BookTableCell
        let book = viewModel.books[indexPath.row]
        cell.book = book
        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.books[indexPath.row]
        viewModel.book = book
        goToDetail(with: viewModel)
    }
}


extension SearchViewController: BookDelegate{
    func update() {
        DispatchQueue.main.async {
            self.searchViewTable.reloadData()
        }
    }
}
