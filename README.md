android-patch-applier
=====================

For android BSP developer, sometimes we have too apply multiple patches for one feature. With this bash script, we could apply them at one time.

*Uasage*
  1. Input git server name to "GIT_LINK_PREFIX"
  2. Input wanted new branch postfix name to "BRANCH_NAME_POSTFIX"
  3. Input patches info repeatly : register_patch (the first arg is position, the second arg is patch name [according to gerrit])
  4. Run this script at android source tree root directory
