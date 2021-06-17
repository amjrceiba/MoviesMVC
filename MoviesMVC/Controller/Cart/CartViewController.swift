//
//  CartViewController.swift
//  MoviesMVC
//
//  Created by Andrés Mauricio Jaramillo Romero - Ceiba Software on 15/06/21.
//

import UIKit

class CartViewController: ViewController<CartView> {
    
    private var movies: [Movie] = [] {
        didSet {
            customView.tableview.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "Cart"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        customView.tableview.delegate = self
        customView.tableview.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMovies()
    }
    
    func loadMovies(){
        movies = DBController().getMovies()
    }
    
    func removeMovie(movie: Movie){
        do{
            try DBController().removeMovie(movie: movie)
        }
        catch{
            showErrorAlert(title: "Error", message: error.localizedDescription)
        }
        
        self.notifyObserver()
        self.loadMovies()
    }

    func notifyObserver(){
        NotificationCenter.default.post(name: Notification.Name("updateCartBadge"), object: nil)
    }
    
    func showRemoveMovieAlert(title: String, message: String, movie: Movie){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.removeMovie(movie: movie)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
        cell.configureWith(movie: movies[indexPath.row], delegate: self)
        cell.selectionStyle = .none
        return cell
    }
    
    func cartTableViewCell(_ cartTableviewCell: CartTableViewCell, movie: Movie) {
        showRemoveMovieAlert(title: "Alert", message: "Do you want to remove \(movie.originalTitle) from your cart?", movie: movie)
        notifyObserver()
        loadMovies()
    }
}
