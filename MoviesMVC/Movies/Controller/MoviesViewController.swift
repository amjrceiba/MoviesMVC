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
    
    override func viewDidLoad() {
        customView.tableview.delegate = self
        customView.tableview.dataSource = self
        
        loadMovies()
    }
    
    private func loadMovies(){
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
        let viewController = MovieDetailViewController(with: movies[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}

