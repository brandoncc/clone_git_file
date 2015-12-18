require 'test_helper'

describe CloneGitFile::GithubRepoParser do
  describe "#parse" do
    context "url is file" do
      context "url has no branch" do
        before do
          @parser = CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/some/file.rb").parse
        end

        it "parses the file path relative to the repo" do
          @parser.file_relative_path.must_equal "some/file.rb"
        end

        it "parses the authors github username" do
          @parser.github_username.must_equal "author"
        end

        it "parses the repo name" do
          @parser.repo_name.must_equal "repo"
        end

        it "parses the base repo url" do
          @parser.repo_url.must_equal "https://github.com/author/repo"
        end

        it "has a nil branch name" do
          @parser.branch_name.must_be_nil
        end
      end

      context "url has branch" do
        before do
          @parser = CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/blob/master/some/file.rb").parse
        end

        it "parses the file path relative to the repo" do
          @parser.file_relative_path.must_equal "some/file.rb"
        end

        it "parses the authors github username" do
          @parser.github_username.must_equal "author"
        end

        it "parses the repo name" do
          @parser.repo_name.must_equal "repo"
        end

        it "parses the base repo url" do
          @parser.repo_url.must_equal "https://github.com/author/repo"
        end

        it "parses branch name" do
          @parser.branch_name.must_equal "master"
        end
      end
    end

    context "url is repo root" do
      before do
        @parser = CloneGitFile::GithubRepoParser.new("https://github.com/author/repo").parse
      end

      it "has a blank relative file path" do
        @parser.file_relative_path.must_equal ""
      end

      it "parses the authors github username" do
        @parser.github_username.must_equal "author"
      end

      it "parses the repo name" do
        @parser.repo_name.must_equal "repo"
      end

      it "parses the base repo url" do
        @parser.repo_url.must_equal "https://github.com/author/repo"
      end

      it "has a nil branch name" do
        @parser.branch_name.must_be_nil
      end
    end

    context "url is branch root" do
      before do
        @parser = CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/tree/master").parse
      end

      it "has a blank relative file path" do
        @parser.file_relative_path.must_equal ""
      end

      it "parses the authors github username" do
        @parser.github_username.must_equal "author"
      end

      it "parses the repo name" do
        @parser.repo_name.must_equal "repo"
      end

      it "parses the base repo url" do
        @parser.repo_url.must_equal "https://github.com/author/repo"
      end

      it "parses branch name" do
        @parser.branch_name.must_equal "master"
      end
    end

    context "url is a subdirectory" do
      context "url includes a branch" do
        before do
          @parser = CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/tree/master/sub/directory").parse
        end

        it "parses the relative path" do
          @parser.file_relative_path.must_equal "sub/directory"
        end

        it "parses the authors github username" do
          @parser.github_username.must_equal "author"
        end

        it "parses the repo name" do
          @parser.repo_name.must_equal "repo"
        end

        it "parses the base repo url" do
          @parser.repo_url.must_equal "https://github.com/author/repo"
        end

        it "parses branch name" do
          @parser.branch_name.must_equal "master"
        end
      end

      context "url does not include a branch" do
        before do
          @parser = CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/sub/directory").parse
        end

        it "parses the relative path" do
          @parser.file_relative_path.must_equal "sub/directory"
        end

        it "parses the authors github username" do
          @parser.github_username.must_equal "author"
        end

        it "parses the repo name" do
          @parser.repo_name.must_equal "repo"
        end

        it "parses the base repo url" do
          @parser.repo_url.must_equal "https://github.com/author/repo"
        end

        it "has a nil branch name" do
          @parser.branch_name.must_be_nil
        end
      end
    end
  end

  # we only need enough validation to make sure our parsing methods can function
  describe "#valid_url?" do
    context "url contains github.com" do
      it "returns true" do
        url = "https://github.com/auth/repo/blob/master/some_file.rb"
        CloneGitFile::GithubRepoParser.new(url).valid_url?.must_equal true
      end
    end

    context "url does not contain github.com" do
      it "returns false" do
        url = "https://githu.com/auth/repo/blob/master/some_file.rb"
        CloneGitFile::GithubRepoParser.new(url).valid_url?.must_equal false
      end
    end

    context "url has two subdirectories" do
      it "returns true" do
        url = "https://github.com/one/two"
        CloneGitFile::GithubRepoParser.new(url).valid_url?.must_equal true
      end
    end

    context "url does not have at least two subdirectories" do
      it "returns false" do
        url = "https://github.com/one"
        CloneGitFile::GithubRepoParser.new(url).valid_url?.must_equal false
      end
    end
  end
end
