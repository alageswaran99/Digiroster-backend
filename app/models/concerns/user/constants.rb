module User::Constants
  extend ActiveSupport::Concern
  
  TITLE_MAPPINGS = {
    'Miss' => 0,
    'Mr'   => 1,
    'Mrs'  => 2,
    'Ms'   => 3,
    'Dr'   => 4,
    'Sir'  => 5
  }

  GENDER_MAPPINGS = {
    'Male' => 1,
    'Female' => 2,
    'Transgender' => 3
  }
end