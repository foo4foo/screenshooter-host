class ScreenshotController < ApplicationController
  def create
    @command = BashExecuter.call("import -window root")

    if @command.success?
      render :create
    else
      render json: {error: @command.errors[:execution].join(", ")}, status: :unprocessable_entity
    end
  end
end
