//
//  MALModel.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit
import RxSwift


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
    
    func getAnimes() -> Single<[Anime]>{
        return Single.create{ [weak self] single in
            let disposable = Disposables.create()
            
            guard let self else{ return disposable }
        
            let task = Task{
                do {
        
                    guard let animeList = try await self.getBaseAnimes().data else {
                        single(.failure(NSError(domain: "com.lugalu.RXSwift", code: 12)))
                        return
                    }
                    
                    var animes:[Anime] = []
                    
                    for anime in animeList {
                        
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
                            newAnime.image = try await self.downloadImage(path: imagePath)
                        }else{
                            newAnime.image = UIImage(systemName: "x.circle")
                        }
                        
                        animes.append(newAnime)
                    }
                    
                    single(.success(animes))
                }catch {
                    print(error.localizedDescription)
                    
                    single(.failure(NSError(domain: "com.lugalu.RXSwift", code: 12)))
                    return
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
            
        }
    }
    
    
    private func getBaseAnimes() async throws  -> AnimeList {
        let (data, _) = try await URLSession.shared.data(from: URL(string: endpoint)!)
        let list = try JSONDecoder().decode(AnimeList.self, from: data)
        return list
    }
    
    private func downloadImage(path imagePath: String) async throws -> UIImage{
        let (data, _) = try await URLSession.shared.data(from: URL(string: imagePath)!)
        let image = UIImage(data: data) ?? UIImage(systemName: "x.circle")!
        return image
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
