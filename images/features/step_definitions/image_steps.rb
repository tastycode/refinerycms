Given /^I have no images$/ do
  ::Refinery::Image.destroy_all
end

When /^I attach the image at "([^\"]*)"$/ do |file_path|
  attach_file('image_image', File.join(File.expand_path('../../uploads/', __FILE__), file_path))
end

Then /^the image "([^\"]*)" should have uploaded successfully$/ do |file_name|
  ::Refinery::Image.find_by_image_name(file_name).nil?.should == false
end

Then /^the image should have size "([^\"]*)"$/ do |size|
  ::Refinery::Image.first.size.should == size.to_i
end

Then /^the image should have width "([^\"]*)"$/ do |width|
  ::Refinery::Image.first.width.should == width.to_i
end

Then /^the image should have height "([^\"]*)"$/ do |height|
  ::Refinery::Image.first.height.should == height.to_i
end

Then /^the image should have mime_type "([^\"]*)"$/ do |mime_type|
  ::Refinery::Image.first.mime_type.should == mime_type.to_s
end

Then /^I should have ([0-9]+) images?$/ do |number|
  ::Refinery::Image.count.should == number.to_i
end

When /^I upload the image at "([^\"]*)"$/ do |file_path|
  original_stderr = $stderr.dup
  $stderr.reopen(Tempfile.new('stderr'))
  visit new_refinery_admin_image_path
  attach_file('image_image', File.join(File.expand_path('../../uploads/', __FILE__), file_path))
  click_button 'Save'
  $stderr.reopen(original_stderr)
end
