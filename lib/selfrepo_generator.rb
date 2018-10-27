# frozen_string_literal: true

require "selfrepo_generator/version"
require 'octokit'
require 'erb'
require 'selfrepo_generator/configurable'

module SelfrepoGenerator
  class << self
    def gh_client
      Octokit::Client.new Configurable.github_octokit_options
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

      template = File.read(File.expand_path("../templates/template.md.erb", __dir__))
      erb = ERB.new(template, 0, "%-")
      body = result(erb, reports)
      body = body.tr("\n", "\r")
      title = daily_report_title
      issues = Github.new(gh_client).find_same_title_issue(title)
      title = "wip #{title}"
      issue = if issues.first
                issue = Github.new(gh_client).daily_report_issue(issues.first.number)
                Github.new(gh_client).update_issue_body(issues.first.number, body)
              else
                Github.new(gh_client).create_issue(title: title, body: body, assignee: gh_client.user.login, labels: "daily report")
              end
      issue
    end
  end
end
