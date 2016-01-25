require "spec_helper"

describe CloneGitFile::GithubRepoParser do
  describe "#parse" do
    context "url is file" do
      context "url has no branch" do
        let(:parser) do
          CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/some/file.rb").parse
        end

        it "parses the file path relative to the repo" do
          expect(parser.file_relative_path).to eq("some/file.rb")
        end

        it "parses the authors github username" do
          expect(parser.github_username).to eq("author")
        end

        it "parses the repo name" do
          expect(parser.repo_name).to eq("repo")
        end

        it "parses the base repo url" do
          expect(parser.repo_url).to eq("https://github.com/author/repo")
        end

        it "has a nil branch name" do
          expect(parser.branch_name).to be_nil
        end
      end

      context "url has branch" do
        let(:parser) do
          CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/blob/master/some/file.rb").parse
        end

        it "parses the file path relative to the repo" do
          expect(parser.file_relative_path).to eq("some/file.rb")
        end

        it "parses the authors github username" do
          expect(parser.github_username).to eq("author")
        end

        it "parses the repo name" do
          expect(parser.repo_name).to eq("repo")
        end

        it "parses the base repo url" do
          expect(parser.repo_url).to eq("https://github.com/author/repo")
        end

        it "parses branch name" do
          expect(parser.branch_name).to eq("master")
        end
      end
    end

    context "url is repo root" do
      let(:parser) do
        CloneGitFile::GithubRepoParser.new("https://github.com/author/repo").parse
      end

      it "has a nil relative file path" do
        expect(parser.file_relative_path).to be_nil
      end

      it "parses the authors github username" do
        expect(parser.github_username).to eq("author")
      end

      it "parses the repo name" do
        expect(parser.repo_name).to eq("repo")
      end

      it "parses the base repo url" do
        expect(parser.repo_url).to eq("https://github.com/author/repo")
      end

      it "has a nil branch name" do
        expect(parser.branch_name).to be_nil
      end
    end

    context "url is branch root" do
      let(:parser) do
        CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/tree/master").parse
      end

      it "has a nil relative file path" do
        expect(parser.file_relative_path).to be_nil
      end

      it "parses the authors github username" do
        expect(parser.github_username).to eq("author")
      end

      it "parses the repo name" do
        expect(parser.repo_name).to eq("repo")
      end

      it "parses the base repo url" do
        expect(parser.repo_url).to eq("https://github.com/author/repo")
      end

      it "parses branch name" do
        expect(parser.branch_name).to eq("master")
      end
    end

    context "url is a subdirectory" do
      context "url includes a branch" do
        let(:parser) do
          CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/tree/master/sub/directory").parse
        end

        it "parses the relative path" do
          expect(parser.file_relative_path).to eq("sub/directory")
        end

        it "parses the authors github username" do
          expect(parser.github_username).to eq("author")
        end

        it "parses the repo name" do
          expect(parser.repo_name).to eq("repo")
        end

        it "parses the base repo url" do
          expect(parser.repo_url).to eq("https://github.com/author/repo")
        end

        it "parses branch name" do
          expect(parser.branch_name).to eq("master")
        end
      end

      context "url does not include a branch" do
        let(:parser) do
          CloneGitFile::GithubRepoParser.new("https://github.com/author/repo/sub/directory").parse
        end

        it "parses the relative path" do
          expect(parser.file_relative_path).to eq("sub/directory")
        end

        it "parses the authors github username" do
          expect(parser.github_username).to eq("author")
        end

        it "parses the repo name" do
          expect(parser.repo_name).to eq("repo")
        end

        it "parses the base repo url" do
          expect(parser.repo_url).to eq("https://github.com/author/repo")
        end

        it "has a nil branch name" do
          expect(parser.branch_name).to be_nil
        end
      end
    end
  end

  describe "#valid_url?" do
    context "url contains github.com" do
      it "returns true" do
        url = "https://github.com/auth/repo/blob/master/some_file.rb"
        expect(CloneGitFile::GithubRepoParser.new(url).valid_url?).to eq(true)
      end
    end

    context "url does not contain github.com" do
      it "returns false" do
        url = "https://githu.com/auth/repo/blob/master/some_file.rb"
        expect(CloneGitFile::GithubRepoParser.new(url).valid_url?).to eq(false)
      end
    end

    context "url has two subdirectories" do
      it "returns true" do
        url = "https://github.com/one/two"
        expect(CloneGitFile::GithubRepoParser.new(url).valid_url?).to eq(true)
      end
    end

    context "url does not have at least two subdirectories" do
      it "returns false" do
        url = "https://github.com/one"
        expect(CloneGitFile::GithubRepoParser.new(url).valid_url?).to eq(false)
      end
    end
  end
end
