class Golisten < Formula
  desc "Speech-to-text CLI using local whisper.cpp/transcribe.cpp or cloud APIs"
  homepage "https://github.com/schappim/golisten"
  url "https://github.com/schappim/golisten/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0d57381945aae1867506c29ff5889ba02368f1421c73b859791ebe039fe55c7f"
  license "MIT"
  head "https://github.com/schappim/golisten.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      golisten transcribes locally by default. Install an engine and a model:

        # transcribe.cpp with parakeet (the default backend)
        golisten --download parakeet

        # or whisper.cpp, which brew can install for you
        brew install whisper-cpp
        golisten --download base.en

      Or use a hosted backend by setting one of:
        OPENAI_API_KEY, ELEVENLABS_API_KEY, DEEPGRAM_API_KEY
    EOS
  end

  test do
    # golisten writes its usage to stderr, and Homebrew's shell_output captures
    # stdout only, so the redirect is load-bearing.
    help = shell_output("#{bin}/golisten --help 2>&1")
    assert_match "golisten", help
    assert_match "transcribe", help
    assert_match "parakeet", help
    assert_match "deepgram", help

    # A request no backend can satisfy must fail loudly rather than write an
    # empty transcript.
    output = shell_output("#{bin}/golisten -p parakeet -f srt missing.mp3 2>&1", 1)
    assert_match "timestamps", output

    # Transcribing reaches the engine-discovery stage without a model present.
    (testpath/"empty.mp3").write ""
    assert_match "empty", shell_output("#{bin}/golisten #{testpath}/empty.mp3 2>&1", 1)
  end
end
