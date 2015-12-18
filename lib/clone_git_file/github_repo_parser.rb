require 'ostruct'

module CloneGitFile
  class GithubRepoParser
    def initialize(file)
      @file = file
    end

    def parse
      abort("Error: That url is not valid") unless valid_url?
      data                    = OpenStruct.new
      data.repo_url           = parse_repo_url
      data.repo_name          = parse_repo_name
      data.github_username    = parse_github_username
      data.file_relative_path = parse_file_relative_path
      data.branch_name        = parse_branch_name
      data
    end

    def valid_url?
      !!@file.match(%r{.+github\.com/[^/]+/[^/]+})
    end

    private

    def parse_github_username
      @file.match(%r{.+github\.com/([^/]+)})[1]
    end

    def parse_repo_url
      @file.match(%r{.+github\.com/[^/]+/[^/]+})[0]
    end

    def parse_repo_name
      @file.match(%r{.+github\.com/[^/]+/([^/]+)})[1]
    end

    def parse_file_relative_path
      path = @file.match(%r{#{Regexp.escape(parse_repo_url)}/(.+)$})[1]
      path.sub!(%r{^(?:blob|tree)/[^/]+}, '') if has_branch?
      path.sub!(%r{^/}, '')
      path
    rescue NoMethodError
      ''
    end

    def has_branch?
      is_branch? || is_tree?
    end

    def parse_branch_name
      return nil unless has_branch?

      @file.match(%r{#{Regexp.escape(parse_repo_url)}/(?:blob|tree)/([^/]+)})[1]
    end

    def is_branch?
      @file.match(%r{#{Regexp.escape(parse_repo_url)}/(blob|tree)/[^/]+/.+})
    end

    def is_tree?
      @file.match(%r{#{Regexp.escape(parse_repo_url)}/tree/[^/]+$})
    end
  end
end
