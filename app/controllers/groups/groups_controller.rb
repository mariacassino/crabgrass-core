class Groups::GroupsController < Groups::BaseController

  def new
    @group = Group.new
  end

  def create
    @group = Group.new params[:group]
    @group.save!
    if @group.valid?
      redirect_to group_url(@group)
      success
    end
  end

  def destroy
  end

end

