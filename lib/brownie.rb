require 'active_support/all'
require 'rest_client'
require 'brownie/common'
require 'brownie/credentials'
require 'brownie/shipper'
require 'brownie/ship_to'
require 'brownie/ship_from' 
require 'brownie/package'
require 'brownie/shipment'
module Brownie
 

   class Dimensions
      INCHES = "IN"
      CENTIMETERS = "CM"
      METRIC_UNITS_OF_MEASUREMENT = "00"
      ENGLISH_UNITS_OF_MEASUREMENT = "01"
   end

   class Weight
      POUNDS = "LBS"
      KILOGRAMS = "KGS"
       METRIC_UNITS_OF_MEASUREMENT = "00"
      ENGLISH_UNITS_OF_MEASUREMENT = "01"
   end

   class ServiceCodes
      NEXT_DAY_AIR = "01"
      SECOND_DAY_AIR = "02"
      GROUND = "03"
      EXPRESS = "07"
      Expedited = "08"
      Ups_Standard = "11"
      THREE_DAY_SELECT = "12"
      NEXT_DAY_AIR_SAVER = "13"
      NEXT_DAY_AIR_EARLY_AM = "14"
      EXPRESS_PLUS = "54"
   end


end

