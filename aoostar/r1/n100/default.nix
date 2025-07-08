{
  imports = [
    ../../../common/cpu/intel/alder-lake
  ];

  # lopter@(2025-02-06): according to sensors-detect this comes with an ITE
  # IT8613E super io chip, which is not officialy supported yet. See also:
  #
  # - unofficial driver: https://github.com/frankcrawford/it87
  # - reddit thread on with useful information to configure pwm from the bios:
  #   https://www.reddit.com/r/MiniPCs/comments/1bnkg1u/aoostar_r1r7_question_does_the_fan_header_support/
}
