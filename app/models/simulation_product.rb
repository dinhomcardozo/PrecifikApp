class SimulationProduct < ApplicationRecord
  belongs_to :production_simulation
  belongs_to :product
end