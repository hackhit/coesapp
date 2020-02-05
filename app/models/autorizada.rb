class Autorizada < ApplicationRecord
  belongs_to :restringida
  belongs_to :usuario
end
