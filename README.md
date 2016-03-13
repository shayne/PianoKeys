# PianoKeys — Control Pianobar using your Mac's media keys

I was really annoyed that I couldn't control [Pianobar][pb] using the
media keys on my Mac, so I wrote an app that does it.

[pb]: https://github.com/PromyLOPh/pianobar

## Features

* Pause/play will do what it's supposed to
* Hold the pause/play key to "love" a track
* Fast forward will also do what it's supposed to
* Hold the fast forward key to "ban" a track
* PianoKeys will automatically terminate after Pianobar closes

## Building

You should be able to just open the Xcode project and build. I developed the
app using Xcode 4.2.

## Installation

The installation requires a few steps, but it's pretty easy to get
up and running, here's what you need to do:

1. Add this to your Pianobar configuration file (`~/.config/pianobar/config`)

        fifo = /Users/USERNAME/.config/pianobar/ctl

2. Create the file pipe

        mkfifo /Users/$USER/.config/pianobar/ctl

3. **If you have Xcode:** Install the application using Xcode from terminal

        # From the project root directory
        xcodebuild -configuration Release install  # installs into /usr/local/bin

3. **If you downloaded the binary:** Copy the `pianokeys` binary into your $PATH
(e.g. `/usr/local/bin`)

        cp ./pianokeys /usr/local/bin

4. *(Optional)* Create a cool alias to start PianoKeys when you start Pianobar

        # Add this to your shell's rc file (e.g. ~/.bashrc)
        alias pianobar='pianokeys && pianobar'


That's it! You should be able to start `pianokeys` and `pianobar` together.

**Note:** PianoKeys will terminate itself if Pianobar is not running after 5
seconds— just keep that in mind when starting it up.
