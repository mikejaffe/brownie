# brownie

Brownie helps you create shipments via UPS.com's developer api.  You can create shipments, and labels.

Future releasess will have address valdation, and tracking 

## Install
	gem 'brownie'
	

## Usage 

	b = Brownie::Shipment.new
	b.account_number = "YOUR UPS ACCOUNT NUMBER"
	b.credentials.license_number = "YOUR UPS DEVELOPER API LICENCE NUMBER"
	b.credentials.user_id = "YOUR UPS LOGIN"
	b.credentials.password = "YOU UPS PASSWORD"

	b.shipper.account_number = b.account_number
	b.shipper.name = "Sample Company Name"
	b.shipper.phone_number = "555-666-7777"
	b.shipper.tax_identification_number = "1234567890"
	b.shipper.address_line1 = "123 Test Street"
	b.shipper.city = "Test Town"
	b.shipper.state_province_code = "NY"
	b.shipper.postal_code = "10021"
	b.shipper.country_code = "US"

	b.ship_to.company_name = "SHIP TO COMPANY/NAME"
	b.ship_to.attention_name = "SHIP TO NAME"
	b.ship_to.phone_number = "5556667777"
	b.ship_to.address_line1 = "555 Test Rd"
	b.ship_to.city = "Test City"
	b.ship_to.state_province_code = "CA"
	b.ship_to.postal_code = "90212"
	b.ship_to.country_code = "US"

	b.ship_from.company_name = "Sample Company Name"
	b.ship_from.attention_name = "Sample NAme"
	b.ship_from.phone_number = "5556667777"
	b.ship_from.address_line1 = "123 Test Street"
	b.ship_from.state_province_code = "NY"
	b.ship_from.city = "Test Town"
	b.ship_from.postal_code = "07738"
	b.ship_from.country_code = "US"

	b.service_code = Brownie::ServiceCodes::GROUND
	b.package_type = Brownie::Package::BOX
	b.declared_value = 100

	# Confirm and Validate Shipment
	if b.confirm
	   puts b.tracking_number
	else 
	   puts b.errors
	end


	# Accept and Download Label
	b.label(b.shipment_digest,"/path/to/save/label.gif")




## Contributing to brownie
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Michael Jaffe. See LICENSE.txt for
further details.

