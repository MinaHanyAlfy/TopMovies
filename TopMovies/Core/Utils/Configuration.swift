//
//  Configuration.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

enum Configuration {

    static var apiToken: String {
        guard let path =
                Bundle.main.path(
                    forResource: "Secrets",
                    ofType: "plist"
                ),
              let plist =
                NSDictionary(
                    contentsOfFile: path
                ),
              let token =
                plist["API_BEARER_TOKEN"]
                as? String
        else {
            fatalError(
                "Secrets.plist missing API_BEARER_TOKEN"
            )
        }

        return token
    }
}
