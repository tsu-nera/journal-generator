# frozen_string_literal: true

require "selfrepo_generator/version"
require "octokit"
require "erb"

require "selfrepo_generator/github"

module SelfrepoGenerator
  class << self
    def gh_client
      Octokit::Client.new access_token: Settings.github_access_token
    end

    def result(erb, reports)
      erb.result(binding)
    end

    def daily_report_title
      Time.now.strftime("日報_%Y%m%d").to_s
    end

    def generate
      reports = {
        fitbit: "test"
      }
      github = Github.new(gh_client)

      template = File.read(File.expand_path("../templates/template.md.erb", __dir__))
      erb = ERB.new(template, 0, "%-")
      body = result(erb, reports)
      body = body.tr("\n", "\r")
      title = daily_report_title
      issues = github.find_same_title_issue(title)
      if issues.first
        github.daily_report_issue(issues.first.number)
        github.update_issue_body(issues.first.number, body)
      else
        github.create_issue(title: title, body: body, assignee: gh_client.user.login, labels: "daily report")
      end
    end
  end
end
