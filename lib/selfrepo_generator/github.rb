module SelfrepoGenerator
  class Github
    def initialize(client)
      @client = client
      @login = client.login
    end

    def update_issue_body(issue_number, body)
      @client.update_issue("", issue_number, { body: body })
    end

    def create_issue(title:, body:, assignee: nil, labels: nil)
      option = {
        assignee: assignee,
        labels: labels
      }
      @client.create_issue("", title, body, option)
    end
  end
end
