//
//  TenTableViewCell.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 15.12.23.
//

import UIKit

class TenTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        configLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    lazy var labelDay:UILabel = {
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
    
    func setupUI(){
        self.addSubview(labelDay)
        self.addSubview(labelTemp)
        self.addSubview(imageWeather)
    }
    
    func configData(model:TenDaysRawModel){
        labelTemp.text = "\(model.temp)"
        imageWeather.image = UIImage(named: model.description)
//        print(model.te)
    }
    
    func configLayout(){
        NSLayoutConstraint.activate([
            
        labelDay.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
        labelDay.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5),
        labelDay.heightAnchor.constraint(equalToConstant: 35),
        labelDay.widthAnchor.constraint(equalToConstant: 50),
        
        imageWeather.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
        imageWeather.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 70),
        imageWeather.heightAnchor.constraint(equalToConstant: 35),
        imageWeather.widthAnchor.constraint(equalToConstant: 35),
        
        labelTemp.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
        labelTemp.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 150),
        labelTemp.widthAnchor.constraint(equalToConstant: 80),
        labelTemp.heightAnchor.constraint(equalToConstant: 35),
        
        ])
    }
    
}
