//
//  FourDaysCollectionViewCell.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 13.12.23.
//

import UIKit

class FourDaysCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var labelHour:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var labelTemp:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var imageWeather:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = .clear
        return image
    }()
    //
    func configData(model:ForeCastModel){
        labelTemp.text = "\(((model.temp - 273.15) * 10).rounded(.toNearestOrAwayFromZero) / 10)°"
        imageWeather.image = UIImage(named: model.icon)
    }
        
    func setupUI(){
        self.backgroundColor = .clear
        self.addSubview(labelHour)
        self.addSubview(labelTemp)
        self.addSubview(imageWeather)
    }
    
    func configLayout(){
        NSLayoutConstraint.activate([
            
        labelHour.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
        labelHour.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        labelHour.heightAnchor.constraint(equalToConstant: 35),
        labelHour.widthAnchor.constraint(equalToConstant: 50),
        
        imageWeather.topAnchor.constraint(equalTo: self.topAnchor,constant: 50),
        imageWeather.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        imageWeather.heightAnchor.constraint(equalToConstant: 50),
        imageWeather.widthAnchor.constraint(equalToConstant: 50),
        
        labelTemp.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -5),
        labelTemp.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
        labelTemp.widthAnchor.constraint(equalToConstant: 50),
        labelTemp.heightAnchor.constraint(equalToConstant: 30),
        
        ])
    }
    
    
}
