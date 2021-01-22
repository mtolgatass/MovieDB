//
//  PageViewController.swift
//  MovieDB
//
//  Created by Tolga Taş on 19.12.2020.
//

import UIKit
import Foundation

protocol SearchBarObserver: class {
    func searchButtonClicked(text: String)
    func searchCanceled()
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 400, height: 44))
    
    var searchObserver: SearchBarObserver?
    private lazy var observers = [SearchBarObserver]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        
        
        self.delegate = self
        self.dataSource = self
        
        let initialPage = 0
        let moviePage = SearchSceneMoviesViewController()
        observers.append(moviePage)
        let peoplePage = SearchScenePeopleViewController()
        observers.append(peoplePage)
        let genresPage = SearchSceneGenresViewController()
        observers.append(genresPage)
        
        self.pages.append(moviePage)
        self.pages.append(peoplePage)
        self.pages.append(genresPage)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: false, completion: nil)
        
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func setSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = searchBar
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                return self.pages.last
            } else {
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                return self.pages[viewControllerIndex + 1]
            } else {
                return self.pages.first
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}

// MARK: - SearchBar Extension

extension PageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        observers.forEach({$0.searchButtonClicked(text: searchBar.text ?? "")})
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.endEditing(true)
            observers.forEach({$0.searchCanceled()})
        }
    }
}

