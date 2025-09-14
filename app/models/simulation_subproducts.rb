
class SimulationSubproduct < ApplicationRecord
  belongs_to :production_simulation
  belongs_to :subproduct
end