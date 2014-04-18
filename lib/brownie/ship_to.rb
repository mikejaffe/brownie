module Brownie
	class ShipTo
		attr_accessor :company_name,:attention_name,:phone_number,:attention_name,:address_line1,:address_line2,:city,:state_province_code,:postal_code,:country_code

		def create
			data = Hash.from_xml(template)["ShipTo"]	
	   		data["CompanyName"] = self.company_name
	   		data["AttentionName"] = self.attention_name
	   		data["PhoneNumber"] = self.phone_number
	   		data["AttentionName"] = self.attention_name
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
			'<ShipTo>
	         <CompanyName></CompanyName>
	         <AttentionName></AttentionName>
	         <PhoneNumber></PhoneNumber>
	         <Address>
	            <AddressLine1></AddressLine1>
	            <City></City>
	            <StateProvinceCode></StateProvinceCode>
	            <PostalCode></PostalCode>
	            <CountryCode></CountryCode>
	         </Address>
	      </ShipTo>'
		end
	end
end