require "securerandom"

DIR_PATH = "public/screenshots/"

class BashExecuter
  prepend SimpleCommand
  attr_reader :cmd

  def initialize(cmd)
    @file = "#{SecureRandom.hex(10)}.png"
    @path = "#{DIR_PATH}#{@file}"
    @cmd = cmd
  end

  def call
    if true
      # call bash cmd
      return system("#{@cmd} #{@path}") ? "/screenshots/#{@file}" : nil
    else
      errors.add(:execution, "Execution failed")
    end
    nil
  end
end
