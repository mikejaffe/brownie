require 'active_support/all'
require 'rest_client'
module Brownie
  


   class Shipment
   		attr_accessor :request,:errors,:account_number,:tracking_number,:shipment_digest,:credentials,:shipper,:ship_to,
         :ship_from,:response,:service_code,:label_binary,:api_domain,
         :environment,:data,:shipment_xml,:template,:package

 
   		def initialize(shipment=nil)
   			    self.shipment_data = shipment if !shipment.nil?
            self.credentials = Credentials.new
            self.shipper = Shipper.new
            self.ship_to = ShipTo.new
            self.ship_from = ShipFrom.new
            self.package = Package.new
            self.template = Common::template_to_hash(:ship_confirm)
            
   		end



   		def confirm
        
        data = self.template["Shipment"]
        data["PaymentInformation"]["Prepaid"]["BillShipper"]["AccountNumber"] = self.account_number
        data["Service"]["Code"] = self.service_code 
        data["Package"] = self.package.create 
        data["Shipper"] = self.shipper.create
        data["ShipTo"] = self.ship_to.create
        data["ShipFrom"] = self.ship_from.create
       
        self.template["Shipment"] = data
        request_template = {"ShipmentConfirmRequest" => self.template}
			  shipment_xml_str = request_template["ShipmentConfirmRequest"].to_xml(:root => "ShipmentConfirmRequest")
 
   			self.response = RestClient.post("https://#{Common::domain}/ups.app/xml/ShipConfirm","#{access_request_header}#{shipment_xml_str}")
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

     def label(_shipment_digest,path)
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


        

        label_response = RestClient.post("https://#{Common::domain}/ups.app/xml/ShipAccept","#{access_request_header}#{label_xml}")
        label_hash = Hash.from_xml(label_response)
        self.label_binary = label_hash["ShipmentAcceptResponse"]["ShipmentResults"]["PackageResults"]["LabelImage"]["GraphicImage"]
        File.open(path, 'wb') do|f|
          f.write(Base64.decode64(self.label_binary))
        end

     end
          

   		private
         def access_request_header
            '<?xml version="1.0"?>
                  <AccessRequest xml:lang="en-US">
                  <AccessLicenseNumber>' + self.credentials.license_number + '</AccessLicenseNumber>
                  <UserId>' + self.credentials.user_id + '</UserId>
                  <Password>' + self.credentials.password + '</Password>
                  </AccessRequest>'
         end

   end
 


end
