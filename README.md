# Homebrew Tap for golisten

This is the official Homebrew tap for [golisten](https://github.com/schappim/golisten) - a Go CLI for speech-to-text using a local whisper.cpp or transcribe.cpp install, or the OpenAI, ElevenLabs, and Deepgram APIs, with no ffmpeg required for MP3 or WAV.

golisten is the mirror of [gospeak](https://github.com/schappim/gospeak): gospeak turns text into speech, golisten turns speech into text.

## Installation

```bash
# Add the tap
brew tap schappim/golisten

# Install golisten
brew install golisten

# Upgrade to latest version
brew upgrade golisten
```

## Quick Start

golisten transcribes on your own machine by default, so no API key is needed.

```bash
# Grab the default engine's model (transcribe.cpp with parakeet)
golisten --download parakeet

# Transcribe
golisten interview.mp3
```

If you would rather use whisper.cpp, brew can install the engine:

```bash
brew install whisper-cpp
golisten --download base.en
golisten interview.mp3
```

## Backends

golisten picks the first local engine that has both a binary and a model:
**transcribe.cpp**, then **whisper.cpp**, then whisper.cpp's **parakeet-cli**.
`golisten -V` prints what it chose.

| Provider | Runs | Timestamps | Diarization |
|---|---|---|---|
| `transcribe` | local transcribe.cpp (parakeet, canary, whisper, moonshine, ...) | yes | yes |
| `whisper` | local whisper.cpp | yes | no |
| `parakeet` | local whisper.cpp `parakeet-cli` | no | no |
| `openai` | `/v1/audio/transcriptions` | `whisper-1` only | no |
| `elevenlabs` | `/v1/speech-to-text` | yes | yes |
| `deepgram` | `/v1/listen` | yes | yes |

Cloud backends use the same environment variables gospeak does:

```bash
export OPENAI_API_KEY="your-openai-api-key"
export ELEVENLABS_API_KEY="your-elevenlabs-api-key"
export DEEPGRAM_API_KEY="your-deepgram-api-key"
```

## Output Formats

```bash
golisten -f txt  interview.mp3     # plain text (default)
golisten -f srt  interview.mp3     # SubRip subtitles
golisten -f vtt  interview.mp3     # WebVTT
golisten -f json interview.mp3     # segments with millisecond timings

golisten --timestamps interview.mp3
golisten -f srt -o subs.srt talk.mp4
```

## Examples

```bash
# Anything ffmpeg can open
golisten lecture.m4a

# Pipe audio in, pipe text out
cat note.mp3 | golisten | gospeak -v nova

# Speaker labels
golisten -p deepgram --diarize -f srt panel.mp3

# Summarise a meeting
golisten standup.m4a | llm "Summarise this standup as bullet points"
```

## Documentation

Full documentation is in the [golisten repository](https://github.com/schappim/golisten).

## License

MIT
