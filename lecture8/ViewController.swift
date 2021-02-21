//
//  ViewController.swift
//  lecture8
//
//  Created by admin on 08.02.2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLikeTemp: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var myData: Model?
    var city = "Nur-Sultan"
    private var decoder: JSONDecoder = JSONDecoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        fetchData()
    }
    
    
    func fetchData(){
        let url = Constants.host + "?lat=\(Constants.latitude)&lon=\(Constants.longitude)&exclude=alerts,minutely&appid=\(Constants.apiKey)&units=metric"
        AF.request(url).responseJSON { (response) in
            switch response.result{
            case .success(_):
                guard let data = response.data else { return }
                do{
                    let answer = try self.decoder.decode(Model.self, from: data)
                    self.myData = answer
                    self.showCityDetails()
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }catch{
                    print("Parsing error")
                }
                self.showCityDetails()
            case .failure(let err):
                print(err.errorDescription ?? "")
            }
        }
    }
    
    func showCityDetails(){
        cityName.text = city
        temp.text = "\(String(myData?.current.temp ?? 0.0)) °C"
        feelsLikeTemp.text = "\(String(myData?.current.feels_like ?? 0.0)) °C"
        desc.text = myData?.current.weather?[0].description
    }
    
    
    @IBAction func changeCity(_ sender: Any) {
        let alert = UIAlertController(title: "Choose a city", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Nur-Sultan", style: .default) { _ in
            Constants.latitude = "51.15"
            Constants.longitude = "71.47"
            self.city = "Nur-Sultan"
            self.fetchData()
        }
        let action2 = UIAlertAction(title: "Qyzylorda", style: .default) { (_) in
            Constants.latitude = "44.85"
            Constants.longitude = "65.50"
            self.city = "Qyzylorda"
            self.fetchData()
        }
        let action3 = UIAlertAction(title: "Aktau", style: .default) { (_) in
            Constants.latitude = "43.63"
            Constants.longitude = "51.22"
            self.city = "Aktau"
            self.fetchData()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let item = myData?.daily[indexPath.row]
        let date = Date(timeIntervalSince1970: TimeInterval(item!.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        cell.dateLabel.text = localDate
        cell.temperatureLabel.text = "\(item?.temp?.day ?? 0) °C"
        cell.feelsLikeLabel.text = "\(item?.feels_like?.day ?? 0) °C"
        cell.descriptionLabel.text = item?.weather?[0].description
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myData?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let item = myData?.hourly[indexPath.row]
        let date = Date(timeIntervalSince1970: TimeInterval(item!.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        cell.dateLabel.text = localDate
        cell.temperatureLabel.text = "\(item?.temp ?? 0) °C"
        cell.feelsLikeLabel.text = "\(item?.feels_like ?? 0) °C"
        cell.descriptionLabel.text = item?.weather?[0].description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
