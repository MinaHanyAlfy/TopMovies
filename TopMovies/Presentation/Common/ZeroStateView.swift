//
//  ZeroStateView.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import UIKit

final class ZeroStateView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(
            systemName: "exclamationmark.triangle.fill"
        )

        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let messageLabel: UILabel = {

        let label = UILabel()

        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(
            ofSize: 22,
            weight: .medium
        )

        label.numberOfLines = 0

        return label
    }()

    var message: String? {
        get { messageLabel.text }
        set { messageLabel.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    private func setupSubviews() {

        backgroundColor = .systemBackground

        addSubview(imageView)
        addSubview(messageLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            imageView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),

            imageView.centerYAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -60
            ),

            imageView.widthAnchor.constraint(
                equalToConstant: 80
            ),

            imageView.heightAnchor.constraint(
                equalToConstant: 80
            ),

            messageLabel.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 20
            ),

            messageLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 24
            ),

            messageLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -24
            )
        ])
    }
}
