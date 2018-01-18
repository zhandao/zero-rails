ParamsProcessor::Config.tap do |it|
  # it.actions                 = %i[ validate! convert set_instance_var set_permitted ]
  # it.strict_check            = true
  # it.prefix                  = ''
  # it.not_passed              = ''
  # it.is_blank                = ''
  # it.wrong_type              = ''
  # it.wrong_size              = ''
  # it.is_not_entity           = ''
  # it.not_in_allowable_values = ''
  # it.not_match_pattern       = ''
  # it.out_of_range            = ''
  # it.wrong_combined_type     = ''
  it.production_msg          = ' validation failed' if Rails.env.production?
end
