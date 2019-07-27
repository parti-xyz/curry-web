class Voteaward::AwardsController < Voteaward::BaseController
  def index
    @awards = Voteaward::Award.all
  end

private
  def vote_params
    params.require(:award).permit(:id)
  end
end
