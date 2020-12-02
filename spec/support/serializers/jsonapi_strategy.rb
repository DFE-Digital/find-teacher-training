require 'factory_bot'

class JSONAPIStrategy
  def association(runner)
    runner.run
  end

  def result(evaluation)
    evaluation.object
  end
end

FactoryBot.register_strategy(:jsonapi, JSONAPIStrategy)
