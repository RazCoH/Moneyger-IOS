//
//  RatesDataSource.swift
//  Project
//
//  Created by raz cohen on 27/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation

struct Currency{

    let result:String
    let base:String
    let conversionRates:[Rate]
    
    struct Rate{
        let name:String
        let rate:Double
    }
}

extension Currency:Decodable{
    
    enum CodingKeyes:String,CodingKey{
        case result,base,conversionRates
    }

    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: CodingKeyes.self)
        
        result = try container.decode(String.self, forKey: .result)
        base = try container.decode(String.self, forKey: .base)
        // map the array
        let ratesDic = try container.decode(Dictionary<String,Double>.self,forKey : .conversionRates)
        conversionRates = ratesDic.map(Rate.init)
        
    }
}

class RatesDataSource{
    
    static let shared = RatesDataSource()
    
    func getRates(callback:@escaping (Currency?)->Void,curr:String
    ){
        let baseUrl = "https://prime.exchangerate-api.com/v5/80c46dea22c419aea96bbdfc/latest/"

        let session = URLSession.shared
        
        guard let url = URL(string: "\(baseUrl)\(curr)")else{print("bad url");return}
        
        print(url)
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else{print("bad data")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        
            do{
                let rate =  try decoder.decode(Currency.self, from: data)
                DispatchQueue.main.async {
                    callback(rate)
                }
            }catch let err{
                print("Erorr!",err)
            }
        }.resume()
        
    }
 
}

