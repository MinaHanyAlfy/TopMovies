//
//  MovieDetailsViewController.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-29.
//

import UIKit

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var genreLb: UILabel!
    @IBOutlet weak var genresLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var releaseDateLb: UILabel!
    @IBOutlet weak var runtimeDataLb: UILabel!
    @IBOutlet weak var descTv: UITextView!
    @IBOutlet weak var overviewLb: UILabel!
    @IBOutlet weak var runtimeLb: UILabel!
    @IBOutlet weak var movieNameLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    private let viewModel:
        MovieDetailsViewModel
    weak var coordinator: MoviesCoordinator?
    private let zeroStateView = ZeroStateView()

    init(
        viewModel: MovieDetailsViewModel,
        coordinator: MoviesCoordinator
    ) {

        self.viewModel = viewModel
        self.coordinator = coordinator

        super.init(
            nibName:
            "MovieDetailsViewController",
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError(
            "init(coder:) not implemented"
        )
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        configureUI()
        configureZeroState()
        fetchData()
    }
}

//MARK: - Configurations
private extension MovieDetailsViewController {
    func configureUI() {
        title = "\(viewModel.movie?.title ?? "Movie") Details"

        titleLb.text = "Title:"
        genresLb.text = "Genres:"
        runtimeLb.text = "Runtime:"
        releaseDateLb.text = "Release Date:"
        overviewLb.text = "Overview:"

        zeroStateView.isHidden = true
    }

    func fetchData() {
        Task {

            await viewModel
                .fetchMovieDetails()

            render(
                state:
                viewModel.state
            )
        }
    }
    
    private func configureZeroState() {
        zeroStateView.translatesAutoresizingMaskIntoConstraints = false

        zeroStateView.message = "No movies available."

        view.addSubview(zeroStateView)

        NSLayoutConstraint.activate([

            zeroStateView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            zeroStateView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            zeroStateView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            zeroStateView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
        ])
        zeroStateView.isHidden = true
    }
}

//MARK: - Fetching data
private extension MovieDetailsViewController {

    func fetchMovieDetails() {
        Task {

            await viewModel
                .fetchMovieDetails()

            render(
                state:
                    viewModel.state
            )
        }
    }
}

//MARK: - Render state logic
private extension MovieDetailsViewController {
    func render(
        state: ViewState
    ) {

        switch state {
            
        case .idle:
            break
            
        case .loading:
            zeroStateView.isHidden = false
            zeroStateView.message = "Loading movie details..."
            
        case .loaded:
            zeroStateView.isHidden = true
            updateUI()
            
        case .empty(let message),
                .error(let message):
            
            zeroStateView.isHidden = false
            zeroStateView.message = message
        }
    }
}

//MARK: - Start Point screen.
private extension MovieDetailsViewController {
    func updateUI() {
        guard let movie =
                viewModel.movie
        else {
            return
        }
        
        movieNameLb.text =
        movie.title
        
        runtimeDataLb.text =
        "\(movie.runtime) min"
        
        dateLb.text =
        movie.releaseDate
        
        descTv.text =
        movie.overview
        
        genreLb.text =
        movie.genres.joined(
            separator: ", "
        )
        
        Task {
            let image =
            await viewModel
                .loadPoster()
            
            movieImageView.image =
            image ??
            UIImage(
                named:
                    "placeholder"
            )
        }
    }
}
