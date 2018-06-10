# == Schema Information
#
# Table name: bonus
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer
#  score      :integer
#  level      :integer
#  ontributor :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bonu < ApplicationRecord
end
