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
        viewModel: MoviesListViewModel
    ) {

        self.viewModel =
            viewModel

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
        fetchMovies()
    }
}
//MARK: - Binding
extension MoviesViewController {
    fileprivate func bindViewModel() {
        viewModel
            .$movies
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.stopLoading()
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(
                on:
                    DispatchQueue.main
            )
            .sink {
                [weak self]
                isLoading in

                guard let self else {
                    return
                }

                if isLoading {
                    self.startLoading()
                } else {
                    self.stopLoading()
                }
            }
            .store(
                in: &cancellables
            )
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
            try await viewModel
                .fetchMovies(
                    refresh: true
                )

            tableView.reloadData()
            refreshControl
                .endRefreshing()
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
                try await viewModel.fetchMovies()

                tableView.reloadData()
                updateUIState()

            } catch {
                zeroStateView.message =
                    "Something went wrong."

                tableView.isHidden = true
                zeroStateView.isHidden = false
            }

            stopLoading()
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

        coordinator?
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
            try await viewModel
                .fetchMovies()

            tableView
                .reloadData()
        }
    }
}
