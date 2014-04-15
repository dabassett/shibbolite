FactoryGirl.define do
  factory :shibboleth_attributes, class: Hash do
    displayName     'Test Guy'
    mail            { "#{umbcusername}@umbc.edu" }
    umbcDepartment  'idunno'
    umbcaffiliation 'student'
    umbccampusid    'JJ01234'
    umbclims        '001203948209348'
    umbcusername    'tguy1'

    initialize_with { attributes }
  end

  # call with #with_indifferent_access to allow 'string keys'
  #  eg environment_hash["displayName"] #=> "Test Guy"
  factory :environment_hash, class: Hash do
    displayName     'Test Guy'
    mail            { "#{umbcusername}@umbc.edu" }
    umbcDepartment  'idunno'
    umbcaffiliation 'student'
    umbccampusid    'JJ01234'
    umbclims        '001203948209348'
    umbcusername    'tguy1'
    other_environment_variable 'unwanted'

    initialize_with { attributes }
  end
end