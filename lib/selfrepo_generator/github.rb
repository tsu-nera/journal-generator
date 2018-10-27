module SelfrepoGenerator
  class Github
    def initialize(client)
      @client = client
      @login = client.login
    end

    def update_issue_body(issue_number, body)
      @client.update_issue(Settings.repository, issue_number, { body: body })
    end

    def create_issue(title:, body:, assignee: nil, labels: nil)
      option = {
        assignee: assignee,
        labels: labels
      }
      @client.create_issue(Settings.repository, title, body, option)
    end

    def find_same_title_issue(title)
      q = " '#{title}' repo:#{Settings.repository} assignee:#{@client.user.login} state:open"
      result = @client.search_issues(q)
      result.items
    end

    def daily_report_issue(issue_number)
      @client.issue(Settings.repository, issue_number)
    end
  end
end
