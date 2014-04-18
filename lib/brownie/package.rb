module Brownie
	class Package
	
  	  LETTER = "01"
      CUSTOMER_SUPPLIED_PACKAGE = "02"
      TUBE = "03"
      PAK = "04"
      UPS_EXPRESS_BOX = "21"
      UPS_25KG_BOX = "24"
      UPS_10KG_BOX = "25"
      PALLET = "30"
      SMALL_EXPRESS_BOX = "2a"
      MEDIUM_EXPRESS_BOX = "2b"
      LARGE_EXPRESS_BOX = "2c"
      FLATS = "56"
      PARCELS = "57"
      BPM = "58"
      FIRST_CLASS = "59"
      PRIORITY = "60"
      MACHINABLES = "61"
      IRREGULARS = "62"
      PARCEL_POST = "63"
      BPM_PARCEL = "64"
      MEDIA_MAIL = "65"
      BPM_FLAT = "66"
      STANDARD_FLAT = "67"

      
		attr_accessor :package_type,:unit_of_measurement,:length,:width,:height,:weight,:declared_value
	

		def create
			data = Hash.from_xml(template)["Package"]	
	       	data["PackagingType"]["Code"] = self.package_type
	       	data["PackageServiceOptions"]["InsuredValue"]["MonetaryValue"] = self.declared_value.to_s
	       	data["PackageWeight"]["Weight"] = self.weight.nil? ? 1.0.to_s : self.weight.to_s
	       	data["Dimensions"]["UnitOfMeasurement"]["Code"] = self.unit_of_measurement
	       	data["Dimensions"]["Length"] = self.length
	       	data["Dimensions"]["Width"] = self.width
	       	data["Dimensions"]["Height"] = self.height
	   		return data
		end

		private
		def template
			'<Package>
      <PackagingType>
         <Code></Code>
      </PackagingType> 
      <Dimensions>
         <UnitOfMeasurement> <Code></Code> </UnitOfMeasurement>
         <Length></Length> <Width></Width> <Height></Height>
      </Dimensions> 
<PackageWeight>
      <Weight></Weight> 
</PackageWeight>
<PackageServiceOptions>
      <InsuredValue> <MonetaryValue></MonetaryValue>
      </InsuredValue> 
   </PackageServiceOptions>
      </Package>'
		end
	end
end