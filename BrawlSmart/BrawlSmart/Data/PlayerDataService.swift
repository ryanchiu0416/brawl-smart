//
//  PlayerDataService.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/25/21.
//

import Foundation

enum PlayerDataCallingError: Error {
    case errorGeneratingURL
    case errorGettingDataFromAPI
    case errorDecodingData
}



class PlayerDataService {
    private let fetchPlayerStatsURL = "https://api.brawlstars.com/v1/players/"
    private let APIKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImExZGFlYzQyLWQzZWEtNGYzZi05NzRiLWM0MmEwNmU5MDVkNCIsImlhdCI6MTYyMjAwMDYwMCwic3ViIjoiZGV2ZWxvcGVyL2FiNTBhOGY2LWI5Y2UtY2U4ZS00YmIzLWJjMDFjM2RjNGJjNyIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiOTkuNy4xMzYuMjM0Il0sInR5cGUiOiJjbGllbnQifV19.gOG8nxURXov1aXEXWwg5RXkOgt3D0hRFdETwxW0xfT7dE4R6t-9oMeIyepGxIeFpuatjvgGRIkXi8kiuOgw5ww"
    
    
    
    func fetchPlayersData(tag: String, completion: @escaping (Player?, Error?) -> ()) {
        let urlStr = "\(self.fetchPlayerStatsURL)%23\(tag)"
        guard let url = URL(string: urlStr) else {
            DispatchQueue.main.async {
                completion(nil, PlayerDataCallingError.errorGeneratingURL)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, PlayerDataCallingError.errorGettingDataFromAPI)
                }
                return
            }
            do {
                let playerResult = try JSONDecoder().decode(Player.self, from: data)
                DispatchQueue.main.async {
                    completion(playerResult, nil)
                }
            } catch(let error) {
                print(error)
                DispatchQueue.main.async {
                    completion(nil, PlayerDataCallingError.errorDecodingData)
                }
            }
        }
        
        task.resume()
    }
}
