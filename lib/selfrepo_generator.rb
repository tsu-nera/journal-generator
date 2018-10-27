# frozen_string_literal: true

require "erb"

require "selfrepo_generator/version"
require "selfrepo_generator/github"

module SelfrepoGenerator
  class << self
    def generate
      reports = {
        fitbit: "test"
      }
      github = Github.new

      template = File.read(File.expand_path("../templates/template.md.erb", __dir__))
      erb = ERB.new(template, 0, "%-")

      title = daily_report_title
      body = result(erb, reports)
      body = body.tr("\n", "\r")
      issues = github.find_same_title_issue(title)

      if issues.first
        github.daily_report_issue(issues.first.number)
        github.update_issue_body(issues.first.number, body)
      else
        github.create_issue(title: title, body: body, assignee: @client.user.login, labels: "daily report")
      end
    end

    private

    def result(erb, reports)
      erb.result(binding)
    end

    def daily_report_title
      Time.now.strftime("日報_%Y%m%d_#{Settings.username}").to_s
    end
  end
end
