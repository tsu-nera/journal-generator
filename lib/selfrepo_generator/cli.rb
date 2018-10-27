require "selfrepo_generator"
require "launchy"
require "thor"

module SelfrepoGenerator
  class Cli < Thor
    desc "activity", "show activity"
    def activity
      issue = SelfrepoGenerator.generate
      puts issue.title
      puts issue.body.tr("\r", "\n")

      url = "https://github.com/#{Settings.repository}/issues/#{issue.number}" # TODO
      Launchy.open(url)
    end
  end
end
