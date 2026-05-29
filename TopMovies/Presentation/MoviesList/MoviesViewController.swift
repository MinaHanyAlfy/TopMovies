//
//  MoviesViewController.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-28.
//

import Combine
import UIKit

final class MoviesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    private let viewModel: MoviesListViewModel
    private let zeroStateView = ZeroStateView()

    weak var coordinator: MoviesCoordinator?

    private let refreshControl =
        UIRefreshControl()
    private var cancellables =
        Set<AnyCancellable>()

    init(
        viewModel: MoviesListViewModel,
        coordinator: MoviesCoordinator
    ) {

        self.viewModel = viewModel
        self.coordinator = coordinator

        super.init(
            nibName:
                "MoviesViewController",
            bundle:
                nil
        )
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("Error when initalizing Movies View Controller!!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        configureZeroState()
        bindViewModel()
        loadingIndicatorConfig()
        setupNetworkListener()
        fetchMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.movies.isEmpty {
            Task {
                await viewModel.fetchMovies(refresh: true)
            }
        }
    }
}
//MARK: - Binding
extension MoviesViewController {
    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Configurations
extension MoviesViewController {
    fileprivate func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 140
        tableView.separatorStyle = .none

        tableView.registerCell(tableViewCell: MovieTableViewCell.self)

        configureRefresh()
    }

    func configureRefresh() {
        refreshControl
            .addTarget(
                self,
                action:
                    #selector(
                        refreshTriggered
                    ),
                for:
                    .valueChanged
            )

        tableView.refreshControl =
            refreshControl
    }

    
    @objc
    func refreshTriggered() {
        Task {
            await viewModel.fetchMovies(refresh: true)
            refreshControl.endRefreshing()
        }
    }

    func loadingIndicatorConfig() {
        loadingIndicator.hidesWhenStopped = true
    }

    private func startLoading() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    private func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
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

    private func updateUIState() {

        let hasMovies = !viewModel.movies.isEmpty

        tableView.isHidden = !hasMovies
        zeroStateView.isHidden = hasMovies
    }

    private func fetchMovies() {
        Task {
            startLoading()

            do {
                await viewModel.fetchMovies()

                tableView.reloadData()
                updateUIState()
            }

            stopLoading()
        }
    }
    
    private func setupNetworkListener() {
        NetworkMonitor.shared.onConnectionRestored = { [weak self] in
            guard let self else { return }
            self.handleConnectionRestored()
        }
    }
    
    @MainActor
    private func handleConnectionRestored() {
        let hasNoData = viewModel.movies.isEmpty

        guard hasNoData else {
            return
        }

        print("🌐 Connection restored → retrying fetch")
        Task {
            await viewModel.fetchMovies(refresh: true)
        }
    }   
}

//MARK: - UITableViewDataSource
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeue(
            tableViewCell: MovieTableViewCell.self,
            forIndexPath: indexPath
        )

        let movie = viewModel.movies[indexPath.row]

        cell.setup(
            movie: movie,
            imageUseCase: viewModel.downloadImageUseCase
        )
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MoviesViewController: UITableViewDelegate {
    func tableView(
        _ tableView:
            UITableView,
        didSelectRowAt indexPath:
            IndexPath
    ) {

        let movie =
            viewModel
            .movie(
                at:
                    indexPath.row
            )
        guard let coordinator = coordinator else { return }
        coordinator
            .showDetails(
                movieId:
                    movie.id
            )
        
    }

    func tableView(
        _ tableView:
            UITableView,
        willDisplay cell:
            UITableViewCell,
        forRowAt indexPath:
            IndexPath
    ) {

        let lastIndex =
            viewModel
            .movies
            .count - 1

        guard
            indexPath.row == lastIndex
        else {
            return
        }

        Task {
            await viewModel
                .fetchMovies()

            tableView
                .reloadData()
        }
    }
}
//MARK: - Render state logic.
extension MoviesViewController {
    private func render(state: ViewState) {
        
        switch state {
            
        case .idle:
            break
            
        case .loading:
            loadingIndicator.startAnimating()
            tableView.isHidden = true
            zeroStateView.isHidden = true
            
        case .loaded:
            loadingIndicator.stopAnimating()
            tableView.isHidden = false
            zeroStateView.isHidden = true
            
        case .empty(let message):
            loadingIndicator.stopAnimating()
            tableView.isHidden = true
            
            zeroStateView.message = message
            zeroStateView.isHidden = false
            
        case .error(let message):
            loadingIndicator.stopAnimating()
            tableView.isHidden = true
            
            zeroStateView.message = message
            zeroStateView.isHidden = false
        }
    }
}
