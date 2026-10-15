//
//  ViewController.swift
//  assignment6
//
//  Created by Anuarkhan Assanbayev on 14.10.2026.
//

import UIKit

struct Movie {
    let title: String
    let description: String
    let imageName: String
}

class ViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
        
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let movies: [Movie] = [
        Movie(
            title: "Transformers",
            description: "An epic battle between Autobots and Decepticons for the future of Earth.",
            imageName: "movie1"
        ),
        Movie(
            title: "The Gentlemen",
            description: "A British drug lord tries to sell his empire.",
            imageName: "movie2"
        ),
        Movie(
            title: "Inglourious Basterds",
            description: "A group of soldiers plots revenge against the Nazis.",
            imageName: "movie3"
        ),
        Movie(
            title: "Snatch",
            description: "Criminals fight over a stolen diamond.",
            imageName: "movie4"
        ),
        Movie(
            title: "The Odyssey",
            description: "An epic journey of a hero trying to return home.",
            imageName: "movie5"
        ),
        Movie(
            title: "Dune",
            description: "A young hero faces his destiny on Arrakis.",
            imageName: "movie6"
        ),
        Movie(
            title: "Inception",
            description: "A thief enters dreams to steal secrets.",
            imageName: "movie7"
        ),
        Movie(
            title: "The Covenant",
            description: "A soldier risks everything to save his interpreter.",
            imageName: "movie8"
        ),
        Movie(
            title: "Limitless",
            description: "A mysterious pill unlocks the power of the mind.",
            imageName: "movie9"
        ),
        Movie(
            title: "Prisoners",
            description: "A father searches desperately for his missing daughter.",
            imageName: "movie10"
        )
    ]       
    var currentIndex = 0
    func showMovie(at index: Int) {
        let movie = movies[index]

        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
        movieImageView.image = UIImage(named: movie.imageName)
    }
    
    @IBAction func randomButton(_ sender: UIButton) {
        var newIndex: Int

        repeat {
            newIndex = Int.random(in: 0..<movies.count)
        } while newIndex == currentIndex

        currentIndex = newIndex
        showMovie(at: currentIndex)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMovie(at: currentIndex)
        // Do any additional setup after loading the view.
    }


}

