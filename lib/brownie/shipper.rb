module Brownie
	class Shipper
		attr_accessor :name,:phone_number,:shipper_number,:account_number,
		:tax_identification_number,
		:address_line1,:address_line2,:city,:state_province_code,:postal_code,:country_code



		def create
			data = Hash.from_xml(template)["Shipper"]
   			data["Name"] = self.name
   			data["PhoneNumber"] = self.phone_number
   			data["ShipperNumber"] = self.account_number
   			data["TaxIdentificationNumber"] = self.tax_identification_number
	   		data["Address"]["AddressLine1"] = self.address_line1
            data["Address"]["AddressLine2"] = self.address_line2 if !self.address_line2.nil?
	   		data["Address"]["City"] = self.city
	   		data["Address"]["StateProvinceCode"] = self.state_province_code
	   		data["Address"]["PostalCode"] = self.postal_code
	   		data["Address"]["CountryCode"] = self.country_code
	   		return data
		end

		private
		def template
			' <Shipper>
				   <Name></Name>
				   <PhoneNumber></PhoneNumber>
				   <ShipperNumber></ShipperNumber>
				   <TaxIdentificationNumber></TaxIdentificationNumber>
				   <Address>
				      <AddressLine1></AddressLine1>
				      <City></City>
				      <StateProvinceCode></StateProvinceCode>
				      <PostalCode></PostalCode>
				      <PostcodeExtendedLow />
				      <CountryCode></CountryCode>
				   </Address>
				</Shipper>'
		end
	end
end