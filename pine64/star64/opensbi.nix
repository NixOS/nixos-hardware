{
  opensbi,
  withPayload,
  withFDT,
}:

(opensbi.override {
  inherit withPayload withFDT;
}).overrideAttrs
  (attrs: {
    makeFlags = attrs.makeFlags ++ [
      # opensbi generic platform default FW_TEXT_START is 0x80000000
      # For JH7110, need to specify the FW_TEXT_START to 0x40000000
      # Otherwise, the fw_payload.bin downloading via jtag will not run.
      # https://github.com/starfive-tech/VisionFive2/blob/7733673d27052dc5a48f1cb1d060279dfa3f0241/Makefile#L274
      "FW_TEXT_START=0x40000000"
    ];
  })
