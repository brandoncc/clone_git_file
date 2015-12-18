require "clone_git_file/version"
require "clone_git_file/github_repo_parser"

module CloneGitFile
  class Cloner
    def initialize(file)
      @file = file
    end

    def open_file
      if Dir.exists?(File.expand_path(local_repo_path))
        update_repo
      else
        clone_repo
      end

      launch_editor
    end

    private

    def parsed_data
      @parsed_data ||= GithubRepoParser.new(@file).parse
    end

    def local_repo_path
      @local_repo_path ||= "#{ENV["TARGET_DIRECTORY"]}/#{parsed_data.github_username}/#{parsed_data.repo_name}"
    end

    def launch_editor
      commands = ""
      file_path = "#{local_repo_path}/#{parsed_data.file_relative_path}"

      # change into the directory so that relative file loads will work
      commands << "cd #{File.dirname(file_path)}"
      commands << "\n#{ENV["EDITOR"]} #{file_path}"
      system(commands)
    end

    def clone_repo
      commands = ""
      commands << "git clone #{parsed_data.repo_url} #{local_repo_path}"

      if parsed_data.branch_name
        commands << "\ncd #{local_repo_path}"
        commands << "\ngit checkout #{parsed_data.branch_name}"
      end

      system(commands)
    end

    def update_repo
      commands = ""

      commands << "cd #{local_repo_path}"
      commands << "\ngit reset HEAD --hard"
      commands << "\ngit pull"
      commands << "\ngit checkout #{parsed_data.branch_name}" if parsed_data.branch_name

      system(commands)
    end
  end
end
