# Jekyll tags to support GitHub buttons on your site
#
# For more info: https://github.com/ntkme/github-buttons
# 
# Installation:
# 1. Copy this gist to Jekyll's `_plugins` folder
# 2. Include the following script tag in your default template:
#    <script async defer id="github-bjs" src="//buttons.github.io/buttons.js"></script>
# 
# Usage: 
#   {% github_star_button <github_username>,<github_repo>,<display_count[bool]>,<icon-type>,<style> %}
#   {% github_follower_button <github_username>,"",<display_count[bool]>,<icon-type>,<style> %}
#   {% github_fork_button <github_username>,<github_repo>,<display_count[bool]>,<icon-type>,<style> %}
#   
#   In examples, the only required parameters are <github_username> and <github_repo> (except for follower button)
#   
#   By @tehsuck
#   
module Jekyll
 
  class GitHubButtonTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @options = GitHubButtonTag::split_params(markup)
      @user_name = @options[0]
      @repo_name = @options[1].length > 0 ? @options[1] : nil
      @use_count = GitHubButtonTag::to_bool(@options[2])
      @style = @options[4] || "mega"
    end
    def get_data_count_template
      ">"
    end
    def render(context)
      [
        "<a",
        "href=\"https://github.com/#{@user_name}/#{@repo_name}\"",
        "class=\"github-button\"",
        "data-style=\"#{@style}\"",
        "data-icon=\"#{@icon}\"",
        get_data_count_template,
        @link_text,
        "</a>"
      ].join(' ')
    end
    def self.to_bool(arg)
      return true if arg == true || arg =~ (/^(true|t|yes|y|1)$/i)
      return false if arg == false || arg == nil || arg.blank? || arg =~ (/^(false|f|no|n|0)$/i)
      raise ArgumentError.new("invalid value for Boolean: \"#{arg}\"")
    end
    def self.split_params(params)
      params.split(',').map(&:strip)
    end
  end

  class GitHubStarButton < GitHubButtonTag
    def initialize(tag_name, markup, tokens)
      super(tag_name, markup, tokens)
      @icon = @options[3] || "octicon-star"
      @link_text = "Star"
    end
    def get_data_count_template
      return @use_count ? [
        "data-count-href=\"/#{@user_name}/#{@repo_name}#stargazers\"",
        "data-count-api=\"/repos/#{@user_name}/#{@repo_name}#stargazers_count\">"
      ].join(' ') : super
    end
  end

  class GitHubFollowButton < GitHubButtonTag
    def initialize(tag_name, markup, tokens)
      super(tag_name, markup, tokens)
      @icon = "octicon-mark-github"
      @link_text = "Follow #{@user_name}"
    end
    def get_data_count_template
      @use_count ? [
        "data-count-href=\"/#{@user_name}/followers\"",
        "data-count-api=\"/users/#{@user_name}#followers\">"
      ].join(' ') : super
    end
  end

  class GitHubForkButton < GitHubButtonTag
    def initialize(tag_name, markup, tokens)
      super(tag_name, markup, tokens)
      @icon = "octicon-git-branch"
      @link_text = "Fork"
    end
    def get_data_count_template
      @use_count ? [
        "data-count-href=\"/#{@user_name}/#{@repo_name}/network\"",
        "data-count-api=\"/repos/#{@user_name}/#{@repo_name}#forks_count}\">"
      ].join(' ') : super
    end
  end

end

Liquid::Template.register_tag('github_star_button', Jekyll::GitHubStarButton)
Liquid::Template.register_tag('github_follow_button', Jekyll::GitHubFollowButton)
Liquid::Template.register_tag('github_fork_button', Jekyll::GitHubForkButton)
