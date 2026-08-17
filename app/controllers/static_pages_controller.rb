class StaticPagesController < ApplicationController
  def about
    @organisations_count = Organisation.count
    render "about/index"
  end

  def contact
    render "contact/index"
  end

  def show
    render "#{params['']}/index"
  end
end
