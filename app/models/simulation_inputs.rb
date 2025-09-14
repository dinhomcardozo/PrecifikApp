
class SimulationInput < ApplicationRecord
  belongs_to :production_simulation
  belongs_to :input
end