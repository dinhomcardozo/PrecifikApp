module InputsHelper
  def formatted_weight(input)
    converted = case input.unit_of_measurement
                when 'kg' then "#{(input.weight * 1000).round(2)} g"
                when 'L'  then "#{(input.weight * 1000).round(2)} mL"
                else
                  "#{input.weight.round(2)} #{input.unit_of_measurement}"
                end
    "#{input.weight} (#{converted})"
  end
end