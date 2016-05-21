class TemplatesController < ApplicationController

  def index
    @template_data = interactor.all
  end

  private

    def interactor
      TemplateInteractor.instance
    end

end