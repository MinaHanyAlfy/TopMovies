//
//  MovieTableViewCell.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!

    private var imageTask: Task<Void, Never>?

    override func awakeFromNib() {

        super.awakeFromNib()

        configureUI()
        movieTitleLabel.isAccessibilityElement = true
        movieTitleLabel.accessibilityIdentifier = "movie_title_label"
    }

    private func configureUI() {

        selectionStyle =
            .none

        movieImageView
            .clipsToBounds =
            true

        movieImageView
            .layer
            .cornerRadius = 12
    }

    func setup(
        movie: MovieEntity,
        imageUseCase:
            DownloadImageUseCaseProtocol
    ) {

        movieTitleLabel.text =
            movie.title

        releaseDateLabel.text =
            movie.releaseDate

        movieImageView.image =
            UIImage(
                named:
                    "placeholder"
            )

        imageTask?.cancel()

        guard
            !movie.posterPath
                .isEmpty
        else {

            return
        }

        imageTask = Task {

            do {

                let image =
                    try await imageUseCase
                    .execute(
                        path:
                            movie
                            .posterPath
                    )

                guard
                    !Task.isCancelled
                else {

                    return
                }

                await MainActor
                    .run {

                        self
                            .movieImageView
                            .image =
                            image
                    }

            } catch {

                await MainActor
                    .run {

                        self
                            .movieImageView
                            .image =
                            UIImage(
                                named:
                                    "placeholder"
                            )
                    }
            }
        }
    }

    override func prepareForReuse() {

        super
            .prepareForReuse()

        imageTask?.cancel()

        movieTitleLabel.text =
            nil

        releaseDateLabel.text =
            nil

        movieImageView.image =
            UIImage(
                named:
                    "placeholder"
            )
    }
}
