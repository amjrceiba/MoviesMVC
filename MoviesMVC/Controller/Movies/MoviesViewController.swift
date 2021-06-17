//
//  MoviesViewController.swift
//  MoviesMVC
//
//  Created by Andrés Mauricio Jaramillo Romero - Ceiba Software on 15/06/21.
//

import Foundation
import UIKit

class MoviesViewController: ViewController<MoviesView>{

    private var movies: [Movie] = [] {
        didSet {
            customView.tableview.reloadData()
        }
    }
    
    private var selecteMovie: Movie?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        customView.tableview.delegate = self
        customView.tableview.dataSource = self
        
        loadMovies()
    }
    
    func loadMovies(){
        Networking().fetchMovies { movies in
            self.movies = movies
        }
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.configureWith(movie: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selecteMovie = movies[indexPath.row]
        let viewController = MovieDetailViewController(with: selecteMovie!)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

