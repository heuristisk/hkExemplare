//
//  SearchViewController.swift
//  hkExemplare
//
//  Created by Anderson Santos Gusmao on 26/09/17.
//  Copyright © 2017 Heuristisk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    let filterText = PublishSubject<String>()
    @IBOutlet weak var searchUITextField :UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
    }
    
    @IBAction func onPressSearch() {
        self.filterText.onNext(searchUITextField.text ?? String.Empty)
    }
    
    @IBAction func onPressClear() {
        self.filterText.onNext(String.Empty)
    }
}
