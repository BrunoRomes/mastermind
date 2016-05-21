require "singleton"
class TemplateInteractor
  include Singleton

  def all
    data = []
    10.times { |i| data << { number: i} }
    data
  end

end