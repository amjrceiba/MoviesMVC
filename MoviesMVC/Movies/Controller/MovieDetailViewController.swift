//
//  MovieDetailViewController.swift
//  MoviesMVC
//
//  Created by Andrés Mauricio Jaramillo Romero - Ceiba Software on 15/06/21.
//

import Foundation
import UIKit

class MovieDetailViewController: ViewController<MovieDetailView> {
    
    private let movie: Movie
    private var movieExist = false
    
    init(with movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        
        initComponents()
        customView.configureWith(movie: self.movie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initComponents(){
        do{
            movieExist = try DBController().checkForMovie(movie: movie)
        }
        catch{
            showErrorAlert(title: "Error", message: error.localizedDescription)
        }
        
        let barButton = movieExist ? UIBarButtonItem.SystemItem.trash : UIBarButtonItem.SystemItem.add
        
        navigationItem.title = self.movie.originalTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: barButton, target: self, action: #selector(barButtonTapped))
    }
    
    @objc
    private func barButtonTapped(){
        do{
            movieExist ? try removeMovie() : try addMovie()
        }
        catch{
            showErrorAlert(title: "Error", message: error.localizedDescription)
        }
        
        self.notifyObserver()
        self.popView()
    }
    
    private func addMovie()throws{
        try DBController().addMovie(movie: movie)
    }
    
    private func removeMovie()throws{
        try DBController().removeMovie(movie: movie)
    }
    
    private func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func notifyObserver(){
        NotificationCenter.default.post(name: Notification.Name("updateCartBadge"), object: nil)
    }
    
    private func showErrorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
