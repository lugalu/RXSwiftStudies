//
//  MALModel.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit

struct Anime{
    let title: String
    let abbreviatedTitle: String?
    let averageRating: String?
    let favoriteCount: Int
    let ageRating: String?
    var image: UIImage?
}

class MALModel{
    /*
     https://kitsu.io/api/edge
     */
    
    private let endpoint = "https://kitsu.io/api/edge/trending/anime"
    
    
    func getAnimes() async -> [Anime]{
        do{
            guard let animeList = try await getBaseAnimes().data else {
                return []
            }
            var animes:[Anime] = []
            
            for anime in animeList{
                let attributes = anime.attributes
                let title = attributes?.titles?.enJp ?? attributes?.canonicalTitle ?? "Missing Title"
                let abbTitle = attributes?.abbreviatedTitles?.first ?? "Missing Abbreviated Title"
                let rating = attributes?.averageRating ?? "Ratings Unavailable"
                let favCount = attributes?.favoritesCount ?? 0
                let ageRating = attributes?.ageRatingGuide ?? "Missing age rating"
                
                var newAnime = Anime(title: title,
                                     abbreviatedTitle: abbTitle,
                                     averageRating: rating,
                                     favoriteCount: favCount,
                                     ageRating: ageRating)
                
                if let imagePath = attributes?.posterImage?.large {
                    let (data, _) = try await URLSession.shared.data(from: URL(string: imagePath)!)
                    let image = UIImage(data: data) ?? UIImage(systemName: "x.circle")
                    newAnime.image = image
                }else{
                    newAnime.image = UIImage(systemName: "x.circle")
                }
                
                animes.append(newAnime)
            }
            
            return animes
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
    
    
    func getBaseAnimes() async throws  -> AnimeList {
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: endpoint)!)
        let list = try JSONDecoder().decode(AnimeList.self, from: data)
        return list
    }

    
}

// MARK: - Welcome
struct AnimeList: Decodable {
    let data: [AnimeData]?
}

// MARK: - Datum
struct AnimeData: Decodable {
    let id: String?
    let attributes: Attributes?
}

// MARK: - Attributes
struct Attributes: Decodable {
    let titles: Titles?
    let canonicalTitle: String?
    let abbreviatedTitles: [String]?
    let averageRating: String?
    let favoritesCount: Int?
    let ageRatingGuide: String?
    let posterImage: PosterImage?
}

// MARK: - CoverImage
struct CoverImage: Decodable {
    let large: String?
    let original: String?
}

// MARK: - PosterImage
struct PosterImage: Codable {
    let large: String?
    let original: String?
}

// MARK: - Titles
struct Titles: Codable {
    let enJp: String?
}
