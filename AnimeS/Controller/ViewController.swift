//
//  ViewController.swift
//  AnimeS
//
//  Created by Gustavo Carreno on 8/14/17.
//  Copyright © 2017 GECV. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import SwiftHTTP

class ViewController: UIViewController {
    var tokenString: String? = nil
    var tokenExpire: Date = Date(timeIntervalSince1970: 0)
    var insertIndexForTempEntries = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LoadTokenAndTime()
    }
    
    func userdata(){
        let params = ["grant_type":"client_credentials","client_id":"malilandes-fqzq4","client_secret":"G2aZYGQLqU8cCmtDaDbPTU"]
        do {
            let opt = try HTTP.POST(GlobalsVariables.urlmaster+"auth/access_token", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return
                }
                do {
                    let userresponse = JSON(response.data)
                    let tokenString = userresponse["access_token"].string!
                    let expire = userresponse["expires_in"].int
                        self.tokenExpire = Date(timeIntervalSinceNow: Double(expire! - 10))
                        self.tokenString = tokenString
                        self.saveTokenandTime()
                 } catch {
                    print("unable to parse the JSON")
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }

    }
    
    func saveTokenandTime(){
        UserDefaults.standard.set(self.tokenString!, forKey: "AnilistTokenString")
        UserDefaults.standard.set(self.tokenExpire.timeIntervalSince1970, forKey: "AnilistTokenExpire")
        self.LoadTokenAndTime()
    }
    
    func LoadTokenAndTime(){
        let tokenExpire = UserDefaults.standard.double(forKey: "AnilistTokenExpire")
        guard tokenExpire != 0 else {
            userdata()
            return
        }
        guard let tokenString = UserDefaults.standard.string(forKey: "AnilistTokenString") else { return }
        self.tokenExpire = Date(timeIntervalSince1970: tokenExpire)
        self.tokenString = tokenString
        let fechahoy = Date()
        if fechahoy >= self.tokenExpire{
            userdata()
        }else if fechahoy < self.tokenExpire{
            animeseries(token: self.tokenString!)
        }
    }

    func animeseries(token:String){
        deleteAnimes()
        let params = ["access_token":token,"status":"Currently Airing","type":"TV","full_page":"true","airing_data":"true"]
        do {
            let opt = try HTTP.GET(GlobalsVariables.urlmaster+"browse/anime", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("errorANIME: \(err.localizedDescription)")
                    return
                }
                let respuestaseries = JSON(response.data)
                //print(respuestaseries.count)
                for (_, object) in respuestaseries {
                    let te = object["title_english"].stringValue
                    let tj = object["title_japanese"].stringValue
                    let tr = object["title_romaji"].stringValue
                    let imgb = object["image_url_banner"].stringValue
                    let imgl = object["image_url_lge"].stringValue
                    let imgm = object["image_url_med"].stringValue
                    let imgs = object["image_url_sml"].stringValue
                    let ave = object["average_score"].stringValue
                    let idserie = object["id"].stringValue
                    storeAnime(idSerie: idserie,title_english: te,title_japanese: tj,title_romaji: tr,img_banner: imgb,img_lge: imgl,img_med: imgm,img_sml: imgs,average: ave)
                }
                //title_english,title_japanese,title_romaji,image_url_banner,image_url_lge,image_url_med,image_url_sml,average_score,id
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

