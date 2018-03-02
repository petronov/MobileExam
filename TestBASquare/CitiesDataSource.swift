//
//  CitiesDataSource.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//
//=============================================================================================

import Foundation

//=============================================================================================
//
//     protocol CitiesDataSource
//
//=============================================================================================

protocol CitiesDataSource
{
    //---------------------------------------------------------------------------------------------
    
    var selectedCityNumber: Int? { get set }
    var cities: Array<String> { get }
    
    //---------------------------------------------------------------------------------------------
    
    func getSelectedCityName() -> String?
    
    //---------------------------------------------------------------------------------------------
    
    func getPrevCityName() -> String?
    
    //---------------------------------------------------------------------------------------------
    
    func getNextCityName() -> String?
    
    //---------------------------------------------------------------------------------------------
    
    func selectCityByName(_ cityName: String)
    
    //---------------------------------------------------------------------------------------------
}

//==== protocol CitiesDataSource ==============================================================

