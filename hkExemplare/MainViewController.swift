//
//  ViewController.swift
//  hkExemplare
//
//  Created by Anderson Santos Gusmao on 26/09/17.
//  Copyright © 2017 Heuristisk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import TMDBSwift


class MainViewController: UITableViewController {

    @IBOutlet weak var searchBarButton :UIBarButtonItem!
    fileprivate let disposeBag = DisposeBag()
    fileprivate let averageVoteRef = 5.0
    fileprivate var originalDataSource = [MovieMDB]() {
        didSet{
            filteredDataSource = Variable(originalDataSource)
        }
    }
    
    fileprivate var filteredDataSource: Variable<[MovieMDB]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        loadDataSet { (success) in
            self.setupUI()
        }
    }
    
    private func loadDataSet(completion: @escaping (_ success: Bool) -> Void) {
        
        Api.getMovies { (response) in
            switch response {
            case .sucess(let source):
                self.originalDataSource = source.value.filter({$0.vote_average ?? 0 > self.averageVoteRef})
                completion(true)
                break
            case .error(let reason):
                //TODO: Error handling
                print(reason)
                completion(true)
                break
            }
        }
    }
    
    private func setupUI() {
        bindTableView()
        bindTableViewSelected()
        bindSearchButtonTap()
    }

    fileprivate func filterTableView(text: String) {
        
        if (text.isEmpty) {
            self.filteredDataSource.value = originalDataSource
        } else {
            self.filteredDataSource.value = originalDataSource.filter({($0.title ?? String.Empty).lowercased().contains(text.lowercased()) })
        }
    }
}

extension MainViewController {
    
    //Binders
    
    fileprivate func bindSearchButtonTap() {
        self.searchBarButton.rx.tap
            .throttle(0.5, latest: false, scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                
                guard let strongSelf = self else { return }
                
                guard let searchViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
                    fatalError("SearchViewController not found")
                }
                
                searchViewController.filterText.subscribe(onNext :{ [weak self] text in
                    
                    DispatchQueue.main.async {
                        self?.filterTableView(text: text)
                    }
                    strongSelf.navigationController?.popToViewController(self!, animated: true)
                    
                }).addDisposableTo(strongSelf.disposeBag)
                
                strongSelf.navigationController?.pushViewController(searchViewController, animated: true)
                
            }.addDisposableTo(disposeBag)
    }
    
    fileprivate func bindTableView() {
        
        filteredDataSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, element, cell in
                
                cell.textLabel?.text = element.title
                
            }.addDisposableTo(disposeBag)
    }
    
    fileprivate func bindTableViewSelected() {
        
        tableView
            .rx
            .modelSelected(MovieMDB.self)
            .subscribe(onNext :{ [weak self] model in
                
                guard let strongSelf = self else { return }
                
                guard let movieDetailViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
                    fatalError("MovieDetailViewController not found")
                }
                
                movieDetailViewController.setModel(model)
                
                strongSelf.navigationController?.pushViewController(movieDetailViewController, animated: true)
                
            }).addDisposableTo(disposeBag)
    }
}

