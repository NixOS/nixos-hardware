#!/usr/bin/env nix-shell
#! nix-shell -p ruby alsaUtils -i ruby

# This script resets the sound state to the minimum required for it to work.
# It will set the control that pulseaudio uses to 20%, everything else to the
# level expected for it to work. The rest will be off or to their default.

require "open3"
require "shellwords"

def run(*cmd)
  puts " $ #{cmd.shelljoin}"
  system(*cmd)
end

FINAL_STATE = {
  ## Simple mixer control 'Headphone',0
  ##   Capabilities: pvolume
  ##   Playback channels: Front Left - Front Right
  ##   Limits: Playback 0 - 3
  ##   Mono:
  ##   Front Left: Playback 0 [0%] [-48.00dB]
  ##   Front Right: Playback 0 [0%] [-48.00dB]
  "Headphone,0" => "20%",
  ## Simple mixer control 'Headphone Mixer',0
  ##   Capabilities: volume
  ##   Playback channels: Front Left - Front Right
  ##   Capture channels: Front Left - Front Right
  ##   Limits: 0 - 11
  ##   Front Left: 0 [0%] [-12.00dB]
  ##   Front Right: 0 [0%] [-12.00dB]
  "Headphone Mixer,0" => "0",
  ## Simple mixer control 'Mic Boost',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [on]
  "Mic Boost,0" => "off",
  ## Simple mixer control 'Playback Polarity',0
  ##   Capabilities: enum
  ##   Items: 'Normal' 'R Invert' 'L Invert' 'L + R Invert'
  ##   Item0: 'Normal'
  "Playback Polarity,0" => "L Invert",
  ## Simple mixer control 'Capture Polarity',0
  ##   Capabilities: enum
  ##   Items: 'Normal' 'Invert'
  ##   Item0: 'Normal'
  "Capture Polarity,0" => "Normal",
  ## Simple mixer control 'ADC',0
  ##   Capabilities: cvolume cvolume-joined
  ##   Capture channels: Mono
  ##   Limits: Capture 0 - 192
  ##   Mono: Capture 0 [0%] [-99999.99dB]
  "ADC,0" => "0",
  ## Simple mixer control 'ADC Double Fs',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "ADC Double Fs,0" => "off",
  ## Simple mixer control 'ADC PGA Gain',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 10
  ##   Mono: 0 [0%]
  "ADC PGA Gain,0" => "0",
  ## Simple mixer control 'ADC Soft Ramp',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [on]
  "ADC Soft Ramp,0" => "on",
  ## Simple mixer control 'ALC',0
  ##   Capabilities: cswitch cswitch-joined
  ##   Capture channels: Mono
  ##   Mono: Capture [off]
  "ALC,0" => "nocap",
  ## Simple mixer control 'ALC Capture Attack Time',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 10
  ##   Mono: 0 [0%]
  "ALC Capture Attack Time,0" => "0",
  ## Simple mixer control 'ALC Capture Decay Time',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 10
  ##   Mono: 0 [0%]
  "ALC Capture Decay Time,0" => "0",
  ## Simple mixer control 'ALC Capture Hold Time',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 10
  ##   Mono: 0 [0%]
  "ALC Capture Hold Time,0" => "0",
  ## Simple mixer control 'ALC Capture Max',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 28
  ##   Mono: 0 [0%] [-6.50dB]
  "ALC Capture Max,0" => "0",
  ## Simple mixer control 'ALC Capture Min',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 28
  ##   Mono: 0 [0%] [-12.00dB]
  "ALC Capture Min,0" => "0",
  ## Simple mixer control 'ALC Capture Noise Gate',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "ALC Capture Noise Gate,0" => "off",
  ## Simple mixer control 'ALC Capture Noise Gate Threshold',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 31
  ##   Mono: 0 [0%]
  "ALC Capture Noise Gate Threshold,0" => "0",
  ## Simple mixer control 'ALC Capture Noise Gate Type',0
  ##   Capabilities: enum
  ##   Items: 'Constant PGA Gain' 'Mute ADC Output'
  ##   Item0: 'Constant PGA Gain'
  "ALC Capture Noise Gate Type,0" => "Constant PGA Gain",
  ## Simple mixer control 'ALC Capture Target',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 10
  ##   Mono: 0 [0%] [-16.50dB]
  "ALC Capture Target,0" => "0",
  ## Simple mixer control 'DAC',0
  ##   Capabilities: pvolume
  ##   Playback channels: Front Left - Front Right
  ##   Limits: Playback 0 - 192
  ##   Mono:
  ##   Front Left: Playback 0 [0%] [-99999.99dB]
  ##   Front Right: Playback 0 [0%] [-99999.99dB]
  "DAC,0" => "100%",
  ## Simple mixer control 'DAC Double Fs',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "DAC Double Fs,0" => "off",
  ## Simple mixer control 'DAC Mono Mix',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "DAC Mono Mix,0" => "off",
  ## Simple mixer control 'DAC Notch Filter',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "DAC Notch Filter,0" => "off",
  ## Simple mixer control 'DAC Soft Ramp',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [on]
  "DAC Soft Ramp,0" => "on",
  ## Simple mixer control 'DAC Soft Ramp Rate',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 4
  ##   Mono: 0 [0%]
  "DAC Soft Ramp Rate,0" => "0",
  ## Simple mixer control 'DAC Source Mux',0
  ##   Capabilities: enum
  ##   Items: 'LDATA TO LDAC, RDATA TO RDAC' 'LDATA TO LDAC, LDATA TO RDAC' 'RDATA TO LDAC, RDATA TO RDAC' 'RDATA TO LDAC, LDATA TO RDAC'
  ##   Item0: 'LDATA TO LDAC, RDATA TO RDAC'
  "DAC Source Mux,0" => "LDATA TO LDAC, RDATA TO RDAC",
  ## Simple mixer control 'DAC Stereo Enhancement',0
  ##   Capabilities: volume volume-joined
  ##   Playback channels: Mono
  ##   Capture channels: Mono
  ##   Limits: 0 - 7
  ##   Mono: 0 [0%]
  "DAC Stereo Enhancement,0" => "0",
  ## Simple mixer control 'Differential Mux',0
  ##   Capabilities: enum
  ##   Items: 'lin1-rin1' 'lin2-rin2' 'lin1-rin1 with 20db Boost' 'lin2-rin2 with 20db Boost'
  ##   Item0: 'lin1-rin1'
  "Differential Mux,0" => "lin1-rin1",
  ## Simple mixer control 'Digital Mic Mux',0
  ##   Capabilities: enum
  ##   Items: 'dmic disable' 'dmic data at high level' 'dmic data at low level'
  ##   Item0: 'dmic disable'
  "Digital Mic Mux,0" => "dmic disable",
  ## Simple mixer control 'Left Headphone Mixer LLIN',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "Left Headphone Mixer LLIN,0" => "off",
  ## Simple mixer control 'Left Headphone Mixer Left DAC',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "Left Headphone Mixer Left DAC,0" => "on",
  ## Simple mixer control 'Left Headphone Mux',0
  ##   Capabilities: enum
  ##   Items: 'lin1-rin1' 'lin2-rin2' 'lin-rin with Boost' 'lin-rin with Boost and PGA'
  ##   Item0: 'lin1-rin1'
  "Left Headphone Mux,0" => "lin1-rin1",
  ## Simple mixer control 'Right Headphone Mixer RLIN',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "Right Headphone Mixer RLIN,0" => "off",
  ## Simple mixer control 'Right Headphone Mixer Right DAC',0
  ##   Capabilities: pswitch pswitch-joined
  ##   Playback channels: Mono
  ##   Mono: Playback [off]
  "Right Headphone Mixer Right DAC,0" => "on",
  ## Simple mixer control 'Right Headphone Mux',0
  ##   Capabilities: enum
  ##   Items: 'lin1-rin1' 'lin2-rin2' 'lin-rin with Boost' 'lin-rin with Boost and PGA'
  ##   Item0: 'lin1-rin1'
  "Right Headphone Mux,0" => "lin1-rin1",
}

FINAL_STATE.each do |name, value|
  run("amixer", "-c0", "sset", name, value.to_s)
  raise "Error setting #{name} to #{value}" unless $?.success?
end
