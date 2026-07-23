class Golisten < Formula
  desc "CLI for speech-to-text using local whisper.cpp/transcribe.cpp, OpenAI, ElevenLabs, or Deepgram - no ffmpeg required"
  homepage "https://github.com/schappim/golisten"
  url "https://github.com/schappim/golisten/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4c4790dd886138ec1d14d685aa75e902083e5bcb7cb466fb3f6e9e59a9518739"
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
    assert_match "golisten", shell_output("#{bin}/golisten --help")
    assert_match "transcribe", shell_output("#{bin}/golisten --help")
    assert_match "parakeet", shell_output("#{bin}/golisten --help")
    assert_match "deepgram", shell_output("#{bin}/golisten --help")

    # A request that no backend can satisfy must fail loudly rather than write
    # an empty transcript.
    output = shell_output("#{bin}/golisten -p parakeet -f srt missing.mp3 2>&1", 1)
    assert_match "timestamps", output
  end
end
