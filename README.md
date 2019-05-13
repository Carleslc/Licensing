# Licensing

_Simple Rails App to add Licenses to your projects._

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/carleslc)

Manage licenses:

1. Access to Database with `rails console`
2. Retrieve all products: `Product.all`
3. Retrieve all licenses: `License.all`
4. Look for a license: `License.where(key: "KEY")`
5. Update a license
  * Get the `license_id` looking for your license
  * `l = License.find(license_id)`
  * `l.quantity = 6` (example)
  * `l.save`
6. Retrieve activations: `Activation.where(license_id: license_id)`
7. Count activations: `Activation.where(license_id: license_id).count`
8. Create a product or license: `Product.create` / `License.create` / `l = License.new` and `l.save`
https://guides.rubyonrails.org/active_record_basics.html#create
