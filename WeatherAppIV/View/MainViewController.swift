//
//  ViewController.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 10.12.23.
//

import UIKit
import CoreLocation



class MainViewController: UIViewController {

    let locationManager = CLLocationManager()
    let vm = WheatherViewModel()
    
    //MARK: - UI ELEMENTS
    
    lazy var labelTemp:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 90, weight: .thin)
        return label
    }()
    
    lazy var imageBackground:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "back2")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var labelName:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelWeatherFeeling:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    lazy var labelminMaxTemp:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.backgroundColor = .clear
        label.textAlignment = .center

        return label
    }()
    
    lazy var collectionFourDays:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.layer.cornerRadius = 15
        collection.backgroundColor = UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 0.5)
        collection.alwaysBounceVertical = false
        collection.alwaysBounceHorizontal = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    let tableTenDays:UITableView = {
        let collection = UITableView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.layer.cornerRadius = 15
        collection.backgroundColor = UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 0.5)
        collection.showsVerticalScrollIndicator = false

        return collection
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAuthorization()
        reloadDataTen()
        reloadDataFour()
        didLoadWeather()
        configUI()
        configLayout()
        }

    //MARK: - UI LAYOUT
    
    func configUI(){
        view.backgroundColor = .white
        view.addSubview(imageBackground)
        view.addSubview(labelName)
        view.addSubview(labelTemp)
        view.addSubview(labelminMaxTemp)
        view.addSubview(labelWeatherFeeling)

        view.addSubview(tableTenDays)
        tableTenDays.delegate = self
        tableTenDays.dataSource = self
        tableTenDays.register(TenTableViewCell.self, forCellReuseIdentifier: "ten")
        
        view.addSubview(collectionFourDays)
        collectionFourDays.collectionViewLayout = foreCastWeather()
        collectionFourDays.delegate = self
        collectionFourDays.dataSource = self
        collectionFourDays.register(FourDaysCollectionViewCell.self, forCellWithReuseIdentifier: "four")
        
    }
    
    func configLayout(){
        
        NSLayoutConstraint.activate([
        
            imageBackground.topAnchor.constraint(equalTo: view.topAnchor),
            imageBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            labelName.topAnchor.constraint(equalTo: view.topAnchor,constant: 80),
            labelName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelName.widthAnchor.constraint(equalToConstant: 150),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            
            labelTemp.topAnchor.constraint(equalTo: labelName.bottomAnchor,constant: 10),
            labelTemp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTemp.heightAnchor.constraint(equalToConstant: 100),
            labelTemp.widthAnchor.constraint(equalToConstant: 200),
        
            labelWeatherFeeling.topAnchor.constraint(equalTo: labelTemp.bottomAnchor,constant: 8),
            labelWeatherFeeling.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelWeatherFeeling.widthAnchor.constraint(equalToConstant: 150),
            labelWeatherFeeling.heightAnchor.constraint(equalToConstant: 25),
            
            labelminMaxTemp.topAnchor.constraint(equalTo: labelWeatherFeeling.bottomAnchor,constant: 8),
            labelminMaxTemp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelminMaxTemp.widthAnchor.constraint(equalToConstant: 250),
            labelminMaxTemp.heightAnchor.constraint(equalToConstant: 25),
            
            collectionFourDays.topAnchor.constraint(equalTo: view.topAnchor,constant:300),
            collectionFourDays.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            collectionFourDays.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            collectionFourDays.heightAnchor.constraint(equalToConstant: 150),
            
            tableTenDays.topAnchor.constraint(equalTo: view.topAnchor,constant: 500),
            tableTenDays.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            tableTenDays.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            tableTenDays.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
    }
    
    func foreCastWeather() -> UICollectionViewCompositionalLayout {
       let size = NSCollectionLayoutSize(
           widthDimension: .estimated(70),
           heightDimension: .absolute(146)
       )
       
       let item = NSCollectionLayoutItem(layoutSize: size)
       
       let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, repeatingSubitem: item, count: 12)
       group.interItemSpacing = NSCollectionLayoutSpacing.fixed(2)
       
       let section = NSCollectionLayoutSection(group: group)
       section.interGroupSpacing = 2
       section.contentInsets = .init(
           top: 2,
           leading: 2,
           bottom: 2,
           trailing: 2
       )
       
       return UICollectionViewCompositionalLayout(section: section)
   }
    
    //MARK: - DATA LOADING
    
    func didLoadWeather(){
        vm.loadCurrentWeather = {[weak self] in
            self?.setValueLoad()
        }
    }
    
    func reloadDataTen(){
        vm.loadForeCastTen = {[weak self] in
            self?.reloadCollectionTen()
        }
    }
    
    func reloadDataFour(){
            vm.loadForeCastFour =  {[weak self] in
            self?.reloadCollectionFour()
        }
    }
    
    func reloadCollectionTen(){
        DispatchQueue.main.async {
            self.tableTenDays.reloadData()
        }
    }
    
    
    func reloadCollectionFour(){
        DispatchQueue.main.async {
            self.collectionFourDays.reloadData()
        }
    }
    
    func setValueLoad(){
        DispatchQueue.main.async {
            self.labelName.text = "\(self.vm.currentList.first?.name ?? "")"
            self.labelTemp.text = "\(self.vm.currentList.first?.temp ?? 0)°"
            self.labelWeatherFeeling.text = "\(self.vm.currentList.first?.description ?? "")"
            self.labelminMaxTemp.text = "↓ \(self.vm.currentList.first?.minTemp ?? 0)° ↑ \(self.vm.currentList.last?.maxTemp ?? 0)°"
        }
    }
    
    //MARK: - ANIMATIONS
    
   
    
    
    
    
    
    
    
    
    //MARK: - CLL METHODS
    
  
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationManger()
        default:
            // Обработка неавторизованного состояния
            break
        }
    }
    
    func startLocationManger() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
}

//MARK: - CLLOCATION DELEGATE

extension MainViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  let lastLocation = locations.last{
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(lastLocation){ placemarks,error in

            }
            
            vm.loadWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            vm.loadWeatherInfoForeCast(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            vm.loadWeatherInfoForeCastTen(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            print(lastLocation.coordinate.latitude,lastLocation.coordinate.longitude)
            
        }
    }
    

    
    
    
}

//MARK: - COLLECTION VIEW

extension MainViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.cellCount()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionFourDays.dequeueReusableCell(withReuseIdentifier: "four", for: indexPath) as! FourDaysCollectionViewCell
        cell.configData(model: vm.itemForCell(index: indexPath.row))
        return cell
    }
    
    
}

//MARK: - TABLE VIEW

extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.limitedArrayTen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableTenDays.dequeueReusableCell(withIdentifier: "ten", for: indexPath) as! TenTableViewCell
        cell.labelDay.text = vm.days[indexPath.row]
        cell.configData(model: vm.itemForCellTen(index: indexPath.row))
        cell.backgroundColor = .clear
        return cell
    }
    
    
}
