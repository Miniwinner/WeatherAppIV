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
    
    lazy var refreshButton:UIButton = {
        let button = UIButton()
        button.setTitle("Refresh", for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform.identity
        button.addTarget(self, action: #selector(setValueWeather), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAuthorization()
        reloadData()
        reloadData2()
        didLoadWeather()
        configUI()
        configLayout()
//        setValueLoad()
        }

    //MARK: - UI LAYOUT
    
    func configUI(){
        view.backgroundColor = .white
        view.addSubview(imageBackground)
        view.addSubview(labelName)
        view.addSubview(labelTemp)
        view.addSubview(labelminMaxTemp)
        view.addSubview(labelWeatherFeeling)
//        view.addSubview(refreshButton)

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
            
//            refreshButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 600),
//            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            refreshButton.widthAnchor.constraint(equalToConstant: 100),
//            refreshButton.heightAnchor.constraint(equalToConstant: 50),
            
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
        vm.onWeatherInfoLoaded = {[weak self] in
            self?.setValueLoad()
        }
    }
    
    func reloadData2(){
        vm.loadCollection2 = {[weak self] in
            self?.reloadCollection()
        }
    }
    
    func reloadData(){
            vm.loadCollection =  {[weak self] in
            self?.reloadCollection()
        }
    }
    
    func reloadCollection(){
        DispatchQueue.main.async {
            self.collectionFourDays.reloadData()
            self.tableTenDays.reloadData()
        }
    }
    
    func setValueLoad(){
        DispatchQueue.main.async {
            self.labelName.text = "\(self.vm.currentList.last?.name ?? "")"
            self.labelTemp.text = "\(self.vm.currentList.last?.temp ?? 0)°"
            self.labelWeatherFeeling.text = "\(self.vm.currentList.last?.description ?? "")"
            self.labelminMaxTemp.text = "↓ \(self.vm.currentList.last?.minTemp ?? 0)° ↑ \(self.vm.currentList.last?.maxTemp ?? 0)°"
        }
    }
    
   
    
    //MARK: - ANIMATIONS
    
    @objc func buttonPressed(_ sender: UIButton) {
        // Анимация уменьшения кнопки
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    
    
    @objc func buttonReleased(_ sender: UIButton) {
        // Анимация возврата к исходному размеру
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
    //MARK: - CLL METHODS
    
    @objc func setValueWeather(){
        startLocationManger()
    }
    
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
//                if let placemark = placemarks?.first{
//                    let adress = "\(placemark.locality ?? "") \(placemark.thoroughfare ?? "")"
//                    DispatchQueue.main.async {
//                        self.locationLabel.text = adress
//                    }
//                }
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
        cell.labelHour.text = vm.mainHours[indexPath.row]
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
