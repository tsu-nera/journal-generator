require "selfrepo_generator"
require "launchy"

module SelfrepoGenerator
  class Cli
    def activity
      issue = SelfrepoGenerator.generate(options)
      puts issue.title
      puts issue.body.tr("\r", "\n")

      url = "https://github.com/tsu-nera/daily_report/issues/#{issue.number}" # TODO
      Launchy.open(url)
    end
  end
end
