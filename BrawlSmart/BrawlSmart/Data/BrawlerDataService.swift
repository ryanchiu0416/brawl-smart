//
//  BrawlerDataService.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/13/21.
//

import Foundation

enum BrawlerDataCallingError: Error {
    case errorGeneratingURL
    case errorGettingDataFromAPI
    case errorDecodingData
}



class BrawlerDataService {
    private let fetchAllBrawlersURL = "https://api.brawlapi.com/v1/brawlers"
    
    // empty brawler call
//    private let fetchAllBrawlersURL = "https://run.mocky.io/v3/d2f9955b-685f-4c4e-8864-c8dfa977b692"
    
    
    func fetchBrawlersData(completion: @escaping ([Brawler]?, Error?) -> ()) {
        guard let url = URL(string: self.fetchAllBrawlersURL) else {
            DispatchQueue.main.async {
                completion(nil, BrawlerDataCallingError.errorGeneratingURL)
            }
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, BrawlerDataCallingError.errorGettingDataFromAPI)
                }
                return
            }
            
            do {
                let brawlerResult = try JSONDecoder().decode(BrawlerResult.self, from: data)
                DispatchQueue.main.async {
                    completion(brawlerResult.list, nil)
                }
            } catch(let error) {
                print(error)
                DispatchQueue.main.async {
                    completion(nil, BrawlerDataCallingError.errorDecodingData)
                }
            }
        }
        
        task.resume()
    }



    func getAllBrawlersData() -> [Brawler] {
        return [
//            Brawler(named: "Shelly", isOfClass: "Fighter", isOfRarity: "Trophy Road", description: "Shelly's spread-fire shotgun blasts the other team with buckshot. Her Super destroys cover and keeps her opponents at a distance!"),
//            Brawler(named: "Shelly", isOfClass: "Fighter", isOfRarity: "Trophy Road", description: "Shelly's spread-fire shotgun blasts the other team with buckshot. Her Super destroys cover and keeps her opponents at a distance!"),
//            Brawler(named: "Shelly", isOfClass: "Fighter", isOfRarity: "Trophy Road", description: "Shelly's spread-fire shotgun blasts the other team with buckshot. Her Super destroys cover and keeps her opponents at a distance!"),
//            Brawler(named: "Shelly", isOfClass: "Fighter", isOfRarity: "Trophy Road", description: "Shelly's spread-fire shotgun blasts the other team with buckshot. Her Super destroys cover and keeps her opponents at a distance!"),
//            Brawler(named: "Shelly", isOfClass: "Fighter", isOfRarity: "Trophy Road", description: "Shelly's spread-fire shotgun blasts the other team with buckshot. Her Super destroys cover and keeps her opponents at a distance!")
        ]
    }
}
