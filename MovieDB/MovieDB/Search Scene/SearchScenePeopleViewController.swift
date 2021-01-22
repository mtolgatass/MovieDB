//
//  SearchScenePeopleViewController.swift
//  MovieDB
//
//  Created by Tolga Taş on 19.12.2020.
//

import UIKit
import TMDBSwift

protocol SearchScenePeopleDisplayLogic: class {
    func displayPeople(viewModel: SearchScene.People.ViewModel)
}

class SearchScenePeopleViewController: UIViewController, SearchScenePeopleDisplayLogic {
    
    var interactor: SearchSceneBusinessLogic?
    var router: (NSObjectProtocol & SearchSceneRoutingLogic & SearchSceneDataPassing)?
    
    var peoplePage: Int = 0
    var peopleSearchPage: Int = 0
    var searchText: String = ""
    var isSearchActive: Bool = false
    
    var people = [PersonResults]() {
        didSet {
            if !people.isEmpty {
                tableView.reloadData()
            }
        }
    }
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
        presenter.peopleViewController = viewController
        router.peopleViewController = viewController
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
        
        self.view.backgroundColor = UIColor.green
        setupTableView()
        discoverPeople()
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
        
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func discoverPeople() {
        if searchText.isEmpty {
            self.view.showLoading()
            peoplePage = peoplePage + 1
            interactor?.discoverPeople(page: peoplePage)
        }
    }
    
    private func searchPeople(query: String) {
        self.view.showLoading()
        peopleSearchPage = peopleSearchPage + 1
        interactor?.searchPeople(text: query, page: peopleSearchPage)
    }
    
    func displayPeople(viewModel: SearchScene.People.ViewModel) {
        guard let people = viewModel.people else {
            let alert = UIAlertController(title: "Error", message: "An error occured.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.isSearchActive = false
        self.view.stopLoading()
        self.people.append(contentsOf: people)
    }
}

// MARK: - TableView Extension

extension SearchScenePeopleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == people.count - 2) {
            if people.count == peopleSearchPage * 20 || people.count == peoplePage * 20 {
                searchText.isEmpty ? discoverPeople() : searchPeople(query: searchText)
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        if isSearchActive {
            cell.textLabel?.text = "Searching..."
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        if people.isEmpty {
            cell.textLabel?.text = "0 People Found"
            cell.textLabel?.textAlignment = .center
            tableView.separatorStyle = .none
            return cell
        }
        
        cell.textLabel?.text = people[indexPath.row].name
        tableView.separatorStyle = .singleLine
        cell.textLabel?.textAlignment = .left
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 8, y: 0, width: tableView.frame.width, height: 35)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = "People"
        
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        let personDetailScene = PersonDetailSceneViewController()
        personDetailScene.personId = person.id
        
        self.navigationController?.show(personDetailScene, sender: nil)
    }
}

// MARK: - Search Extension
extension SearchScenePeopleViewController: SearchBarObserver {
    
    func searchCanceled() {
        isSearchActive = true
        searchText.removeAll()
        people.removeAll()
        peoplePage = 0
        peopleSearchPage = 0
        discoverPeople()
    }
    
    func searchButtonClicked(text: String) {
        searchText = text
        if !text.isEmpty {
            isSearchActive = true
            searchPeople(query: text)
            peopleSearchPage = 0
        }
    }
}
