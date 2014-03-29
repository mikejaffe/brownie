require 'active_support/all'
require 'rest_client'
require './brownie/credentials'
require './brownie/shipper'
require './brownie/ship_to'
require './brownie/ship_from' 
module Brownie
  


   class Shipment
   		attr_accessor :request,:errors,:account_number,:tracking_number,:shipment_digest,:credentials,:shipper,:ship_to,
         :ship_from,:response,:service_code,:package_type,:declared_value,:package_weight,:label_binary

   		attr_writer :shipment_data,:shipment_xml

 
   		def initialize(shipment=nil)
   			self.shipment_data = shipment if !shipment.nil?
            self.credentials = Credentials.new
            self.shipper = Shipper.new
            self.ship_to = ShipTo.new
            self.ship_from = ShipFrom.new
   		end



   		def confirm
   			test = template_hash
   			shipment = test["ShipmentConfirmRequest"]["Shipment"]

            shipment["PaymentInformation"]["Prepaid"]["BillShipper"]["AccountNumber"] = self.account_number
            shipment["Service"]["Code"] = self.service_code 
            shipment["Package"]["PackagingType"]["Code"] = self.package_type
            shipment["Package"]["PackageServiceOptions"]["InsuredValue"]["MonetaryValue"] = self.declared_value.to_s
            shipment["Package"]["PackageWeight"]["Weight"] = self.package_weight.nil? ? 1.0.to_s : self.package_weight.to_s

   			shipment["Shipper"]["Name"] = self.shipper.name
   			shipment["Shipper"]["PhoneNumber"] = self.shipper.phone_number
   			shipment["Shipper"]["ShipperNumber"] = self.account_number
   			shipment["Shipper"]["TaxIdentificationNumber"] = self.shipper.tax_identification_number
	   		shipment["Shipper"]["Address"]["AddressLine1"] = self.shipper.address_line1
            shipment["Shipper"]["Address"]["AddressLine2"] = self.shipper.address_line2 if !self.shipper.address_line2.nil?
	   		shipment["Shipper"]["Address"]["City"] = self.shipper.city
	   		shipment["Shipper"]["Address"]["StateProvinceCode"] = self.shipper.state_province_code
	   		shipment["Shipper"]["Address"]["PostalCode"] = self.shipper.postal_code
	   		shipment["Shipper"]["Address"]["CountryCode"] = self.shipper.country_code


	   		shipto = shipment["ShipTo"]
	   		shipto["CompanyName"] = self.ship_to.company_name
	   		shipto["AttentionName"] = self.ship_to.attention_name
	   		shipto["PhoneNumber"] = self.ship_to.phone_number
	   		shipto["AttentionName"] = self.ship_to.attention_name
	   		shipto["Address"]["AddressLine1"] = self.ship_to.address_line1
            shipto["Address"]["AddressLine2"] = self.ship_to.address_line2 if !self.ship_to.address_line2.nil?
   			shipto["Address"]["City"] = self.ship_to.city
   			shipto["Address"]["StateProvinceCode"] = self.ship_to.state_province_code
   			shipto["Address"]["PostalCode"] = self.ship_to.postal_code
   			shipto["Address"]["CountryCode"] = self.ship_to.country_code
	   		

            shipfrom = shipment["ShipFrom"]
            shipfrom["CompanyName"] = self.ship_from.company_name
            shipfrom["AttentionName"] = self.ship_from.attention_name
            shipfrom["PhoneNumber"] = self.ship_from.phone_number
            shipfrom["AttentionName"] = self.ship_from.attention_name
            shipfrom["Address"]["AddressLine1"] = self.ship_from.address_line1
            shipfrom["Address"]["AddressLine2"] = self.ship_from.address_line2 if !self.ship_from.address_line2.nil?
            shipfrom["Address"]["City"] = self.ship_from.city
            shipfrom["Address"]["StateProvinceCode"] = self.ship_from.state_province_code
            shipfrom["Address"]["PostalCode"] = self.ship_from.postal_code
            shipfrom["Address"]["CountryCode"] = self.ship_from.country_code


				shipment_xml_str = test["ShipmentConfirmRequest"].to_xml(:root => "ShipmentConfirmRequest")
	 
   			self.response = RestClient.post("https://wwwcie.ups.com/ups.app/xml/ShipConfirm","#{access_request_header}#{shipment_xml_str}")
   			if self.response.code.eql?(200)
   				response_hash = Hash.from_xml(response)
               if response_hash["ShipmentConfirmResponse"]["Response"]["ResponseStatusCode"].eql?("0")
                  self.errors = response_hash["ShipmentConfirmResponse"]["Response"]["Error"]
                  return false
               end

   				self.tracking_number = response_hash["ShipmentConfirmResponse"]["ShipmentIdentificationNumber"]
   				self.shipment_digest = response_hash["ShipmentConfirmResponse"]["ShipmentDigest"]
   				return true

   			else 
   				raise "In-valid request #{response}"
   			end
   		end

         def accept_label(_shipment_digest=nil,path="shipping_label.gif")
            shipment_digest = _shipment_digest.nil? ? @shipment_digest : _shipment_digest
             label_xml = '<?xml version="1.0" encoding="ISO-8859-1"?>
                <ShipmentAcceptRequest>
                <Request>
                <TransactionReference>
                <CustomerContext></CustomerContext>
                </TransactionReference>
                <RequestAction>ShipAccept</RequestAction>
                <RequestOption>1</RequestOption>
                </Request>
                <ShipmentDigest>' + shipment_digest +  '</ShipmentDigest>
                </ShipmentAcceptRequest>'

            label_response = RestClient.post("https://wwwcie.ups.com/ups.app/xml/ShipAccept","#{header}#{label_xml}")
            label_hash = Hash.from_xml(label_response)
            self.label_binary = label_hash["ShipmentAcceptResponse"]["ShipmentResults"]["PackageResults"]["LabelImage"]["GraphicImage"]
            File.open(path, 'wb') do|f|
              f.write(Base64.decode64(self.label_binary))
            end

         end
          

   		private
   		def template_hash
   			digest_xml_file = File.open("./xml/ship_confirm.xml", "rb")
   			@shipment_xml = digest_xml_file.read
   			Hash.from_xml(@shipment_xml)
   		end

         def access_request_header
            '<?xml version="1.0"?>
                  <AccessRequest xml:lang="en-US">
                  <AccessLicenseNumber>' + self.credentials.license_number + '</AccessLicenseNumber>
                  <UserId>' + self.credentials.user_id + '</UserId>
                  <Password>' + self.credentials.password + '</Password>
                  </AccessRequest>'
         end

   end


   class Package
      BAG = "01"
      BOX = "02"
      CARTON = "03"
      CRATE = "04"
      DRUM = "05"
      PALLET = "06"
      ROLL = "07"
      TUBE = "08"
   end

   class ServiceCodes
      STANDARD = "11"
      GROUND = "03"
      E3DAYSELECT = "12"
      E2NDDAYAIR = "02"
      E2NDDAYAIRAM = "59"
      NEXTDAYAIRSAVER = "13"
      NEXTDAYAIR = "01"
      NEXTDAYAIREARLYAM = "14"
      UPSWORLDWIDEEXPRESS = "07"
      WORLDWIDEEXPRESSPLUS = "54"
      UPSWORDWIDESAVER = "65"
      UPSWORLDWIDEEXPEDITED = "08"
 
   end


end

