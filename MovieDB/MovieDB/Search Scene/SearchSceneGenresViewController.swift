//
//  GenresViewController.swift
//  MovieDB
//
//  Created by Tolga Taş on 19.12.2020.
//

import UIKit
import TMDBSwift

protocol SearchSceneGenresDisplayLogic: class {
    func displayGenres(viewModel: SearchScene.Genres.ViewModel)
}

class SearchSceneGenresViewController: UIViewController, SearchSceneGenresDisplayLogic {
    var interactor: SearchSceneBusinessLogic?
    var router: (NSObjectProtocol & SearchSceneRoutingLogic & SearchSceneDataPassing)?
    
    var genres = [GenresMDB]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filteredGenres = [GenresMDB]()
    
    let tableView = UITableView()
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = SearchSceneInteractor()
        let presenter = SearchScenePresenter()
        let router = SearchSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.genresViewController = viewController
        router.genresViewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        setupTableView()
        discoverGenres()
    }
    
    // MARK: - Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func discoverGenres() {
        self.view.showLoading()
        interactor?.discoverGenres()
    }
    
    func displayGenres(viewModel: SearchScene.Genres.ViewModel) {
        guard let genres = viewModel.genres else {
            self.view.stopLoading()
            
            let alert = UIAlertController(title: "Error", message: "An error occured.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.genres.append(contentsOf: genres)
    }
}

// MARK: - TableView Extension

extension SearchSceneGenresViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredGenres.isEmpty {
            return genres.count
        }
        return filteredGenres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        if genres.isEmpty {
            cell.textLabel?.text = "0 Genres Found"
            cell.textLabel?.textAlignment = .center
            tableView.separatorStyle = .none
            return cell
        }
        
        cell.textLabel?.text = filteredGenres.isEmpty ? genres[indexPath.row].name : filteredGenres[indexPath.row].name
        cell.textLabel?.textAlignment = .left
        tableView.separatorStyle = .singleLine
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 8, y: 0, width: tableView.frame.width, height: 35)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = "Genres"
        
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        headerView.addSubview(myLabel)
        
        return headerView
    }
}

// MARK: - Search Extension
extension SearchSceneGenresViewController: SearchBarObserver {
    func searchCanceled() {
        filteredGenres.removeAll()
        tableView.reloadData()
    }
    
    
    func searchButtonClicked(text: String) {
        filteredGenres = genres.filter({($0.name?.contains(text) ?? true)})
        tableView.reloadData()
    }
}
