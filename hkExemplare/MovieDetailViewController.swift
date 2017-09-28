//
//  MovieDetailViewController.swift
//  hkExemplare
//
//  Created by Anderson Santos Gusmao on 26/09/17.
//  Copyright © 2017 Heuristisk. All rights reserved.
//

import UIKit
import TMDBSwift

class MovieDetailViewController: UIViewController {

    private var model: MovieMDBCacheable!

    @IBOutlet weak var labelOverview: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {

        guard self.model != nil else {
            return
        }

        self.title = model.title ?? String.Empty
        self.labelOverview.text = model.overview
    }

    func setModel(_ model: MovieMDBCacheable) {
        self.model = model
    }
}
